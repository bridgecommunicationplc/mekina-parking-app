import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mekinaparking/model/subscription_model.dart';

class SubscriptionHistoryModel {
  String? id;
  String? userId;
  String? paymentStatus;
  Timestamp? createdAt;
  Timestamp? expiryDate;
  SubscriptionModel? subscriptionPlan;

  SubscriptionHistoryModel(
      {this.id,
      this.userId,
      this.paymentStatus,
      this.createdAt,
      this.expiryDate,
      this.subscriptionPlan});

  SubscriptionHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    paymentStatus = json['payment_status'];
    createdAt = json['createdAt'];
    expiryDate = json['expiry_date'];
    subscriptionPlan = json['subscription_plan'] != null
        ? SubscriptionModel.fromJson(json['subscription_plan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['payment_status'] = paymentStatus;
    data['createdAt'] = createdAt;
    data['expiry_date'] = expiryDate;
    data['subscription_plan'] = subscriptionPlan?.toJson();
    return data;
  }
}
