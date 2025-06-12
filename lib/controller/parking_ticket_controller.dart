import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mekinaparking/constant/constant.dart';
import 'package:mekinaparking/model/order_model.dart';
import 'package:mekinaparking/model/wallet_transaction_model.dart';
import 'package:mekinaparking/utils/fire_store_utils.dart';

class ParkingTicketController extends GetxController {
  RxDouble extraDurationInHours = 0.0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Rx<OrderModel> orderModel = OrderModel().obs;
  RxBool isLoading = true.obs;

  RxDouble couponAmount = 0.0.obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      orderModel.value = argumentData['orderModel'];
      update();
    }
    isLoading.value = false;
    update();
    if( orderModel.value.parkingInTime!=null && orderModel.value.parkingOutTime!=null){
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
                                couponAmount.value)
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
    return (double.parse(orderModel.value.subTotal.toString()) -
            couponAmount.value) +
        double.parse(taxAmount.value) +
        (double.parse(orderModel.value.perHrPrice.toString()) *
            extraDurationInHours.value)+
        (perHrPrice *
            extraTimeHours);
  }

  canceledOrderWallet() async {
    WalletTransactionModel transactionModel = WalletTransactionModel(
        id: Constant.getUuid(),
        amount: calculateAmount().toString(),
        createdDate: Timestamp.now(),
        paymentType: "Wallet",
        transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: FireStoreUtils.getCurrentUid(),
        isCredit: true,
        note: "Refund Amount");

    await FireStoreUtils.setWalletTransaction(transactionModel)
        .then((value) async {
      if (value == true) {
        await FireStoreUtils.updateUserWallet(
            amount: calculateAmount().toString());
      }
    });

    WalletTransactionModel transactionParkingModel = WalletTransactionModel(
        id: Constant.getUuid(),
        amount: "-${calculateAmount().toString()}",
        createdDate: Timestamp.now(),
        paymentType: "Wallet",
        transactionId: orderModel.value.id,
        isCredit: false,
        userId: orderModel.value.parkingDetails!.userId.toString(),
        note: "Parking amount revers");

    await FireStoreUtils.setWalletTransaction(transactionParkingModel)
        .then((value) async {
      if (value == true) {
        await FireStoreUtils.updateOtherUserWallet(
            amount: "-${calculateAmount().toString()}",
            id: orderModel.value.parkingDetails!.userId.toString());
      }
    });

    WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
        id: Constant.getUuid(),
        amount:
            "${Constant.calculateAdminCommission(amount: (double.parse(orderModel.value.subTotal.toString()) - double.parse(couponAmount.toString())).toString(), adminCommission: orderModel.value.adminCommission)}",
        createdDate: Timestamp.now(),
        paymentType: "Wallet",
        transactionId: orderModel.value.id,
        isCredit: true,
        userId: orderModel.value.parkingDetails!.userId.toString(),
        note: "Admin commission revers");

    await FireStoreUtils.setWalletTransaction(adminCommissionWallet)
        .then((value) async {
      if (value == true) {
        await FireStoreUtils.updateOtherUserWallet(
            amount:
                "${Constant.calculateAdminCommission(amount: (double.parse(orderModel.value.subTotal.toString()) - double.parse(couponAmount.toString())).toString(), adminCommission: orderModel.value.adminCommission)}",
            id: orderModel.value.parkingDetails!.userId.toString());
      }
    });
  }

  refundCashPaymentAmount() async {
    WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
        id: Constant.getUuid(),
        amount:
            "${Constant.calculateAdminCommission(amount: (double.parse(orderModel.value.subTotal.toString()) - double.parse(couponAmount.toString())).toString(), adminCommission: orderModel.value.adminCommission)}",
        createdDate: Timestamp.now(),
        paymentType: "Wallet",
        transactionId: orderModel.value.id,
        isCredit: true,
        userId: orderModel.value.parkingDetails!.userId.toString(),
        note: "Admin commission revers");

    await FireStoreUtils.setWalletTransaction(adminCommissionWallet)
        .then((value) async {
      if (value == true) {
        await FireStoreUtils.updateOtherUserWallet(
            amount:
                "${Constant.calculateAdminCommission(amount: (double.parse(orderModel.value.subTotal.toString()) - double.parse(couponAmount.toString())).toString(), adminCommission: orderModel.value.adminCommission)}",
            id: orderModel.value.parkingDetails!.userId.toString());
      }
    });
  }
}
