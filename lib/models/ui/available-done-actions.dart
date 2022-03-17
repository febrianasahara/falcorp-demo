class AvailableDoneActions {
  int? id;
  int? type;
  String? name;
  bool? appendAmount;
  String? completeScreenTitle;

  AvailableDoneActions(
      {this.id,
      this.type,
      this.name,
      this.appendAmount,
      this.completeScreenTitle});

  AvailableDoneActions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    appendAmount = json['appendAmount'];
    completeScreenTitle = json['completeScreenTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['type'] = type;
    data['name'] = name;
    data['appendAmount'] = appendAmount;
    data['completeScreenTitle'] = completeScreenTitle;
    return data;
  }
}
