// ignore_for_file: unnecessary_const, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_key_in_widget_constructors

import 'package:airtime_purchase_app/models/menu_response.dart';
import 'package:airtime_purchase_app/theme/palette.dart';
import 'package:flutter/material.dart';

class AirtimePage extends StatefulWidget {
  final MenuResponse data;
  const AirtimePage({required this.data});

  @override
  AirtimePageState createState() => AirtimePageState();
}

class AirtimePageState extends State<AirtimePage> {
  static const routeName = '/airtime-page';
  bool busy = false;

  // state variabls
  bool typeSelected = false;
  bool networkSelected = false;
  bool amountSelected = false;
  bool canPurchase = false;

  // app variables
  num purchaseAmount = 0;

  late MenuResponse menuData;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
              tag: 'bg-transition',
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Palette.primaryDark,
                ),
              )),
        ],
      ),
    );
  }
}
