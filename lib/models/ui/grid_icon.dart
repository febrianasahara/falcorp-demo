class GridIcon {
	String? defaultIconName;
	String? selectedIconName;

	GridIcon({this.defaultIconName, this.selectedIconName});

	GridIcon.fromJson(Map<String, dynamic> json) {
		defaultIconName = json['defaultIconName'];
		selectedIconName = json['selectedIconName'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = Map<String, dynamic>();
		data['defaultIconName'] = defaultIconName;
		data['selectedIconName'] = selectedIconName;
		return data;
	}
}

