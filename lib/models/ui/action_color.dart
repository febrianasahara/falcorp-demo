// ignore_for_file: unnecessary_this

class ActionColor {
  String? selected;

  ActionColor({this.selected});

  ActionColor.fromJson(Map<String, dynamic> json) {
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['selected'] = this.selected;
    return data;
  }
}
