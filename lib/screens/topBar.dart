import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  double wave1 = 0;
  double wave2 = 0;
  TopBar({Key key, this.wave1,this.wave2}) : super(key: key);
  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Expanded(child: Text("H1")),
        Expanded(child: Text("${widget.wave1}")),
        Expanded(child: Text("${widget.wave2}"))
      ],
    ));
  }
}
