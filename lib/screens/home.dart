import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter_application_1/screens/bluetooth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _scaffoldKEy = GlobalKey<ScaffoldState>();
  final myController = TextEditingController();
  Random random = new Random();
  List<double> traceDust = [];
  double i = 8;

  Stream<String> _clock() async* {
    while (true) {
      int randomNumber = random.nextInt(200);
      await Future<void>.delayed(Duration(milliseconds: 180));
      yield '$randomNumber';
    }
  }

  List<Color> backgroundColor = [
    const Color(0xff3fe1ce),
    const Color(0xff29c8c8)
  ];

  List<Color> lineColor = [
    // const Color(0xffe877a0),
    // const Color(0xfffee74d),
    // const Color(0xffe877a0)
    const Color(0xfffcfefe)
  ];

  List<Color> line2Color = [
    const Color(0xff2682f6),
    const Color(0xff0adee8),
    const Color(0xff2682f6),
  ];
  List<FlSpot> _values1 = [
    FlSpot(0, 0),
    FlSpot(1, 0),
    FlSpot(2, 0),
    FlSpot(3, 0),
    FlSpot(4, 0),
    FlSpot(5, 0),
    FlSpot(6, 0),
  ];
  List<FlSpot> _values2 = [
    FlSpot(0, 0),
    FlSpot(1, 0),
    FlSpot(2, 0),
    FlSpot(3, 0),
    FlSpot(4, 0),
    FlSpot(5, 0),
    FlSpot(6, 0),
  ];

  _generateData(double data) {
    double result;
    if (data % 2 == 0) {
      result = data * 0.8;
    } else {
      result = data * 0.6;
    }
    return result;
  }

  @override
  void initsate() {
    
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKEy,
      drawer: BluetoothMenu(),
      body: Stack(
        children: [
          SafeArea(
            child: StreamBuilder<Object>(
                stream: _clock(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    var item = double.parse(snapshot.data);

                    _values1.removeAt(0);
                    _values1.add(FlSpot(i, item));

                    _values2.removeAt(0);
                    item = _generateData(item);
                    _values2.add(FlSpot(i, item));
                    i += 1;
                    return Container(
                      child: Container(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                  center: Alignment(0, -1),
                                  radius: 1,
                                  colors: backgroundColor,
                                )),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: IconButton(
                                              icon: Icon(Icons.menu),
                                              color: Colors.white,
                                              onPressed: () => _scaffoldKEy
                                                  .currentState
                                                  .openDrawer(),
                                            )),
                                        Expanded(
                                          flex: 4,
                                          child: Center(
                                            child: Text(
                                              "DogEKG Chart",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(20, 20, 40, 40),
                                        child: Center(
                                            child: Column(children: [
                                          Expanded(
                                            child: LineChart(
                                              LineChartData(
                                                  titlesData: FlTitlesData(
                                                      leftTitles: SideTitles(
                                                          showTitles: true,
                                                          interval: 50,
                                                          getTextStyles: (value) =>
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      'SourceSansPro')),
                                                      bottomTitles: SideTitles(
                                                          showTitles: false)),
                                                  maxY: 200,
                                                  minY: 0,
                                                  rangeAnnotations:
                                                      RangeAnnotations(
                                                          verticalRangeAnnotations: []),
                                                  gridData: FlGridData(
                                                      getDrawingHorizontalLine:
                                                          (value) => FlLine(
                                                              color: Color(
                                                                  0xff61e3d7),
                                                              strokeWidth: 1),
                                                      show: true,
                                                      horizontalInterval: 50),
                                                  borderData: FlBorderData(
                                                    show: false,
                                                  ),
                                                  lineTouchData: LineTouchData(
                                                      enabled: false),
                                                  lineBarsData: [
                                                    LineChartBarData(
                                                      curveSmoothness: 0.4,
                                                      colors: lineColor,
                                                      colorStops: [0, 0.7, 1],
                                                      barWidth: 4.5,
                                                      spots: _values1,
                                                      isCurved: true,
                                                      dotData: FlDotData(
                                                        show: false,
                                                      ),
                                                      // belowBarData: BarAreaData(
                                                      //     show: true,
                                                      //     colors: [Color(0xff29c4c2),Colors.transparent],
                                                      //     gradientFrom: Offset(0,0),
                                                      //     gradientTo: Offset(0,0.1),
                                                      //     gradientColorStops: [0]
                                                      //     ),
                                                      shadow: Shadow(
                                                          color:
                                                              Color(0xff25bdc2),
                                                          offset: Offset(1, 1),
                                                          blurRadius: 10),
                                                    ),
                                                    LineChartBarData(
                                                      curveSmoothness: 0.4,
                                                      colors: lineColor,
                                                      colorStops: [0, 0.7, 1],
                                                      barWidth: 4.5,
                                                      spots: _values2,
                                                      isCurved: true,
                                                      dotData: FlDotData(
                                                        show: false,
                                                      ),
                                                      // belowBarData: BarAreaData(
                                                      //     show: true,
                                                      //     colors: [Color(0xff29c4c2),Colors.transparent],
                                                      //     gradientFrom: Offset(0,0),
                                                      //     gradientTo: Offset(0,0.1),
                                                      //     gradientColorStops: [0]
                                                      //     ),
                                                      shadow: Shadow(
                                                          color:
                                                              Color(0xff25bdc2),
                                                          offset: Offset(1, 1),
                                                          blurRadius: 10),
                                                    )
                                                  ]),
                                            ),
                                          )
                                        ])),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                    color: Color(0xffe8f6f5),
                                    child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Card(
                                            child: Center(
                                                child: Row(children: [
                                          Expanded(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                  child: Text(
                                                "Wave1",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    color: Color(0xffb8cada),
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily:
                                                        'SourceSansPro'),
                                              )),
                                              Center(
                                                  child: Text(
                                                "${_values1.last.y.toInt()}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Color(0xff315e83),
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily:
                                                        'SourceSansPro'),
                                              ))
                                            ],
                                          )),
                                          Expanded(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                  child: Text(
                                                "Wave2",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    color: Color(0xffb8cada),
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily:
                                                        'SourceSansPro'),
                                              )),
                                              Center(
                                                  child: Text(
                                                "${_values2.last.y.toInt()}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Color(0xff315e83),
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily:
                                                        'SourceSansPro'),
                                              ))
                                            ],
                                          )),
                                        ]))))))
                          ],
                        ),
                      ),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
