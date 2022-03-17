
import 'purchase/currency.dart';
import 'ui/action_color.dart';

class MenuInfo {
  int? id;
  String? name;
  ActionColor? color;
  Currency? currency;

  MenuInfo({this.id, this.name, this.color, this.currency});

  MenuInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'] != null ? ActionColor.fromJson(json['color']) : null;
    currency =
        json['currency'] != null ? Currency.fromJson(json['currency']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    if (color != null) {
      data['color'] = color!.toJson();
    }
    if (currency != null) {
      data['currency'] = currency!.toJson();
    }
    return data;
  }
}
