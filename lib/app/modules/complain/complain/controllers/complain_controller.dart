import 'package:flutter/cupertino.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ComplainController extends GetxController {
  //TODO: Implement ComplainController
  TextEditingController subjectEditingController = TextEditingController();
  TextEditingController bodyEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>().obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }
  void submit() {
    final isValid = formKey.value.currentState!.validate();
    if (!isValid!) {
      return;
    }
    formKey.value.currentState!.save();
  }
  @override
  void onClose() {
    super.onClose();
  }



  Future launchEmailAppUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
  bool submitForm() {
    if (formKey.value.currentState!.validate()) {
      formKey.value.currentState!.save();
      // Handle form submission
      return true;

    }
    return false;
  }




  void increment() => count.value++;
}
