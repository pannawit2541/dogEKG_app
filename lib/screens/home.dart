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
  List<FlSpot> value = [for(double i=0; i<30 ;i++) FlSpot(i, 0)];

  List<Color> lineColor1 = [const Color(0xfffe632b)];
  List<Color> lineColor2 = [const Color(0xff7958fe)];

//TODO : Clear
  Stream<double> _test() async* {
    while (true) {
      var rng = new Random();
      await Future<void>.delayed(const Duration(milliseconds: 150));
      yield rng.nextInt(100).toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SafeArea(
            child: StreamBuilder<Object>(
                stream: _test(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    var x = (value.last.x) + 1;
                    print(snapshot.data);
                    value.removeAt(0);
                    value.add(FlSpot(x, snapshot.data));
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
                                          margin: EdgeInsets.fromLTRB(
                                              0, 20, 20, 10),
                                          child: ChartPage(
                                            value: value,
                                            lineColor: lineColor1,
                                          ),
                                        )),
                                        Expanded(
                                            child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 10, 20, 20),
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
                  }
                }))
      ]),
    );
  }
}
