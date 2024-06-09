import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hershield/app/modules/login/views/login_view.dart';
import 'package:hershield/app/routes/app_pages.dart';
import 'package:hershield/constant/image_path.dart';
import 'package:hershield/constant/strings.dart';
import 'package:hershield/widget/custom_text.dart';
import 'package:hershield/widget/custom_textfield.dart';
import 'package:hershield/widget/my_button.dart';

import '../../../../../constant/colors.dart';
import '../controllers/admin_login_controller.dart';

class AdminLoginView extends GetView<AdminLoginController> {
  const AdminLoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColor.lightPinkColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  adminVector,
                  width: MediaQuery.of(context).size.width * .7,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              CustomText(
                text: "Login to Admin Dashboard",
                color: MyColor.pinkTextColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 28,
              ),
              CustomTextField(
                textEditingController: controller.textEditingController,
                hint: "Name",
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                hint: "Password",
                textEditingController: controller.passwordEditingController,
                textInputType: TextInputType.number,
              ),
              const SizedBox(
                height: 12,
              ),
              const SizedBox(
                height: 20,
              ),
              MyButton(
                  title: 'Login',
                  onTab: () {
                    if (controller.textEditingController.text.isEmpty ||
                        controller.passwordEditingController.text.isEmpty) {
                      Get.snackbar("Empty", "Name and password are required",
                          backgroundColor: Colors.red, colorText: Colors.white);
                    } else {
                      print(controller.passwordEditingController.text);
                      if (controller.passwordEditingController.text == "2244") {
                        controller.loginAdmin();
                      } else {
                        Get.snackbar("Invalid", "Incorrect password",
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                      }
                    }
                  }),
              Center(
                  child: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const CustomText(
                        text: "Login as User?",
                        color: Colors.black,
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
