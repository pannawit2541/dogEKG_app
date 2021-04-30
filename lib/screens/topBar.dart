import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TopBar extends StatefulWidget {
  double wave1 = 0;
  double wave2 = 0;
  var scaffoldKey;
  TopBar({Key key, this.wave1, this.wave2, this.scaffoldKey}) : super(key: key);
  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  double widthBox = 100;
  double borderRadius = 15;
  double marginBox = 5;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(top: marginBox, bottom: marginBox),
              width: 200,
              child: Card(
                color: Color(0xfffbfcff),
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(
                          Icons.menu,
                          color: Color(0xff613bff),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Text(
                          "DOG-EKG",
                          style: TextStyle(
                              color: Color(0xff1a1f32),
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  
                ),
              ),
            ),
            onTap: () => {widget.scaffoldKey.currentState.openDrawer()},
          ),
          Container(
            margin: EdgeInsets.only(top: marginBox, bottom: marginBox),
            child: Row(children: [
              Container(
                  width: widthBox,
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(borderRadius)),
                      color: Color(0xffededf9),
                      shadowColor: Colors.transparent,
                      child: Center(
                          child: Text(
                        "${widget.wave1}",
                        style: TextStyle(
                            color: Color(0xff6464c5),
                            fontWeight: FontWeight.bold),
                      )))),
              Container(
                  width: widthBox,
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(borderRadius)),
                      color: Color(0xfffeeefb),
                      shadowColor: Colors.transparent,
                      child: Center(
                        child: Text(
                          "${widget.wave2}",
                          style: TextStyle(
                              color: Color(0xfffa7167),
                              fontWeight: FontWeight.bold),
                        ),
                      ))),
            ]),
          )
        ],
      ),
    );
  }
}
