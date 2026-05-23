import 'package:firebase_core/firebase_core.dart';

class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => 'AppException: [$code] $message';
}

class NetworkException extends AppException {
  NetworkException([String message = 'Check your internet connection']) : super(message, 'network-error');
}

class AuthException extends AppException {
  AuthException(String message, [String? code]) : super(message, code);
}

class FirestoreException extends AppException {
  FirestoreException(String message, [String? code]) : super(message, code);
}

AppException handleFirebaseError(dynamic e) {
  if (e is FirebaseException) {
    return AppException(e.message ?? 'Firebase error', e.code);
  }
  return AppException(e.toString());
}
