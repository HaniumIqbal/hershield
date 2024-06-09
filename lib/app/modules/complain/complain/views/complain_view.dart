import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:get/get.dart';
import 'package:hershield/constant/colors.dart';
import 'package:hershield/widget/custom_textfield.dart';
import 'package:hershield/widget/my_button.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/complain_controller.dart';

class ComplainView extends GetView<ComplainController> {
  const ComplainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.lightPinkColor,
      appBar: AppBar(
        backgroundColor: MyColor.lightPinkColor,
        title: const Text('ComplainView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(

                onChange: (value){
                  controller.subjectEditingController.text = value!;

                },
                  textEditingController
                      : controller.subjectEditingController,
                  hint: "Add subject"),
              const SizedBox(
                height: 12,
              ),
              CustomTextField(

                onChange: (value){
                  controller.bodyEditingController.text = value!;
                },
                maxLine: 7,
                  textEditingController: controller.bodyEditingController,
                  hint: "Enter your message..."),
              const SizedBox(
                height: 26,
              ),

              MyButton(title: "Send", onTab: () async {
                 if(controller.subjectEditingController.text.isEmpty){
                   Get.snackbar("Empty", "Please enter your subject",backgroundColor: Colors.red,colorText: Colors.white);
                 }
                 else if(controller.bodyEditingController.text.isEmpty){
                   Get.snackbar("Empty", "Please enter your message",backgroundColor: Colors.red,colorText: Colors.white);
                 }
                 else{

                   final Uri _emailLaunchUri = Uri(
                       scheme: 'mailto',
                       path: 'hrcp@hrcp-web.org',
                       queryParameters: {
                         'subject': controller.subjectEditingController.text,
                         'body': controller.bodyEditingController.text
                       }
                   );
                   controller.launchEmailAppUrl(_emailLaunchUri);
                   controller.bodyEditingController.text = "";
                   controller.subjectEditingController.text = "";
                 }
              }
                ),
              ])
      )
          )
    );
  }

}
