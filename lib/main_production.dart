import 'package:flutter/material.dart';
import 'app.dart';

void main()async {
  runApp(const App(flavor: 'Production',
  apiHostUrl: 'https://ndropa-api-production.herokuapp.com',));
}