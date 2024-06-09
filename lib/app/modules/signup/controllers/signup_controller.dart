import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hershield/app/modules/signup/model/UserInformation.dart';
import 'package:hershield/app/services/AuthService.dart';

class SignupController extends GetxController {
  //TODO: Implement SignupController
  Repository repository = Repository();

  TextEditingController fNameEditingController = TextEditingController();
  TextEditingController lNameEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController reEnterPassEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>().obs;
  RxBool isRemember = false.obs;

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
    fNameEditingController.dispose();
    lNameEditingController.dispose();
    passwordEditingController.dispose();
    phoneEditingController.dispose();
    emailEditingController.dispose();
    reEnterPassEditingController.dispose();

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

  void setEditControllerEmpty() {
    fNameEditingController.text = "";
    lNameEditingController.text = "";
    passwordEditingController.text = "";
    phoneEditingController.text = "";
    emailEditingController.text = "";
    reEnterPassEditingController.text = "";
  }

  void createUserAccount() async {
    UserInformation userInformation = UserInformation(
        fName: fNameEditingController.text,
        lName: lNameEditingController.text,
        emailAddress: emailEditingController.text,
        password: passwordEditingController.text,
        phoneNumber: phoneEditingController.text);
    if (userInformation != null) {
      await repository
          .createUserAccount(userInformation, userInformation.emailAddress!,
              userInformation.password!)
          .then((value) {
        if (value!.user!.email!.isNotEmpty) {
          print(value.user!.email);
          setEditControllerEmpty();
        }
      });
    }
  }
}
