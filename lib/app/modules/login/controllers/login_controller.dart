import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hershield/app/modules/admin_app/adminHome/model/EmeregencyHubDataModel.dart';
import 'package:hershield/app/modules/groupchat/model/ExploreFeature.dart';
import 'package:hershield/app/modules/home/model/EmergencyHubModel.dart';
import 'package:hershield/app/modules/policeHelpLine/model/ListTileModel.dart';
import 'package:hershield/app/modules/profile/views/profile_view.dart';
import 'package:hershield/app/routes/app_pages.dart';
import 'package:hershield/app/services/AuthService.dart';
import 'package:hershield/app/services/HubRepository.dart';
import 'package:hershield/constant/image_path.dart';
import 'package:hershield/constant/strings.dart';
import 'package:hershield/shared/easyloading.dart';

class LoginController extends GetxController {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController resetPasswordEditingController =
      TextEditingController();
  final formKey = GlobalKey<FormState>().obs;
  RxBool isRemember = true.obs;
  List<ListTileModel> modelList = [];
  List<ListTileModel> auratModelListInfo = [];
  List<ListTileModel> ambulanceModelListInfo = [];
  List<ExploreFeature> exploreFeatureModelListInfo = [];

  HubRepository repositor = HubRepository();
  RxInt currentIndex = 1.obs;
  List<String> quoteList = [];
  List<EmergencyHubModel> homeModel = [];
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    // Repository().getUserDataSteam();
    checkUserIsLogedIn();
    setData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    textEditingController.dispose();
    passwordEditingController.dispose();
    resetPasswordEditingController.dispose();
    super.onClose();
  }

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

  Future<void> logedInUser() async {
    await Repository().loginUserAccount(
        textEditingController.text, passwordEditingController.text);
  }

  Future<void> resetPassword(String email) async {
    await Repository().resetPassword(email: email);
  }

  Future<void> setData() async {
    Stream<List<EmergencyHubModel>> modelStream = repositor.getAllHubData();
    modelStream.listen((List<EmergencyHubModel> data) {
      if (data.isEmpty) {
        print("store data");
        addData();
      } else {
        print("Data already present");
      }
    }, onError: (error) {
      // Handle any errors that occur while listening to the stream
      print("Error: $error");
    });
  }

  void addData() {
    /// AMBULANCE HELPLINE INFO LIST
    /// AMBULANCE HELPLINE INFO LIST
    ambulanceModelListInfo.add(ListTileModel(
        iconData: addressVector,
        title: title1,
        subTtile: amBulanceSubtitle1,
        mapLink: ambulanceMapLink));
    ambulanceModelListInfo.add(ListTileModel(
        iconData: callVector,
        title: title2,
        subTtile: amBulanceSubtitle2,
        mapLink: ""));
    ambulanceModelListInfo.add(ListTileModel(
        iconData: mapVector, title: title3, subTtile: subtitle3, mapLink: ""));

    /// POLICE HELPLINE INFO LIST
    modelList.add(ListTileModel(
        iconData: addressVector,
        title: title1,
        subTtile: subtitle1,
        mapLink: policeMapLink));
    modelList.add(ListTileModel(
        iconData: callVector, title: title2, subTtile: subtitle2, mapLink: ""));
    modelList.add(ListTileModel(
        iconData: mapVector, title: title3, subTtile: subtitle3, mapLink: ""));

    /// AURAT-FOUNDATION HELPLINE INFO LIST

    auratModelListInfo.add(ListTileModel(
        iconData: addressVector,
        title: title1,
        subTtile: auratSubTitle1,
        mapLink: ngoMapLink));
    auratModelListInfo.add(ListTileModel(
        iconData: callVector,
        title: title2,
        subTtile: auratSubTitle2,
        mapLink: ""));
    auratModelListInfo.add(ListTileModel(
      iconData: mapVector,
      title: title3,
      subTtile: auratSubTitle3,
      mapLink: "",
    ));

    homeModel.add(EmergencyHubModel(
        docID: "1",
        title: police,
        imgPath: car,
        destinationPath: Routes.POLICE_HELP_LINE,
        argument: modelList,
        argTitle: police));
    homeModel.add(EmergencyHubModel(
        docID: "2",
        title: humanitarian,
        imgPath: auratPath,
        destinationPath: Routes.POLICE_HELP_LINE,
        argument: auratModelListInfo,
        argTitle: humanitarian));
    homeModel.add(EmergencyHubModel(
        docID: "3",
        title: Ambulance,
        imgPath: ambulance,
        destinationPath: Routes.POLICE_HELP_LINE,
        argument: ambulanceModelListInfo,
        argTitle: Ambulance));

    repositor.addHubData(homeModel[0], "1");
    repositor.addHubData(homeModel[1], "2");
    repositor.addHubData(homeModel[2], "3");
  }

  void checkUserIsLogedIn() async {
    Repository repository = Repository();
    Loading.showLoading();
    bool flag = await repository.isUserLoggedIn();
    if (flag) {
      print(flag);
      Loading.dismissLoading();
      Get.offAllNamed(Routes.BOTTOMNAV);
    } else if (storage.read("isAdminLogIn") == "true") {
      Loading.dismissLoading();
      Get.offAllNamed(Routes.ADMIN_HOME);
    } else {
      Loading.dismissLoading();
    }
  }
}
