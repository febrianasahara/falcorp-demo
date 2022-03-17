
import 'response_data.dart';

class DefaultData {
	ResponseData? data;

	DefaultData({this.data});

	DefaultData.fromJson(Map<String, dynamic> json) {
		data = json['data'] != null ? ResponseData.fromJson(json['data']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = {};
		if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
		return data;
	}
}