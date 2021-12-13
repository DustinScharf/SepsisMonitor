import 'package:firebase_auth/firebase_auth.dart';

class AuthManager {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  start() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _isLoggedIn = false;
      } else {
        _isLoggedIn = true;
      }
    });
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
