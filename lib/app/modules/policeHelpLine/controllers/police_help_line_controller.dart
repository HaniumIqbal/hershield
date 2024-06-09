import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hershield/app/modules/admin_app/adminHome/model/EmeregencyHubDataModel.dart';
import 'package:hershield/app/modules/home/controllers/home_controller.dart';
import 'package:hershield/app/modules/home/model/EmergencyHubModel.dart';
import 'package:hershield/app/modules/policeHelpLine/model/ListTileModel.dart';
import 'package:hershield/app/services/HubRepository.dart';
import 'package:hershield/constant/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class PoliceHelpLineController extends GetxController {
  //TODO: Implement PoliceHelpLineController
  final HomeController homeController = HomeController();
  List<ListTileModel> modelList = [];
  int index = 0;
  @override
  void onInit() {
    index = Get.arguments[0];
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future launchMapUrl(String url, String query) async {
    String finalUrl =
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeFull(query)}';
    if (query == "") {
      if (!await launchUrl(Uri.parse(url))) {
        throw Exception('Could not launch $url');
      }
    } else {
      if (!await launchUrl(Uri.parse(finalUrl))) {
        throw Exception('Could not launch $url');
      }
    }
  }
}
