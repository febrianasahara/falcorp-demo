import 'package:airtime_purchase_app/models/purchase/product.dart';
import 'package:airtime_purchase_app/models/sections/provider_section.dart';
import 'package:airtime_purchase_app/models/sections/purchase_type_section.dart';

import '../ui/available-done-actions.dart';
import '../ui/available_input_fields.dart';
import '../menu_info.dart';

class ResponseData {
  int? currentVersionNumber;
  MenuInfo? menuInfo;
  PurchaseTypeSection? purchaseTypeSection;
  ProviderSection? providerSection;
  List<AvailableInputFields>? availableInputFields;
  List<AvailableDoneActions>? availableDoneActions;
  List<Product>? products;

  ResponseData(
      {this.currentVersionNumber,
      this.menuInfo,
      this.purchaseTypeSection,
      this.providerSection,
      this.availableInputFields,
      this.availableDoneActions,
      this.products});

  ResponseData.fromJson(Map<String, dynamic> json) {
    currentVersionNumber = json['currentVersionNumber'];
    menuInfo =
        json['menuInfo'] != null ? MenuInfo.fromJson(json['menuInfo']) : null;
    purchaseTypeSection = json['purchaseTypeSection'] != null
        ? PurchaseTypeSection.fromJson(json['purchaseTypeSection'])
        : null;
    providerSection = json['providerSection'] != null
        ? ProviderSection.fromJson(json['providerSection'])
        : null;
    if (json['availableInputFields'] != null) {
      availableInputFields = <AvailableInputFields>[];
      json['availableInputFields'].forEach((v) {
        availableInputFields!.add(AvailableInputFields.fromJson(v));
      });
    }
    if (json['availableDoneActions'] != null) {
      availableDoneActions = <AvailableDoneActions>[];
      json['availableDoneActions'].forEach((v) {
        availableDoneActions!.add(AvailableDoneActions.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = <Product>[];
      json['products'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['currentVersionNumber'] = currentVersionNumber;
    if (menuInfo != null) {
      data['menuInfo'] = menuInfo!.toJson();
    }
    if (purchaseTypeSection != null) {
      data['purchaseTypeSection'] = purchaseTypeSection!.toJson();
    }
    if (providerSection != null) {
      data['providerSection'] = providerSection!.toJson();
    }
    if (availableInputFields != null) {
      data['availableInputFields'] =
          availableInputFields!.map((v) => v.toJson()).toList();
    }
    if (availableDoneActions != null) {
      data['availableDoneActions'] =
          availableDoneActions!.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
