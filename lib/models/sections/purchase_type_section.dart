import 'package:airtime_purchase_app/models/purchase/purchase_types.dart';

class PurchaseTypeSection {
  String? title;
  List<PurchaseType>? purchaseTypes;

  PurchaseTypeSection({this.title, this.purchaseTypes});

  PurchaseTypeSection.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['purchaseTypes'] != null) {
      purchaseTypes = <PurchaseType>[];
      json['purchaseTypes'].forEach((v) {
        purchaseTypes!.add(PurchaseType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['title'] = title;
    if (purchaseTypes != null) {
      data['purchaseTypes'] = purchaseTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
