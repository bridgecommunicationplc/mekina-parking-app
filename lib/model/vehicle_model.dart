class VehicleModel {
  bool? enable;
  String? name;
  String? brandId;
  String? image;
  String? id;
  String? qrCode;

  VehicleModel({this.enable, this.name, this.id,this.qrCode, this.image, this.brandId});

  VehicleModel.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
    brandId = json['brandId'];
    image = json['image'];
    id = json['id'];
    qrCode = json['qrCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['name'] = name;
    data['id'] = id;
    data['qrCode'] = qrCode;
    data['brandId'] = brandId;
    data['image'] = image;
    return data;
  }
}
