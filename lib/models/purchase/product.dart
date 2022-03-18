import 'package:airtime_purchase_app/models/ui/extra_field.dart';

import 'pre_defined_amount.dart';

class Product {
  int? purchaseTypeId;
  List<String>? messages;
  int? providerId;
  int? doneActionId;
  PreDefinedAmount? preDefinedAmount;
  List<ExtraField>? extraFields;
  int? productId;

  Product(
      {this.purchaseTypeId,
      this.messages,
      this.providerId,
      this.doneActionId,
      this.preDefinedAmount,
      this.extraFields,
      this.productId});

  Product.fromJson(Map<String, dynamic> json) {
    purchaseTypeId = json['purchaseTypeId'];
      if (json['messages'] != null) {
      messages = <String>[];
      json['messages'].forEach((v) {
        messages!.add(v);
      });
    }
    providerId = json['providerId'];
    doneActionId = json['doneActionId'];
    preDefinedAmount = json['preDefinedAmount'] != null
        ? PreDefinedAmount.fromJson(json['preDefinedAmount'])
        : null;
    if (json['extraFields'] != null) {
      extraFields = <ExtraField>[];
      json['extraFields'].forEach((v) {
        extraFields!.add(ExtraField.fromJson(v));
      });
    }
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['purchaseTypeId'] = purchaseTypeId;
    data['messages'] = messages;
    data['providerId'] = providerId;
    data['doneActionId'] = doneActionId;
    if (preDefinedAmount != null) {
      data['preDefinedAmount'] = preDefinedAmount!.toJson();
    }
    if (extraFields != null) {
      data['extraFields'] = extraFields!.map((v) => v.toJson()).toList();
    }
    data['productId'] = productId;
    return data;
  }
}
