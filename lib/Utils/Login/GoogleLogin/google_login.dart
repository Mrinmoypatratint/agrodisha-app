import 'dart:io';

import 'package:eClassify/Utils/Login/lib/login_status.dart';
import 'package:eClassify/Utils/Login/lib/login_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLogin extends LoginSystem {
  // Web client ID from Google Cloud Console (client_type 3 in google-services.json).
  // Required on iOS so that google_sign_in returns a valid idToken for Firebase Auth.
  static const String _webClientId =
      '827090007541-r6mjb8e5f02abdp5g00e5e24rmpe4ctr.apps.googleusercontent.com';

  late final GoogleSignIn _googleSignIn;

  @override
  void init() {
    _googleSignIn = GoogleSignIn(
      // On Android the serverClientId triggers the idToken being returned.
      // On iOS the native SDK picks up CLIENT_ID from GoogleService-Info.plist
      // but still needs serverClientId for the backend idToken.
      serverClientId: _webClientId,
    );
  }

  @override
  Future<UserCredential?> login() async {
    try {
      emit(MProgress());

      // 1️⃣ Start Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // User canceled login
      if (googleUser == null) {
        emit(MFail("Login cancelled by user"));
        return null;
      }

      // 2️⃣ Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3️⃣ Create Firebase credential
      final AuthCredential credential = GoogleAuthProvider.credential(
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
