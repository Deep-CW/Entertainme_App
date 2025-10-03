// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../constant/app_constants.dart';
import '../main.dart';

import '../widgets/app_snackbar.dart';

class LoginService {
  static FirebaseAuth auth = FirebaseAuth.instance;

  //google Login
  static googleLogin() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        // Getting users credential
        UserCredential result = await auth.signInWithCredential(authCredential);

        return result;
        // if (result != t.user;
        // var uid = renull) {
        // user = resulsult.user?.uid;

        // box.write(AppConstants.USER_ID, uid);
        // box.write(AppConstants.IS_NETWORK_IMG, true);
        // box.write(AppConstants.SOCIAL_LOGIN, true);
        // box.write(
        //     AppConstants.USER_NAME, result.user!.displayName.toString());
        // box.write(AppConstants.EMAIL_ID, result.user!.email.toString());
        // box.write(AppConstants.PROFILE_IMG, result.user!.photoURL.toString());
        // }
        // appSnackbar(content: 'Login successful', error: false);
        // return u;
      } else {
        appSnackbar(content: 'Login unsuccessful', error: true);
        return null;
      }
    } catch (e) {
      appSnackbar(content: 'Google Error: ${e.toString()}', error: true);
      print("ERROR::: ${e.toString()}");
      return null;
    }
  }

  //facebook Login
  static facebookLogin() async {
    try {
      final result = await FacebookAuth.instance
          .login(loginBehavior: LoginBehavior.webOnly);

      print("Facebook login result: ${result.accessToken!.token}");
      switch (result.status) {
        case LoginStatus.success:
          final credential =
              FacebookAuthProvider.credential(result.accessToken!.token);

          UserCredential userCredential =
              await auth.signInWithCredential(credential);

          // if (result != null) {
          //   user = userCredential.user;
          //   var uid = userCredential.user?.uid;

          // box.write(AppConstants.USER_ID, uid);
          // box.write(AppConstants.IS_LOGIN, true);
          // box.write(AppConstants.USER_NAME,
          //     auth.currentUser?.displayName.toString());
          // box.write(AppConstants.IS_NETWORK_IMG, true);
          // box.write(AppConstants.SOCIAL_LOGIN, true);
          // box.write(
          //     AppConstants.EMAIL_ID, auth.currentUser?.email.toString());
          // box.write(AppConstants.PROFILE_IMG,
          //     auth.currentUser?.photoURL.toString());

          // appSnackbar(content: 'Login successful', error: false);
          // }

          return userCredential;

        case LoginStatus.cancelled:
          print('Facebook login cancelled');
          appSnackbar(content: 'Login cancelled', error: true);

          return null;
        case LoginStatus.failed:
          print('Facebook login failed');
          appSnackbar(content: 'Login failed', error: true);

          return null;
        default:
          return null;
      }
    } catch (e) {
      print("Facebook error:=> ${e.toString()}");
      appSnackbar(content: 'Facebook Error: ${e.toString()}', error: true);

      return null;
    }
  }

  //apple login
  static appleLogin() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential != null) {
        return credential;
      } else {
        return null;
      }
    } catch (e) {
      appSnackbar(content: 'Apple Error: ${e.toString()}', error: true);
      print("ERROR::: ${e.toString()}");
      return null;
    }
  }

  static signOut() async {
    try {
      await auth.signOut();
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
      String email = box.read(AppConstants.EMAIL_ID).toString();
      String password = box.read(AppConstants.PASSWORD).toString();
      String userEmail = '';
      String userPassword = '';
      String businessEmail = '';
      String businessPassword = '';

      bool isUser = box.read(AppConstants.IS_USER) ?? false;
      bool rememberMeUser = box.read(AppConstants.REMEMBER_ME_USER) ?? false;
      bool rememberMeBusiness =
          box.read(AppConstants.REMEMBER_ME_BUSINESS) ?? false;
      if (isUser) {
        box.write(AppConstants.EMAIL_ID_USER, email);
        box.write(AppConstants.PASSWORD_USER, password);
        userEmail = box.read(AppConstants.EMAIL_ID_USER).toString();
        userPassword = box.read(AppConstants.PASSWORD_USER).toString();
      } else {
        box.write(AppConstants.EMAIL_ID_BUSINESS, email);
        box.write(AppConstants.PASSWORD_BUSINESS, password);
        businessEmail = box.read(AppConstants.EMAIL_ID_BUSINESS).toString();
        businessPassword = box.read(AppConstants.PASSWORD_BUSINESS).toString();
      }
      eraseData();

      if (isUser) {
        box.write(AppConstants.EMAIL_ID_USER, userEmail);
        box.write(AppConstants.PASSWORD_USER, userPassword);
      } else {
        box.write(AppConstants.EMAIL_ID_BUSINESS, businessEmail);
        box.write(AppConstants.PASSWORD_BUSINESS, businessPassword);
      }
      box.write(AppConstants.EMAIL_ID, email);
      box.write(AppConstants.PASSWORD, password);
      box.write(AppConstants.IS_USER, isUser);
      box.write(AppConstants.REMEMBER_ME_USER, rememberMeUser);
      box.write(AppConstants.REMEMBER_ME_BUSINESS, rememberMeBusiness);
    } catch (e) {
      print("GET ERROR::: $e");
    }
  }

  static eraseData() async {
    List<String> keysToRetain = [
      AppConstants.EMAIL_ID,
      AppConstants.PASSWORD,
      AppConstants.IS_USER,
      AppConstants.REMEMBER_ME_USER,
      AppConstants.REMEMBER_ME_BUSINESS,
      AppConstants.EMAIL_ID_USER,
      AppConstants.PASSWORD_USER,
      AppConstants.EMAIL_ID_BUSINESS,
      AppConstants.PASSWORD_BUSINESS,
    ];
    List<String> allKeys = box.getKeys().toList();

    for (String key in allKeys) {
      if (!keysToRetain.contains(key)) {
        box.remove(key);
      }
    }
  }
}
