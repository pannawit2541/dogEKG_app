import 'package:flutter/material.dart';

class PublicDrawer extends StatefulWidget {
  @override
  _PublicDrawerState createState() => _PublicDrawerState();
}

class _PublicDrawerState extends State<PublicDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Drawer(
      child: Text("Hello"),
    ));
  }
}
