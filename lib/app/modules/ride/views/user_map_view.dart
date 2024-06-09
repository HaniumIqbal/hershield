import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hershield/app/modules/ride/controllers/ride_controller.dart';
import 'package:hershield/constant/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class UserMapView extends GetView<RideController> {
  const UserMapView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserMapView'),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
