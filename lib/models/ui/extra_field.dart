class ExtraField {
	String? jsonFieldName;
	int? inputFieldId;
	bool? displayWhenComplete;
	int? preProcessorInputFieldId;

	ExtraField({this.jsonFieldName, this.inputFieldId, this.displayWhenComplete, this.preProcessorInputFieldId});

	ExtraField.fromJson(Map<String, dynamic> json) {
		jsonFieldName = json['jsonFieldName'];
		inputFieldId = json['inputFieldId'];
		displayWhenComplete = json['displayWhenComplete'];
		preProcessorInputFieldId = json['preProcessorInputFieldId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['jsonFieldName'] = this.jsonFieldName;
		data['inputFieldId'] = this.inputFieldId;
		data['displayWhenComplete'] = this.displayWhenComplete;
		data['preProcessorInputFieldId'] = this.preProcessorInputFieldId;
		return data;
	}
}