class FixedAmountItem {
	int? sku;
	int? amountInCents;
	String? message;
	bool? isOffline;
	bool? isPromo;

	FixedAmountItem({this.sku, this.amountInCents, this.message, this.isOffline, this.isPromo});

	FixedAmountItem.fromJson(Map<String, dynamic> json) {
		sku = json['sku'];
		amountInCents = json['amountInCents'];
		message = json['message'];
		isOffline = json['isOffline'];
		isPromo = json['isPromo'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['sku'] = this.sku;
		data['amountInCents'] = this.amountInCents;
		data['message'] = this.message;
		data['isOffline'] = this.isOffline;
		data['isPromo'] = this.isPromo;
		return data;
	}
}
