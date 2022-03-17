import 'package:airtime_purchase_app/models/menu_response.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class AirtimeRepository {
  final String apiHost;
  AirtimeRepository({required this.apiHost});

  /// Main Data, retrieved from a menu */
  Future<MenuResponse> getAirtimeMenu() async {
    var response = await http.get(Uri.parse(apiHost + "/menu/airtime"));
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      if (kDebugMode) {
        print('Menu Returned : $jsonResponse.');
      }
      var itemCount = MenuResponse.fromJson(jsonResponse);

      return itemCount;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }
}
