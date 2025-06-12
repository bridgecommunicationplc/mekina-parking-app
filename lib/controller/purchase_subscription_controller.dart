import 'package:get/get.dart';
import 'package:mekinaparking/model/parking_model.dart';
import 'package:mekinaparking/model/subscription_model.dart';
import 'package:mekinaparking/utils/fire_store_utils.dart';

class PurchaseSubscriptionController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<SubscriptionModel> subscription = <SubscriptionModel>[].obs;
  var selectedSubscriptionId = "".obs;
  var selectedPlanIndex = (-1).obs;
  var selectedPlanPrice = "".obs;
  var selectedPlanMonths = "".obs;
  var selectedPlanId = "".obs;
  var selectedMaxSpace = "".obs;
  var selectedOwnerId = "".obs;
  var selectedParkingId = "".obs;
  var selectedTitle = "".obs;
  var subscriptionId = "".obs;
  RxMap<String, ParkingModel> parkingMap = <String, ParkingModel>{}.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    try {
      final subList = await FireStoreUtils.getSubscriptionList();
      if (subList != null) {
        subscription.value = subList;
        final parkingIds =
            subList.map((e) => e.parkingId).whereType<String>().toSet();

        for (final id in parkingIds) {
          final parking = await FireStoreUtils.getParkingByID(id);
          if (parking != null) {
            parkingMap[id] = parking;
          }
        }
      }
    } catch (e) {
      print("Error: $e");
    }
    isLoading.value = false;
    update();
  }

  void selectPlan(String subscriptionId, int planIndex) {
    selectedSubscriptionId.value = subscriptionId;
    selectedPlanIndex.value = planIndex;
  }
}
