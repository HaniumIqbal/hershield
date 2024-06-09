import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:hershield/constant/colors.dart';
import 'package:hershield/widget/custom_text.dart';
import 'package:hershield/widget/custom_textfield.dart';
import 'package:hershield/widget/my_button.dart';

import '../controllers/update_feature_data_controller.dart';

class UpdateFeatureDataView extends GetView<UpdateFeatureDataController> {
  const UpdateFeatureDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText(
            text: "Update Data",
            color: Colors.white,
          ),
          centerTitle: true,
          backgroundColor: MyColor.pinkTextColor,
        ),
        backgroundColor: MyColor.lightPinkColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: controller.emergencyHubModel.title,
                color: MyColor.pinkTextColor,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  CustomText(
                    text: controller.list[0].title,
                    color: MyColor.pinkTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    maxLines: 4,
                    onChanged: (text) {
                      controller.addressEditingController.text = text;
                    },
                    controller: controller.addressEditingController,
                    decoration: const InputDecoration(
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  CustomText(
                    text: controller.list[1].title,
                    color: MyColor.pinkTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    maxLines: 2,
                    onChanged: (text) {
                      controller.phoneEditingController.text = text;
                    },
                    controller: controller.phoneEditingController,
                    decoration: const InputDecoration(
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(
                    height: 46,
                  ),
                  MyButton(
                      title: "Update",
                      onTab: () {
                        if (controller.phoneEditingController.text.isEmpty ||
                            controller.addressEditingController.text.isEmpty) {
                          print(controller.list[0].title);
                          Get.snackbar("Empty",
                              "Address and helpline should not be null",
                              colorText: Colors.white,
                              backgroundColor: Colors.redAccent);
                        } else {
                          controller.list[0].subTtile =
                              controller.addressEditingController.text;
                          controller.list[1].subTtile =
                              controller.phoneEditingController.text;
                          controller.emergencyHubModel.argument =
                              controller.list;
                          controller.updateData(controller.emergencyHubModel,
                              controller.emergencyHubModel.docID);
                        }
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
