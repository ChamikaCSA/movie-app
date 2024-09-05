import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<String> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    String response = '';
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(username);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        response = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        response = 'An account already exists for that email.';
      } else {
        response = e.message!;
      }
    } catch (e) {
      response = 'An unexpected error occurred. Please try again later.';
    }
    return response;
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    String response = '';

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        response = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        response = 'Incorrect password. Please try again.';
      } else if (e.code == 'invalid-credential') {
        response = 'Invalid credentials. Please try again.';
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        response = 'Invalid login credentials. Please try again.';
      } else if (e.code == 'too-many-requests') {
        response = 'Too many requests. Please try again later.';
      } else {
        response = e.message!;
      }
    } catch (e) {
      response = 'An unexpected error occurred. Please try again later.';
    }
    return response;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
