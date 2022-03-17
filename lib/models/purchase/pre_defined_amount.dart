import 'custom_amount_item.dart';
import 'fixed_amount_item.dart';

class PreDefinedAmount {
  List<FixedAmountItem>? fixedAmountItems;
  CustomAmountItem? customAmountItem;

  PreDefinedAmount({this.fixedAmountItems, this.customAmountItem});

  PreDefinedAmount.fromJson(Map<String, dynamic> json) {
    if (json['fixedAmountItems'] != null) {
      fixedAmountItems = <FixedAmountItem>[];
      json['fixedAmountItems'].forEach((v) {
        fixedAmountItems!.add(FixedAmountItem.fromJson(v));
      });
    }
    customAmountItem = json['customAmountItem'] != null
        ? CustomAmountItem.fromJson(json['customAmountItem'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (fixedAmountItems != null) {
      data['fixedAmountItems'] =
          fixedAmountItems!.map((v) => v.toJson()).toList();
    }
    if (customAmountItem != null) {
      data['customAmountItem'] = customAmountItem!.toJson();
    }
    return data;
  }
}
