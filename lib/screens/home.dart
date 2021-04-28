import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/screens/chartPage.dart';
import 'package:flutter_application_1/screens/topBar.dart';
//TODO
//CLEAR : FOR TEST CHART
import 'dart:math';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<FlSpot> value = [for (double i = 0; i < 50; i++) FlSpot(i, 0)];

  List<Color> lineColor1 = [const Color(0xff6340f2)];
  List<Color> lineColor2 = [const Color(0xfffa7167)];

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
                    var wave = snapshot.data;
                    var x = (value.last.x) + 1;
                    print(snapshot.data);
                    value.removeAt(0);
                    value.add(FlSpot(x, wave));
                    return Container(
                      child: Container(
                        color: Color(0xffededef),
                        child: Column(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: EdgeInsets.only(left:30,right:30),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Color(0xff613bff),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Icon(
                                              Icons.favorite,
                                              color: Colors.pink,
                                              size: 24.0,
                                            ),
                                            Row(
                                              children: [
                                                Text("${wave}"),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text("${wave}")
                                              ],
                                            )
                                          ],
                                        )),
                                  ),
                                )),
                            Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xffffffff),
                                        ),
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
                                        )),
                                  ),
                                ))
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
