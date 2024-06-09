import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hershield/app/modules/home/model/EmergencyHubModel.dart';
import 'package:hershield/app/routes/app_pages.dart';
import 'package:hershield/app/services/HubRepository.dart';

class AdminHomeController extends GetxController {
  RxList<EmergencyHubModel> homeModel = RxList<EmergencyHubModel>();
  HubRepository hubRepository = HubRepository();
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    getHubData();
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

  Stream<List<EmergencyHubModel>> getHubData() {
    hubRepository.getAllHubData().listen((event) {
      homeModel.value = event;
      print(homeModel.value[0].argument[0].subTtile);
    });
    return hubRepository.getAllHubData();
  }

  Future<void> logOutAdmin() async {
    await storage.write("isAdminLogIn", "false");
    if (storage.read("isAdminLogIn") == "false") {
      Get.offAndToNamed(Routes.LOGIN);
    } else {}
  }
}
