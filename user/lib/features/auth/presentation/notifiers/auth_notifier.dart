import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

enum AuthStatus { initial, loading, authenticated, unauthenticated, error, codeSent, registrationSuccess }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final String? verificationId;
  final UserModel? user;

  AuthState({
    required this.status,
    this.errorMessage,
    this.verificationId,
    this.user,
  });

  factory AuthState.initial() => AuthState(status: AuthStatus.initial);
  
  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? verificationId,
    UserModel? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      verificationId: verificationId ?? this.verificationId,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  late final AuthService _authService;
  late final FirestoreService _firestoreService;

  @override
  AuthState build() {
    _authService = ref.watch(authServiceProvider);
    _firestoreService = ref.watch(firestoreServiceProvider);
    
    // Check if user is already logged in
    _checkInitialAuth();
    
    return AuthState.initial();
  }

  Future<void> _checkInitialAuth() async {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser != null) {
      try {
        final userModel = await _firestoreService.getUser(firebaseUser.uid);
        if (userModel != null) {
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: userModel,
          );
        }
      } catch (e) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final credential = await _authService.signInWithEmail(email, password);
      final userModel = await _firestoreService.getUser(credential.user!.uid);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: userModel,
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> registerWithEmail(String email, String password, String name, String phoneNumber) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      // 1. Attempt to create the user in Firebase Auth
      dynamic credential;
      try {
        credential = await _authService.signUpWithEmail(email, password);
      } catch (e) {
        // 2. If email is taken, it might be a partial registration (Auth exists, Firestore failed)
        if (e.toString().contains('email-already-in-use')) {
          credential = await _authService.signInWithEmail(email, password);
          // Check if this user exists in Firestore
          final existing = await _firestoreService.getUser(credential.user!.uid);
          if (existing != null) {
            throw 'An account with this email already exists and is fully set up. Please login instead.';
          }
          // If not in Firestore, proceed to create the document
        } else {
          rethrow;
        }
      }

      // 3. Create the user document in Firestore
      final user = UserModel(
        uid: credential.user!.uid,
        fullName: name,
        email: email,
        phoneNumber: phoneNumber,
        balance: 0.0,
      );
      
      await _firestoreService.saveUser(user);
      
      // 4. Log out to ensure they go to Login page as requested
      await _authService.signOut();
      
      state = state.copyWith(
        status: AuthStatus.registrationSuccess,
        errorMessage: 'Account created! Please login to continue.',
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> verifyOTP(String otp) async {
    if (state.verificationId == null) return;
    
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final credential = await _authService.signInWithOTP(
        verificationId: state.verificationId!,
        smsCode: otp,
      );
      
      final userModel = await _firestoreService.getUser(credential.user!.uid);
      if (userModel != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: userModel,
        );
      } else {
        // Partial registration via phone
        state = state.copyWith(status: AuthStatus.unauthenticated);
        throw 'Profile not found. Please register first.';
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> sendPasswordReset(String email) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _authService.sendPasswordResetEmail(email);
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> sendOTP(String phoneNumber) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _authService.verifyPhone(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          // Auto-resolution if possible
        },
        verificationFailed: (e) {
          state = state.copyWith(status: AuthStatus.error, errorMessage: e.message);
        },
        codeSent: (verificationId, resendToken) {
          state = state.copyWith(status: AuthStatus.codeSent, verificationId: verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          state = state.copyWith(verificationId: verificationId);
        },
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    state = AuthState.initial();
  }

  Future<void> updateProfile({String? name, String? profilePic}) async {
    if (state.user == null) return;
    
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final updatedUser = state.user!.copyWith(
        fullName: name ?? state.user!.fullName,
        profileImage: profilePic ?? state.user!.profileImage,
      );
      
      await _firestoreService.saveUser(updatedUser);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: updatedUser,
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }
}
