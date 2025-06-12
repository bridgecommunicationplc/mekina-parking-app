import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekinaparking/model/user_vehicle_model.dart';
import 'package:mekinaparking/utils/fire_store_utils.dart';

class VehicleQrController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<UserVehicleModel> userVehicle = <UserVehicleModel>[].obs;
  Rx<UserVehicleModel> selectedVehicle = UserVehicleModel().obs;
  RxList<GlobalKey> globalKeys = <GlobalKey>[].obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  getArgument() async {
    await getVehicleList();
    globalKeys.value = List.generate(userVehicle.length, (_) => GlobalKey());
    isLoading.value = false;
    update();
  }

  getVehicleList() async {
    isLoading.value = true;
    userVehicle.clear();
    await FireStoreUtils.getUserVehicle().then((value) {
      if (value != null) {
        userVehicle.value = value;
      }
    });
    isLoading.value = false;
  }
}
