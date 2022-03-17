
class Currency {
	String? symbol;
	String? code;
	bool? useSymbol;

	Currency({this.symbol, this.code, this.useSymbol});

	Currency.fromJson(Map<String, dynamic> json) {
		symbol = json['symbol'];
		code = json['code'];
		useSymbol = json['useSymbol'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = Map<String, dynamic>();
		data['symbol'] = symbol;
		data['code'] = code;
		data['useSymbol'] = useSymbol;
		return data;
	}
}
