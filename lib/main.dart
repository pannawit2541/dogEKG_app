import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      // theme: ThemeData(textTheme: GoogleFonts.robotoTextTheme(
      // Theme.of(context).textTheme))
      theme: ThemeData(fontFamily: 'SourceSansPro')
    );
  }
}