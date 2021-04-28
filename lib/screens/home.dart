import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/chartPage.dart';
//TODO
//CLEAR : FOR TEST CHART
import 'dart:math';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<FlSpot> value = [
    FlSpot(0, 5),
    FlSpot(1, 2),
    FlSpot(2, 6),
    FlSpot(3, 7),
    FlSpot(4, 20),
    FlSpot(5, 19),
    FlSpot(6, 12),
    FlSpot(7, 8),
    FlSpot(8, 15),
    FlSpot(9, 10),
    FlSpot(10, 11),
    FlSpot(11, 7),
    FlSpot(12, 6),
    FlSpot(13, 0),
  ];

  List<Color> lineColor1 = [const Color(0xfffe632b)];
  List<Color> lineColor2 = [const Color(0xff7958fe)];

//TODO : Clear
  Stream<double> _test() async* {
    var rng = new Random();
    yield rng.nextInt(20).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SafeArea(
            child: StreamBuilder<Object>(
                stream: _test(),
                builder: (context, snapshot) {
                  var x = value.last.x;
                  value.removeAt(0);
                  value.add(FlSpot(x+1, snapshot.data));
                  return Container(
                    child: Container(
                      child: Column(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                color: Colors.blue,
                                child: Row(
                                  children: [
                                    Expanded(child: Text("H1")),
                                    Expanded(child: Text("H2")),
                                    Expanded(child: Text("H3"))
                                  ],
                                ),
                              )),
                          Expanded(
                              flex: 4,
                              child: Container(
                                  color: Color(0xfffffdff),
                                  child: Column(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 20, 20, 10),
                                        child: ChartPage(
                                          value: value,
                                          lineColor: lineColor1,
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 20, 20),
                                        child: ChartPage(
                                          value: value,
                                          lineColor: lineColor2,
                                        ),
                                      )),
                                    ],
                                  )))
                        ],
                      ),
                    ),
                  );
                }))
      ]),
    );
  }
}
