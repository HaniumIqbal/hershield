import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hershield/app/modules/login/views/login_view.dart';
import 'package:hershield/constant/colors.dart';
import 'package:hershield/widget/custom_text.dart';
import 'package:hershield/widget/custom_textfield.dart';
import 'package:hershield/widget/my_button.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.lightPinkColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_sharp,
            color: MyColor.pinkTextColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: controller.formKey.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Create Your Account",
                color: MyColor.pinkTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              FittedBox(
                child: Row(
                  children: [
                    const CustomText(
                      text: "Already joined?",
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: CustomText(
                        text: "Log In",
                        color: MyColor.pinkTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextField(
                textEditingController: controller.fNameEditingController,
                hint: "First Name",
                textInputType: TextInputType.name,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextField(
                hint: "Last Name",
                textEditingController: controller.lNameEditingController,
                textInputType: TextInputType.name,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextField(
                hint: "Phone no",
                textEditingController: controller.phoneEditingController,
                isPrefix: true,
                textInputType: TextInputType.number,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextField(
                hint: "Email Address",
                textEditingController: controller.emailEditingController,
                textInputType: TextInputType.emailAddress,
                validate: (value) {
                  if (value!.isEmpty) {
                    return "Email is required";
                  } else if (value!.contains("@") && value!.contains(".com")) {
                  } else {
                    return "Invalid email address";
                  }
                },
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextField(
                hint: "Password",
                textEditingController: controller.passwordEditingController,
                obSecure: true,
                validate: (value) {
                  if (value!.length <= 5) {
                    return "Password should be at least 6 characters";
                  }
                },
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextField(
                hint: "Re-enter Password",
                textEditingController: controller.reEnterPassEditingController,
                obSecure: true,
              ),
              const SizedBox(
                height: 12,
              ),
              Obx(() {
                return CustomCheckBox(
                  onChanged: (value) {
                    controller.switchCheckBox();
                  },
                  isRemember: controller.isRemember.value,
                  text: "I agree to HerSheild’s terms and Conditions",
                );
              }),
              const SizedBox(
                height: 20,
              ),
              MyButton(
                  title: 'Register',
                  onTab: () {
                    controller.submit();
                    if (controller.formKey.value.currentState!.validate()) {
                      if (controller.passwordEditingController.text !=
                          controller.reEnterPassEditingController.text) {
                        Get.snackbar("Password", "Your password not match",
                            backgroundColor: Colors.red);
                      } else if (!controller.emailEditingController.text
                              .contains("@") &&
                          !controller.emailEditingController.text
                              .contains(".com")) {
                        Get.snackbar(
                            "Email error", "Please enter proper email address",
                            backgroundColor: Colors.red);
                      }
                      controller.createUserAccount();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
