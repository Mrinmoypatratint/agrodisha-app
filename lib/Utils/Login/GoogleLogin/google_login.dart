import 'package:eClassify/Utils/Login/lib/login_status.dart';
import 'package:eClassify/Utils/Login/lib/login_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLogin extends LoginSystem {
  @override
  void init() {
    // Nothing here anymore
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<UserCredential?> login() async {
    try {
      emit(MProgress());

      // 1️⃣ Start Google Sign-In
      final GoogleSignInAccount? googleUser =
      await GoogleSignIn().signIn();

      // User canceled login
      if (googleUser == null) {
        emit(MFail("Login cancelled by user"));
        return null;
      }

      // 2️⃣ Get authentication details
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // 3️⃣ Create Firebase credential
      final AuthCredential credential =
      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4️⃣ Sign in to Firebase
      final UserCredential userCredential =
      await firebaseAuth.signInWithCredential(credential);

      emit(MSuccess());

      return userCredential;
    } catch (e) {
      emit(MFail(e.toString()));
      rethrow;
    }
  }


  @override
  void onEvent(MLoginState state) {}
}
