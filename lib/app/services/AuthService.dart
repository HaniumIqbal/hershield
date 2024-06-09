import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hershield/app/modules/signup/model/UserInformation.dart';
import 'package:hershield/app/routes/app_pages.dart';
import 'package:hershield/shared/easyloading.dart';

import '../modules/signup/controllers/signup_controller.dart';

class Repository {
  final firebaseUser = FirebaseAuth.instance.currentUser;

  Future<UserCredential?> createUserAccount(
      UserInformation userInformation, String email, String password) async {
    try {
      Loading.showLoading();
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        if (value.user != null) {
          setUserAccountInfo(userInformation, value.user!.uid);
          return value.user;
        }
      });
    } catch (e) {
      Get.snackbar("Eroor", e.toString(), backgroundColor: Colors.green);
      Loading.dismissLoading();
    }
    return null;
  }

  Future<void> loginUserAccount(String email, String password) async {
    try {
      Loading.showLoading();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        if (value.user!.uid != null) {
          Loading.dismissLoading();
          Get.offAllNamed(Routes.BOTTOMNAV);
        }
      });
    } catch (e) {
      Loading.dismissLoading();
      Get.snackbar("Error", "${e}", backgroundColor: Colors.red);
    }
  }

  Future<void> isSignOut() async {
    Loading.showLoading();
    await FirebaseAuth.instance.signOut().then((_) {
      Loading.dismissLoading();
      Get.offAllNamed(Routes.LOGIN);
    }).catchError((error) {
      Loading.dismissLoading();
      // Handle any errors that occurred during sign-out
    });
  }

  Future<void> setUserAccountInfo(UserInformation user, String userID) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .set(user.toJson());
      Loading.showSuccess();
      Get.offAllNamed(Routes.BOTTOMNAV);
    } catch (e) {
      Loading.showError();
      Loading.dismissLoading();
    }
  }

  Future<bool> isUserLoggedIn() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user != null;
  }

  Stream<UserInformation?> getUserDataSteam() {
    if (firebaseUser != null) {
      var data = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .map((event) {
        if (event.exists) {
          return UserInformation.fromJson(event.data()!);
        } else {
          return null;
        }
      });
      return data;
    } else {
      dynamic data = "";
      return data;
    }
  }

  Future<void> resetPassword({required String email}) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) {
      Get.snackbar("Please check your email",
          "A reset password link has been sent to your email",
          backgroundColor: Colors.green);
    }).catchError((e) {
      Get.snackbar("Error", "${e}", backgroundColor: Colors.red);
    });
  }
}
