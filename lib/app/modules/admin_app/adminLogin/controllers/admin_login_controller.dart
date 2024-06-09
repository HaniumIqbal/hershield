import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hershield/app/routes/app_pages.dart';
import 'package:hershield/app/services/AuthService.dart';

class AdminLoginController extends GetxController {
  //TODO: Implement AdminLoginController
  final storage = GetStorage();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  RxString nameErrorText = "".obs;
  RxString passErrorText = "".obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    textEditingController.dispose();
    passwordEditingController.dispose();
    super.onClose();
  }

  Future<void> loginAdmin() async {
    await storage.write("isAdminLogIn", "true");
    textEditingController.text = "";
    passwordEditingController.text = "";
    if (storage.read("isAdminLogIn") == "true") {
      Get.offAllNamed(Routes.ADMIN_HOME);
    } else {}
  }
}
