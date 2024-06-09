import 'package:get/get.dart';

import '../controllers/update_feature_data_controller.dart';

class UpdateFeatureDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateFeatureDataController>(
      () => UpdateFeatureDataController(),
    );
  }
}
