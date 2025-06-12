import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekinaparking/constant/constant.dart';
import 'package:mekinaparking/model/coupon_model.dart';
import 'package:mekinaparking/model/order_model.dart';

class ReviewSummaryController extends GetxController {
  Rx<TextEditingController> couponCodeTextFieldController =
      TextEditingController().obs;
  RxDouble extraDurationInHours = 0.0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Rx<OrderModel> orderModel = OrderModel().obs;
  RxDouble couponAmount = 0.0.obs;
  Rx<CouponModel> selectedCouponModel = CouponModel().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      orderModel.value = argumentData['orderModel'];
      if (orderModel.value.coupon != null) {
        if (orderModel.value.coupon!.id != null) {
          if (orderModel.value.coupon!.type == "fix") {
            couponAmount.value =
                double.parse(orderModel.value.coupon!.amount.toString());
          } else {
            couponAmount.value =
                double.parse(orderModel.value.subTotal.toString()) *
                    double.parse(orderModel.value.coupon!.amount.toString()) /
                    100;
          }
        }
      }
    }
    update();

    if (orderModel.value.parkingInTime != null &&
        orderModel.value.parkingOutTime != null) {
      DateTime inTime = orderModel.value.parkingInTime!.toDate();
      DateTime outTime = orderModel.value.parkingOutTime!.toDate();

      DateTime startTime = orderModel.value.bookingStartTime!.toDate();
      DateTime endTime = orderModel.value.bookingEndTime!.toDate();
      if (inTime != null) {
        if (outTime.isAfter(endTime)) {
          Duration extraTime = outTime.difference(endTime);
          extraDurationInHours.value += extraTime.inMinutes / 60;
        }
      }
      // if (inTime.isAfter(startTime)) {
      //   Duration differenceOutStart = outTime.difference(startTime);
      //   extraDurationInHours.value = differenceOutStart.inMinutes / 60;
      // } else {
      //   Duration differenceOutIn = outTime.difference(inTime);
      //   extraDurationInHours.value = differenceOutIn.inMinutes / 60;
      // }
    }
    update();
  }

  double calculateAmount() {
    if (orderModel.value.coupon != null) {
      if (orderModel.value.coupon!.id != null) {
        if (orderModel.value.coupon!.type == "fix") {
          couponAmount.value =
              double.parse(orderModel.value.coupon!.amount.toString());
        } else {
          couponAmount.value =
              double.parse(orderModel.value.subTotal.toString()) *
                  double.parse(orderModel.value.coupon!.amount.toString()) /
                  100;
        }
      }
    }
    RxString taxAmount = "0.0".obs;
    if (orderModel.value.taxList != null) {
      for (var element in orderModel.value.taxList!) {
        taxAmount.value = (double.parse(taxAmount.value) +
                Constant().calculateTax(
                    amount:
                        (double.parse(orderModel.value.subTotal.toString()) -
                                double.parse(couponAmount.toString()))
                            .toString(),
                    taxModel: element))
            .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
      }
    }
    double perHrPrice = 0.0;
    double extraTimeHours = 0.0;
    if (orderModel.value.isExtraTimeRequestAccept == true) {
      perHrPrice =
          double.tryParse(orderModel.value.perHrPrice?.toString() ?? '0') ??
              0.0;
      extraTimeHours =
          double.tryParse(orderModel.value.extraTimeHours ?? '0') ?? 0.0;
    }

    double perHrPriceValue= orderModel.value.perHrPrice!=null?double.parse(orderModel.value.perHrPrice.toString()):0.0;
        return (double.parse(orderModel.value.subTotal.toString()) -
            double.parse(couponAmount.toString())) +
        double.parse(taxAmount.value) +
        (perHrPriceValue *
            extraDurationInHours.value) +
        (perHrPrice * extraTimeHours);
  }
}
