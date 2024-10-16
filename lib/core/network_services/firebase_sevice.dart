import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../features/home/model/roomModel.dart';
import '../../features/login/model/login_model.dart';
import '../../features/register/model/register_model.dart';
import '../../features/register/model/user_info.dart';
import 'fireBase_data.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> login(LoginRequestBody loginRequest) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: loginRequest.email,
        password: loginRequest.password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found for that email.';
        case 'wrong-password':
          throw 'Wrong password provided for that user.';
        default:
          throw 'Login failed. Please try again.';
      }
    } catch (e) {
      print('Login error: $e');
      throw 'An unknown error occurred during login.';
    }
  }

  Future resetPass(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Reset  error: $e');
    }
  }

  Future<User?> register(RegisterRequestBody requestBody) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: requestBody.email,
        password: requestBody.password,
      );

      User? user = userCredential.user;

      if (user != null) {
        UserProfile userProfile = UserProfile(
          id: user.uid,
          name: requestBody.name,
          email: requestBody.email,
          phoneNumber: requestBody.phoneNumber,
          createdAt: DateTime.now().toIso8601String(),
          about: "New user",
          online: true,
          lastActivated: DateTime.now().toIso8601String(),
          pushToken: 'example-push-token',
        );

        await FireBaseData().createUserProfile(userProfile);
      }

      return user;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  Future<User?> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      // Trigger the Google sign-in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("User canceled Google sign-in");
        return null; // User canceled the Google sign-in
      }

      // Obtain authentication from the Google account
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a credential using the Google account's authentication tokens
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in to Firebase using the Google credentials
      final userCredential = await _auth.signInWithCredential(credential);

      print("Google sign-in successful: ${userCredential.user?.email}");

      return userCredential.user; // Return the signed-in user
    } catch (e) {
      // Print a detailed error message if Google sign-in fails
      print('Google login error: $e');
      return null; // Return null to indicate login failure
    }
  }

  Future<User?> registerWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        User? user = userCredential.user;
        if (user != null) {
          await FireBaseData().createUserProfile(UserProfile(
            id: user.uid,
            name: user.displayName ?? "New User",
            email: user.email ?? "",
            phoneNumber:
                "from gooogle",
            createdAt: DateTime.now().toIso8601String(),
            about: "I'm a new user",
            online: true,
            lastActivated: DateTime.now().toIso8601String(),
            pushToken: 'example-push-token',
          ));
        }
      }
      return userCredential.user;
    } catch (e) {
      print('Google registration error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
    } catch (e) {
      print('Error logging out: $e');
      throw e;
    }
  }
}
