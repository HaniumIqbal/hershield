import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hershield/app/modules/signup/model/UserInformation.dart';
import 'package:hershield/app/services/AuthService.dart';

class ProfileController extends GetxController {
  //TODO: Implement SignupController
  Rx<TextEditingController> fNameEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> lNameEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> passwordEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> phoneEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> emailEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> reEnterPassEditingController =
      TextEditingController().obs;

  final formKey = GlobalKey<FormState>().obs;
  RxBool isRemember = false.obs;
  final UserInformation userInformation = UserInformation(
      fName: "", lName: "", emailAddress: "", password: "", phoneNumber: "");

  final count = 0.obs;

  @override
  void onInit() {
    // setEditController();
    getUserData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // fNameEditingController.value.dispose();
    // lNameEditingController.value.dispose();
    // passwordEditingController.value.dispose();
    // phoneEditingController.value.dispose();
    // emailEditingController.value.dispose();
    // reEnterPassEditingController.value.dispose();
    super.onClose();
  }

  void increment() => count.value++;

  void submit() {
    final isValid = formKey.value.currentState!.validate();
    if (!isValid!) {
      return;
    }
    formKey.value.currentState!.save();
  }

  void switchCheckBox() {
    isRemember.value = !isRemember.value;
  }

  Future<UserInformation?> getUserData() async {
    Repository().getUserDataSteam().listen((event) {
      print("GET DATA");
      print(event!.emailAddress);

      userInformation.fName = event!.fName!;
      userInformation.lName = event!.lName!;
      userInformation.phoneNumber = event!.phoneNumber!;
      userInformation.emailAddress = event!.emailAddress!;
      userInformation.password = event!.password!;
      fNameEditingController.value.text = event!.fName!;
      lNameEditingController.value.text = event!.lName!;
      phoneEditingController.value.text = event!.phoneNumber!;
      emailEditingController.value.text = event!.emailAddress!;
      passwordEditingController.value.text = event!.password!;
    });
  }

  void updateUser() {
    if (formKey.value.currentState!.validate()) {
      UserInformation userInformation = UserInformation(
          fName: fNameEditingController.value.text,
          lName: lNameEditingController.value.text,
          emailAddress: emailEditingController.value.text,
          password: passwordEditingController.value.text,
          phoneNumber: phoneEditingController.value.text);
      print(userInformation.fName);
      Repository().setUserAccountInfo(
          userInformation, FirebaseAuth.instance.currentUser!.uid);
    }
  }

  Future<void> logutUser() async {
    await Repository().isSignOut();
  }
}
