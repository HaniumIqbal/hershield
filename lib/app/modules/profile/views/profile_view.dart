import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:hershield/app/modules/login/views/login_view.dart';
import 'package:hershield/app/routes/app_pages.dart';
import 'package:hershield/constant/colors.dart';
import 'package:hershield/widget/custom_text.dart';
import 'package:hershield/widget/custom_textfield.dart';
import 'package:hershield/widget/my_button.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);

  ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColor.lightPinkColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: controller.formKey.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      child: CustomText(
                        text: "User Name",
                        color: MyColor.pinkTextColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.logutUser();
                      },
                      icon: const Icon(
                        Icons.logout,
                        size: 30,
                      ),
                      color: MyColor.pinkTextColor,
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Obx(() {
                  return CustomTextField(
                    textEditingController:
                        controller.fNameEditingController.value,
                    hint: "First Name",
                  );
                }),
                const SizedBox(
                  height: 12,
                ),
                Obx(() {
                  return CustomTextField(
                    hint: "Last Name",
                    textEditingController:
                        controller.lNameEditingController.value,
                  );
                }),
                const SizedBox(
                  height: 12,
                ),
                Obx(() {
                  return CustomTextField(
                    hint: "Phone no",
                    textEditingController:
                        controller.phoneEditingController.value,
                    isPrefix: true,
                    textInputType: TextInputType.number,
                  );
                }),
                const SizedBox(
                  height: 12,
                ),
                IgnorePointer(
                  ignoring: true,
                  child: Obx(() {
                    return CustomTextField(
                      hint: "Email Address",
                      textEditingController:
                          controller.emailEditingController.value,
                    );
                  }),
                ),
                // Obx(() {
                //   return CustomTextField(
                //     hint: "Password",
                //     textEditingController: controller.passwordEditingController
                //         .value,
                //     isPrefix: true,
                //     textInputType: TextInputType.visiblePassword,
                //   );
                // }),

                const SizedBox(
                  height: 40,
                ),
                MyButton(
                  title: 'Update',
                  onTab: () {
                    controller.submit();
                    if (controller.formKey.value.currentState!.validate()) {
                      controller.updateUser();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
