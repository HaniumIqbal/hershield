import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loading {
  static void showLoading() {
    EasyLoading.show(status: "loading...");
  }

  static void dismissLoading() {
    EasyLoading.dismiss();
  }

  static void showSuccess() {
    EasyLoading.showSuccess('Success!');
  }

  static void showError() {
    EasyLoading.showError('Failed with Error');
  }
}
