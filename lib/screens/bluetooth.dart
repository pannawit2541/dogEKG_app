import 'package:flutter/material.dart';

class BluetoothMenu extends StatefulWidget {
  @override
  _BluetoothMenuState createState() => _BluetoothMenuState();
}

class _BluetoothMenuState extends State<BluetoothMenu> {
  bool value = false;
  Color activeColor = Color(0xff29c8c8);
  Color inactiveColor = Color(0xffb8cada);
  Color textEnableBlue = Color(0xffb8cada);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // DrawerHeader(child: Text("Bluetooth device")),
          ListTile(
            title: Text(
              "Enable Bluetooth",
              style: TextStyle(color: textEnableBlue),
            ),
            trailing: Switch(
              activeColor: activeColor,
              value: value,
              onChanged: (v) => setState(() {
                value = v;
                if (v == true){
                  textEnableBlue = activeColor; 
                }else{
                  textEnableBlue = inactiveColor;
                }
                
              }),
            ),
          )
        ],
      ),
    );
  }
}
