import 'package:firebase_auth/firebase_auth.dart';

class PerfilController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<void> updateEmail(String email) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateEmail(email);
    }
  }

  Future<void> updatePassword(String password) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(password);
    }
  }

  Future<void> updateNickname(String nickname) async {
  }
}