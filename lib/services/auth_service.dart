import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

User? get currentUser => _auth.currentUser;

Stream<User?> get authStateChanges => _auth.authStateChanges();

// LEM - added username param so we can save it as displayName on signup
Future<String?> signUp(String email, String password, String username) async {
  try {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password.trim(),
    );
    // LEM - save username right after account is made
    await cred.user?.updateDisplayName(username.trim());
    return null;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'Password is too weak. Use at least 6 characters.';
    } else if (e.code == 'email-already-in-use') {
      return 'Email is already registered!';
    } else if (e.code == 'invalid-email') {
      return 'Invalid email format.';
    } else {
      return 'Sign up failed. Please try again.';
    }
  } catch (e) {
    return 'No internet connection!';
  }
}

Future<String?> signIn(String email, String password) async {
  try {
    await _auth.signInWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password.trim(),
    );
    return null;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return 'No account found for that email.';
    } else if (e.code == 'wrong-password') {
      return 'Invalid email or password.';
    } else if (e.code == 'invalid-email') {
      return 'Invalid email format.';
    } else if (e.code == 'user-disabled') {
      return 'This account has been disabled.';
    } else if (e.code == 'invalid-credential') {
      return 'Invalid email or password.';
    } else {
      return 'Login failed. Please try again.';
    }
  } catch (e) {
    return 'No internet connection!';
  }
}

Future<void> signOut() async {
  await _auth.signOut();
}
