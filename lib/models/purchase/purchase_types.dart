class PurchaseType {
  int? id;
  String? name;
  int? displayType;
  List<int>? completeOptions;
  int? doneActionId;
  String? iconName;

  PurchaseType(
      {this.id,
      this.name,
      this.displayType,
      this.completeOptions,
      this.doneActionId,
      this.iconName});

  PurchaseType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    displayType = json['displayType'];
    completeOptions = json['completeOptions'].cast<int>();
    doneActionId = json['doneActionId'];
    iconName = json['iconName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['displayType'] = displayType;
    data['completeOptions'] = completeOptions;
    data['doneActionId'] = doneActionId;
    data['iconName'] = iconName;
    return data;
  }
}
