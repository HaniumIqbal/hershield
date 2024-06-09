import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hershield/app/modules/home/model/EmergencyHubModel.dart';
import 'package:hershield/app/modules/policeHelpLine/model/ListTileModel.dart';
import 'package:hershield/app/services/HubRepository.dart';

class UpdateFeatureDataController extends GetxController {
  TextEditingController addressEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  late EmergencyHubModel emergencyHubModel;
  List<ListTileModel> list = [];
  HubRepository repository = HubRepository();

  final count = 0.obs;
  @override
  void onInit() {
    emergencyHubModel = Get.arguments;
    print(emergencyHubModel.title);
    setData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void setData() {
    if (emergencyHubModel.title.isNotEmpty) {
      list = emergencyHubModel.argument;
      print(list.length);
      addressEditingController.text = list[0].subTtile;
      phoneEditingController.text = list[1].subTtile;
    }
  }

  void updateData(EmergencyHubModel model, String docID) async {
    await repository.updateHubData(model, docID);
  }
}
