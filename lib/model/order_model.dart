import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mekinaparking/model/admin_commission.dart';
import 'package:mekinaparking/model/coupon_model.dart';
import 'package:mekinaparking/model/parking_model.dart';
import 'package:mekinaparking/model/tax_model.dart';
import 'package:mekinaparking/model/user_vehicle_model.dart';

class OrderModel {
  String? id;
  String? userId;
  String? parkingId;
  String? parkingSlotId;
  Timestamp? bookingDate;
  Timestamp? bookingStartTime;
  Timestamp? bookingEndTime;
  Timestamp? extraTimeEnd;
  Timestamp? extraTimeStart;
  String? duration;
  String? extraDuration;
  String? perHrPrice;
  String? status;
  String? paymentType;
  String? subTotal;
  String? extraTimeHours;
  bool? paymentCompleted;
  bool? isExtraTimeApplied;
  bool? isExtraTimeRequestAccept;
  bool? extraPaymentCompleted;
  bool? isParkingLeave;
  bool? notificationSent;
  UserVehicleModel? userVehicle;
  ParkingModel? parkingDetails;
  List<TaxModel>? taxList;
  AdminCommission? adminCommission;
  CouponModel? coupon;
  Timestamp? createdAt;
  Timestamp? updateAt;
  Timestamp? parkingInTime;
  Timestamp? parkingOutTime;

  OrderModel({
    this.id,
    this.userId,
    this.parkingId,
    this.parkingSlotId,
    this.bookingDate,
    this.bookingStartTime,
    this.bookingEndTime,
    this.extraTimeEnd,
    this.extraTimeStart,
    this.duration,
    this.extraDuration,
    this.perHrPrice,
    this.status,
    this.paymentType,
    this.subTotal,
    this.extraTimeHours,
    this.paymentCompleted,
    this.isExtraTimeApplied,
    this.isExtraTimeRequestAccept,
    this.extraPaymentCompleted,
    this.isParkingLeave,
    this.notificationSent,
    this.userVehicle,
    this.parkingDetails,
    this.taxList,
    this.adminCommission,
    this.coupon,
    this.createdAt,
    this.updateAt,
    this.parkingInTime,
    this.parkingOutTime,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    parkingId = json['parkingId'];
    parkingSlotId = json['parkingSlotId'];
    bookingDate = json['bookingDate'];
    bookingStartTime = json['bookingStartTime'];
    bookingEndTime = json['bookingEndTime'];
    extraTimeEnd = json['extraTimeEnd'];
    extraTimeStart = json['extraTimeStart'];
    duration = json['duration'];
    extraDuration = json['extraDuration'];
    perHrPrice = json['perHrPrice'];
    status = json['status'];
    paymentType = json['paymentType'];
    subTotal = json['subTotal'];
    extraTimeHours = json['extraTimeHours'];
    paymentCompleted = json['paymentCompleted'];
    isExtraTimeApplied = json['isExtraTimeApplied'];
    isExtraTimeRequestAccept = json['isExtraTimeRequestAccept'];
    extraPaymentCompleted = json['extraPaymentCompleted'];
    isParkingLeave = json['isParkingLeave'];
    notificationSent = json['notificationSent'];
    userVehicle = json['userVehicle'] != null
        ? UserVehicleModel.fromJson(json['userVehicle'])
        : null;
    parkingDetails = json['parkingDetails'] != null
        ? ParkingModel.fromJson(json['parkingDetails'])
        : null;
    if (json['taxList'] != null) {
      taxList = <TaxModel>[];
      json['taxList'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
    adminCommission = json['adminCommission'] != null
        ? AdminCommission.fromJson(json['adminCommission'])
        : null;
    coupon =
        json['coupon'] != null ? CouponModel.fromJson(json['coupon']) : null;
    createdAt = json['createdAt'];
    updateAt = json['updateAt'];
    parkingInTime = json['parkingInTime'];
    parkingOutTime = json['parkingOutTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['parkingId'] = parkingId;
    data['parkingSlotId'] = parkingSlotId;
    data['bookingDate'] = bookingDate;
    data['bookingStartTime'] = bookingStartTime;
    data['bookingEndTime'] = bookingEndTime;
    data['extraTimeEnd'] = extraTimeEnd;
    data['extraTimeStart'] = extraTimeStart;
    data['duration'] = duration;
    data['extraDuration'] = extraDuration;
    data['perHrPrice'] = perHrPrice;
    data['status'] = status;
    data['paymentType'] = paymentType;
    data['subTotal'] = subTotal;
    data['extraTimeHours'] = extraTimeHours;
    data['paymentCompleted'] = paymentCompleted;
    data['isExtraTimeApplied'] = isExtraTimeApplied;
    data['isExtraTimeRequestAccept'] = isExtraTimeRequestAccept;
    data['extraPaymentCompleted'] = extraPaymentCompleted;
    data['isParkingLeave'] = isParkingLeave;
    data['notificationSent'] = notificationSent;

    if (userVehicle != null) {
      data['userVehicle'] = userVehicle!.toJson();
    }
    if (parkingDetails != null) {
      data['parkingDetails'] = parkingDetails!.toJson();
    }
    if (taxList != null) {
      data['taxList'] = taxList!.map((v) => v.toJson()).toList();
    }
    if (adminCommission != null) {
      data['adminCommission'] = adminCommission!.toJson();
    }
    if (coupon != null) {
      data['coupon'] = coupon!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updateAt'] = updateAt;
    data['parkingInTime'] = parkingInTime;
    data['parkingOutTime'] = parkingOutTime;
    return data;
  }
}
