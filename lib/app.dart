import 'package:airtime_purchase_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'views/welcome.dart';

class App extends StatelessWidget {
  final String flavor;
  final String apiHostUrl;
  const App({Key? key, required this.flavor, required this.apiHostUrl})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Ndropa " + flavor,
      theme: ThemeData(primaryColor: Palette.primaryLight),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: WelcomeScreen(
          apiUrl: apiHostUrl,
        ),
      ),
    );
  }
}
