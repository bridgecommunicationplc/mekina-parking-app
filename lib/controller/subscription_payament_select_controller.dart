import 'dart:convert';
import 'dart:io';
import 'dart:math' as maths;

// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mekinaparking/constant/show_toast_dialog.dart';
import 'package:mekinaparking/model/payment/razorpay_failed_model.dart';
import 'package:mekinaparking/model/payment_method_model.dart';
import 'package:mekinaparking/model/user_model.dart';
import 'package:mekinaparking/utils/fire_store_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SubscriptionPaymentSelectController extends GetxController {
  Rx<PaymentModel> paymentModel = PaymentModel().obs;
  RxString selectedPaymentMethod = "".obs;
  RxBool isLoading = false.obs;

  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    getPaymentData();
    super.onInit();
  }

  getPaymentData() async {
    isLoading.value = true;
    await FireStoreUtils().getPayment().then((value) {
      if (value != null) {
        paymentModel.value = value;
        // selectedPaymentMethod.value = orderModel.value.paymentType.toString();
        // Stripe.publishableKey =
        //     paymentModel.value.strip!.clientpublishableKey.toString();
        // Stripe.merchantIdentifier = 'MekinaParking';
        // Stripe.instance.applySettings();
        setRef();

        razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
        razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWaller);
        razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
      }
    });

    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid())
        .then((value) {
      if (value != null) {
        userModel.value = value;
      }
    });

    isLoading.value = false;
    update();
  }

  Timestamp calculateExpiryDate(String monthsStr) {
    final int months = int.tryParse(monthsStr) ?? 0;
    final now = DateTime.now();
    final expiryDate = DateTime(now.year, now.month + months, now.day);
    return Timestamp.fromDate(expiryDate);
  }

  final Razorpay razorPay = Razorpay();
  String? ref;

  setRef() {
    maths.Random numRef = maths.Random();
    int year = DateTime.now().year;
    int refNumber = numRef.nextInt(20000);
    if (Platform.isAndroid) {
      ref = "AndroidRef$year$refNumber";
    } else if (Platform.isIOS) {
      ref = "IOSRef$year$refNumber";
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    ShowToastDialog.showToast("Payment Successful!!");
    // completeOrder();
  }

  void handleExternalWaller(ExternalWalletResponse response) {
    ShowToastDialog.showToast("Payment Processing!! via");
  }

  void handlePaymentError(PaymentFailureResponse response) {
    RazorPayFailedModel lom =
        RazorPayFailedModel.fromJson(jsonDecode(response.message!.toString()));
    ShowToastDialog.showToast("Payment Failed!!");
  }
}
