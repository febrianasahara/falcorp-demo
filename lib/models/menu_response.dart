import 'data/default-data.dart';
import 'data/response_data.dart';

class MenuResponse {
  ResponseData? data;
  DefaultData? defaultData;

  MenuResponse({this.data, this.defaultData});

  MenuResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ResponseData.fromJson(json['data']) : null;
    defaultData =
        json['default'] != null ? DefaultData.fromJson(json['default']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (defaultData != null) {
      data['default'] = defaultData!.toJson();
    }
    return data;
  }
}
