import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:green_ranger/globalVar.dart';

class FirebaseAuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final GlobalVar globalVar = GlobalVar.instance;

  static User? get currentUser => _firebaseAuth.currentUser;

  static Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  static Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true; // Sign-in succeeded
    } catch (e) {
      print('Firebase: Error signing in with email and password: $e');
      return false; // Sign-in failed
    }
  }

  static Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      globalVar.userLoginData = null;
    } catch (e) {
      print('Firebase: Error signing out: $e');
      throw e;
    }
  }

  static Future<bool> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true; // Account creation succeeded
    } catch (e) {
      print('Firebase: Error creating user: $e');
      return false; // Account creation failed
    }
  }

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print('Firebase: Error signing in with Google: $e');
      throw e;
    }
  }
}
