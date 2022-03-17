class VendorColor {
	String? main;
	String? titleBar;
	String? secondary;

	VendorColor({this.main, this.titleBar, this.secondary});

	VendorColor.fromJson(Map<String, dynamic> json) {
		main = json['main'];
		titleBar = json['titleBar'];
		secondary = json['secondary'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = Map<String, dynamic>();
		data['main'] = main;
		data['titleBar'] = titleBar;
		data['secondary'] = secondary;
		return data;
	}
}
