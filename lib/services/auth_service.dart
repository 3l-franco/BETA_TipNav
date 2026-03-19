import 'package:firebase_auth/firebase_auth.dart';

// handles all firebase auth stuff

final FirebaseAuth _auth = FirebaseAuth.instance;

// get current logged in user
User? get currentUser => _auth.currentUser;

// stream - used in splash to check if logged in or not
Stream<User?> get authStateChanges => _auth.authStateChanges();

// sign in - returns null if success, error string if failed
Future<String?> signIn(String email, String password) async {
  try {
    await _auth.signInWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password.trim(),
    );
    return null;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return "No account found for that email.";
    } else if (e.code == 'wrong-password') {
      return "Invalid email or password.";
    } else if (e.code == 'invalid-email') {
      return "Invalid email format.";
    } else if (e.code == 'user-disabled') {
      return "This account has been disabled.";
    } else if (e.code == 'invalid-credential') {
      // firebase combines wrong email/password into this one now
      return "Invalid email or password.";
    } else {
      return "Login failed. Please try again.";
    }
  } catch (e) {
    return "No internet connection!";
  }
}

// sign up - returns null if success, error string if failed
Future<String?> signUp(String email, String password) async {
  try {
    await _auth.createUserWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password.trim(),
    );
    return null;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return "Password is too weak. Use at least 6 characters.";
    } else if (e.code == 'email-already-in-use') {
      return "Email is already registered!";
    } else if (e.code == 'invalid-email') {
      return "Invalid email format.";
    } else {
      return "Sign up failed. Please try again.";
    }
  } catch (e) {
    return "No internet connection!";
  }
}

// sign out - firebase handles clearing the session
Future<void> signOut() async {
  await _auth.signOut();
}
