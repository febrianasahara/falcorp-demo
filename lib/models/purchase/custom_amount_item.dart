class CustomAmountItem {
	int? sku;
	int? minAmountInCents;
	int? maxAmountInCents;
	String? description;
	String? message;

	CustomAmountItem({this.sku, this.minAmountInCents, this.maxAmountInCents, this.description, this.message});

	CustomAmountItem.fromJson(Map<String, dynamic> json) {
		sku = json['sku'];
		minAmountInCents = json['minAmountInCents'];
		maxAmountInCents = json['maxAmountInCents'];
		description = json['description'];
		message = json['message'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['sku'] = this.sku;
		data['minAmountInCents'] = this.minAmountInCents;
		data['maxAmountInCents'] = this.maxAmountInCents;
		data['description'] = this.description;
		data['message'] = this.message;
		return data;
	}
}
