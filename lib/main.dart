import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/home.dart';
// import 'package:flutter_application_1/screens/homeDefault.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
        // home: Home(),
        home: Home(),
        // theme: ThemeData(textTheme: GoogleFonts.robotoTextTheme(
        // Theme.of(context).textTheme))
        theme: ThemeData(fontFamily: 'SourceSansPro'));
  }
}
