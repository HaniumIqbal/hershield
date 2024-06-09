import 'package:get/get.dart';
import 'package:hershield/app/modules/groupchat/model/ExploreFeature.dart';
import 'package:hershield/app/modules/selfdefence/model/SelfDefenceModel.dart';
import 'package:hershield/constant/image_path.dart';

class SelfdefenceController extends GetxController {
  //TODO: Implement SelfdefenceController
  List<SelfDefenceModel> selfDefenseItemList = [];
  RxBool isLoading = true.obs;

  final count = 0.obs;
  @override
  void onInit() {
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
    selfDefenseItemList.add(SelfDefenceModel(self3,
        "https://youtu.be/KVpxP3ZZtAc?si=SBZA6LeiO3E6lkk2", " Watch Video "));
    selfDefenseItemList.add(SelfDefenceModel(self5,
        "https://youtu.be/Gx3_x6RH1J4?si=ZO4SgOAOBWAMStUO", " Watch Video "));
    selfDefenseItemList.add(SelfDefenceModel(selfWomen,
        "https://www.youtube.com/watch?v=-V4vEyhWDZ0", " Watch Video "));
    selfDefenseItemList
        .add(SelfDefenceModel(weapon, "https://kzgear.pk/", " Buy Weapon "));
  }
}
