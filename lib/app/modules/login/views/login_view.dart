import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hershield/app/modules/profile/controllers/profile_controller.dart';
import 'package:hershield/app/routes/app_pages.dart';
import 'package:hershield/constant/colors.dart';
import 'package:hershield/constant/image_path.dart';
import 'package:hershield/widget/my_button.dart';
import '../../../../constant/strings.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/custom_textfield.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.checkUserIsLogedIn();
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
                  height: 40,
                ),
                Center(
                  child: Image.asset(
                    welcomeVector,
                    width: MediaQuery.of(context).size.width * .8,
                  ),
                ),
                CustomText(
                  text: welcome,
                  color: MyColor.pinkTextColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 12,
                ),
                const CustomText(
                  text: "Login into your account",
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 18,
                ),
                CustomTextField(
                  textEditingController: controller.textEditingController,
                  hint: "Email Address",
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextField(
                  hint: "Password",
                  textEditingController: controller.passwordEditingController,
                ),
                const SizedBox(
                  height: 12,
                ),
                Obx(() {
                  return Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: FittedBox(
                          child: CustomCheckBox(
                            onChanged: (value) {
                              controller.switchCheckBox();
                            },
                            isRemember: controller.isRemember.value,
                            text: "Remember Me!",
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                      child: BottomSheetWidget(
                                    controller: controller,
                                  ));
                                });
                            // showModalBottomSheet(
                            //   backgroundColor: MyColor.lightPinkColor,
                            //   shape: const RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.only(
                            //     topRight: Radius.circular(12),
                            //     topLeft: Radius.circular(12),
                            //   )),
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return BottomSheetWidget(
                            //         controller: controller);
                            //   },
                            // );
                          },
                          child: CustomText(
                            text: "Forgot Password?",
                            color: Colors.black.withOpacity(0.58),
                            fontSize: 14,
                            isUnderline: true,
                          ),
                        ),
                      )
                    ],
                  );
                }),
                Row(
                  children: [
                    const CustomText(
                      text: "Now?",
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.SIGNUP);
                      },
                      child: CustomText(
                        text: "Sign up now",
                        color: MyColor.signTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyButton(
                    title: 'Login',
                    onTab: () {
                      print("jj");
                      controller.submit();
                      if (controller.formKey.value.currentState!.validate()) {
                        controller.logedInUser();
                      }
                    }),
                Center(
                    child: TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.ADMIN_LOGIN);
                        },
                        child: const CustomText(
                          text: "Login as Admin?",
                          color: Colors.black,
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({super.key, required this.controller});

  final LoginController controller;

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CustomText(
            text: "Reset your password",
            color: MyColor.pinkTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            height: 18,
          ),
          CustomTextField(
              textEditingController: _textEditingController,
              hint: "Enter your email"),
          const SizedBox(height: 16.0),
          MyButton(
              title: "Send",
              onTab: () {
                if (_textEditingController.text.contains("@gmail.com")) {
                  widget.controller.resetPassword(_textEditingController.text);
                  Get.back();
                } else {
                  Get.snackbar(
                      "Email error", "Please enter valid email address",
                      backgroundColor: Colors.red);
                }
              }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    required this.isRemember,
    required this.onChanged,
    required this.text,
  });

  final bool isRemember;
  final ValueChanged onChanged;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: [
          Checkbox(
            value: isRemember,
            onChanged: onChanged,
            activeColor: MyColor.pinkTextColor,
            fillColor: MaterialStateProperty.all(Colors.white),
            checkColor: MyColor.pinkTextColor,
            side: BorderSide.none,
          ),
          CustomText(
            text: text,
            color: Colors.black.withOpacity(0.68),
            fontSize: 13,
          ),
        ],
      ),
    );
  }
}
