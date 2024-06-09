import 'package:get/get.dart';

import '../modules/admin_app/adminHome/bindings/admin_home_binding.dart';
import '../modules/admin_app/adminHome/views/admin_home_view.dart';
import '../modules/admin_app/adminLogin/bindings/admin_login_binding.dart';
import '../modules/admin_app/adminLogin/views/admin_login_view.dart';
import '../modules/admin_app/updateChatData/bindings/update_chat_data_binding.dart';
import '../modules/admin_app/updateChatData/views/update_chat_data_view.dart';
import '../modules/admin_app/updateFeatureData/bindings/update_feature_data_binding.dart';
import '../modules/admin_app/updateFeatureData/views/update_feature_data_view.dart';
import '../modules/complain/complain/bindings/complain_binding.dart';
import '../modules/complain/complain/views/complain_view.dart';
import '../modules/groupchat/bindings/groupchat_binding.dart';
import '../modules/groupchat/views/groupchat_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/bottom_nav_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/map/bindings/map_binding.dart';
import '../modules/map/views/map_view.dart';
import '../modules/policeHelpLine/bindings/police_help_line_binding.dart';
import '../modules/policeHelpLine/views/police_help_line_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/ride/UserLiveMap/bindings/user_live_map_binding.dart';
import '../modules/ride/UserLiveMap/views/user_live_map_view.dart';
import '../modules/ride/bindings/ride_binding.dart';
import '../modules/ride/views/ride_view.dart';
import '../modules/ride/views/user_map_view.dart';
import '../modules/selfdefence/bindings/selfdefence_binding.dart';
import '../modules/selfdefence/views/selfdefence_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOMNAV,
      page: () => BottomNavView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.POLICE_HELP_LINE,
      page: () => PoliceHelpLineView(),
      binding: PoliceHelpLineBinding(),
    ),
    GetPage(
      name: _Paths.GROUPCHAT,
      page: () => const GroupchatView(),
      binding: GroupchatBinding(),
    ),
    GetPage(
      name: _Paths.SELFDEFENCE,
      page: () => const SelfdefenceView(),
      binding: SelfdefenceBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_LOGIN,
      page: () => const AdminLoginView(),
      binding: AdminLoginBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_HOME,
      page: () => const AdminHomeView(),
      binding: AdminHomeBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_FEATURE_DATA,
      page: () => const UpdateFeatureDataView(),
      binding: UpdateFeatureDataBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_CHAT_DATA,
      page: () => const UpdateChatDataView(),
      binding: UpdateChatDataBinding(),
    ),
    GetPage(
      name: _Paths.MAP,
      page: () => MapView(),
      binding: MapBinding(),
    ),
    GetPage(
      name: _Paths.RIDE,
      page: () => const RideView(),
      binding: RideBinding(),
      children: [
        GetPage(
          name: _Paths.USER_LIVE_MAP,
          page: () => const UserLiveMapView(),
          binding: UserLiveMapBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.USER_MAP_VIEW,
      page: () => const UserMapView(),
      binding: RideBinding(),
    ),
    GetPage(
      name: _Paths.COMPLAIN,
      page: () => const ComplainView(),
      binding: ComplainBinding(),
    ),
  ];
}
