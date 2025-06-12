import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:mekinaparking/constant/constant.dart';
import 'package:mekinaparking/constant/show_toast_dialog.dart';
import 'package:mekinaparking/controller/vehicle_qr_conrtoller.dart';
import 'package:mekinaparking/model/user_vehicle_model.dart';
import 'package:mekinaparking/themes/app_them_data.dart';
import 'package:mekinaparking/themes/common_ui.dart';
import 'package:mekinaparking/utils/dark_theme_provider.dart';
import 'package:mekinaparking/utils/network_image_widget.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VehicleQrScreen extends StatelessWidget {
  const VehicleQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<VehicleQrController>(
        init: VehicleQrController(),
        builder: (controller) {
          return Scaffold(
            appBar: UiInterface()
                .customAppBar(context, themeChange, "Vehicle Qr".tr),
            body: controller.isLoading.value
                ? Constant.loader()
                : controller.userVehicle.isEmpty
                    ? Constant.showEmptyView(
                        message: "You have to create vehicle first".tr)
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.separated(
                          itemCount: controller.userVehicle.length,
                          shrinkWrap: true,
                          itemBuilder: (context, int index) {
                            UserVehicleModel userVehicleModel =
                                controller.userVehicle[index];
                            Map<String, String> qrDataMap = {
                              "vehicleNumber":
                                  userVehicleModel.vehicleNumber.toString(),
                              "userId": userVehicleModel.userId.toString(),
                              "id": userVehicleModel.id.toString(),
                            };
                            String qrData = jsonEncode(qrDataMap);

                            return InkWell(
                              onTap: () {
                                controller.selectedVehicle.value =
                                    userVehicleModel;
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: themeChange.getThem()
                                      ? AppThemData.grey10
                                      : AppThemData.grey03,
                                ),
                                child: Row(
                                  children: [
                                    NetworkImageWidget(
                                      height: 60,
                                      width: 60,
                                      imageUrl: userVehicleModel
                                          .vehicleModel!.image
                                          .toString(),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userVehicleModel.vehicleModel!.name
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: AppThemData.medium,
                                                color: themeChange.getThem()
                                                    ? AppThemData.grey01
                                                    : AppThemData.grey08),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            userVehicleModel.vehicleNumber
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: AppThemData.medium,
                                                color: themeChange.getThem()
                                                    ? AppThemData.grey07
                                                    : AppThemData.grey07),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RepaintBoundary(
                                      key: controller.globalKeys[index],
                                      child: Container(
                                        height: 120,
                                        width: 120,
                                        color: Colors.white,
                                        child: QrImageView(
                                          data: qrData,
                                          version: QrVersions.auto,
                                          padding: EdgeInsets.zero,
                                          size: 120.0,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.download),
                                      onPressed: () async {
                                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                                          RenderRepaintBoundary boundary =
                                          controller.globalKeys[index].currentContext!.findRenderObject()
                                          as RenderRepaintBoundary;
                                          if (boundary.debugNeedsPaint) {
                                            await Future.delayed(const Duration(milliseconds: 200));
                                          }
                                          ui.Image image = await boundary.toImage(pixelRatio: 5.0);
                                          ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                                          if (byteData != null) {
                                            await ImageGallerySaverPlus.saveImage(
                                              byteData.buffer.asUint8List(),
                                              name: "qr_code_${controller.userVehicle[index].id}",
                                              quality: 100,
                                            );
                                            ShowToastDialog.showToast("Image saved successfully");
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 20,
                            );
                          },
                        ),
                      ),
          );
        });
  }

}
