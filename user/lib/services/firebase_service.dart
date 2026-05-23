import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());

class FirebaseService {
  Future<void> init() async {
    // Note: You must add your google-services.json / GoogleService-Info.plist
    // before this can run successfully in a real app.
    await Firebase.initializeApp();
  }
}
