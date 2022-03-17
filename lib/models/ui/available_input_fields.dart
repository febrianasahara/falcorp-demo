class AvailableInputFields {
	int? id;
	String? name;
	int? minDigitCount;
	int? maxDigitCount;
	String? description;
	int? inputType;

	AvailableInputFields({this.id, this.name, this.minDigitCount, this.maxDigitCount, this.description, this.inputType});

	AvailableInputFields.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		name = json['name'];
		minDigitCount = json['minDigitCount'];
		maxDigitCount = json['maxDigitCount'];
		description = json['description'];
		inputType = json['inputType'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = Map<String, dynamic>();
		data['id'] = id;
		data['name'] = name;
		data['minDigitCount'] = minDigitCount;
		data['maxDigitCount'] = maxDigitCount;
		data['description'] = description;
		data['inputType'] = inputType;
		return data;
	}
}


