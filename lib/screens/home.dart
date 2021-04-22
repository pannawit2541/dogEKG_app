import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // GlobalKey<ScaffoldState> _scaffoldKEy = GlobalKey<ScaffoldState>();
  final myController = TextEditingController();
  Random random = new Random();
  List<double> traceDust = [];
  double i = 8;

  // Stream<Uint8List> wa

  Stream<String> _clock() async* {
    // while (true) {
    //   int randomNumber = random.nextInt(200);
    //   await Future<void>.delayed(Duration(milliseconds: 180));
    //   yield '$randomNumber';
    // }
    // connection.input.listen((Uint8List data) {
    //   // print(ascii.decode(data));
      
    // });
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

  // Variables for the Bluetooth functions
  Color activeColor = Color(0xff29c8c8);
  Color inactiveColor = Color(0xff315e83);

  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection connection;
  int _deviceState;
  bool isDisconnecting = false;
  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection.isConnected;

// Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
        print(_bluetoothState);
      });
    });

    _deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  // Request Bluetooth permission from the user
  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          // connection.input.listen((Uint8List data) {
          //   print(ascii.decode(data));
          // });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        show('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

// Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection.close();
    show('Device disconnected');
    if (!connection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: [
            // DrawerHeader(child: Text("Bluetooth device")),
            ListTile(
              // leading:
              title: Row(
                children: [
                  Icon(
                    IconData(0xe5ec, fontFamily: 'MaterialIcons'),
                    color: inactiveColor,
                    size: 22,
                  ),
                  Text(
                    "Enable Bluetooth",
                    style: TextStyle(
                        color: inactiveColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              trailing: Switch(
                activeColor: activeColor,
                value: _bluetoothState.isEnabled,
                onChanged: (bool value) {
                  future() async {
                    if (value) {
                      await FlutterBluetoothSerial.instance.requestEnable();
                      // enableColor = activeColor;
                    } else {
                      await FlutterBluetoothSerial.instance.requestDisable();
                      // enableColor = inactiveColor;
                    }

                    await getPairedDevices();
                    _isButtonUnavailable = false;

                    if (_connected) {
                      _disconnect();
                    }
                  }

                  future().then((_) {
                    setState(() {});
                  });
                },
              ),
            ),
            ListTile(
              leading: Text(
                'Device:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: inactiveColor,
                    fontSize: 16),
              ),
            ),
            ListTile(
              leading: DropdownButton(
                items: _getDeviceItems(),
                onChanged: (value) => setState(() => _device = value),
                value: _devicesList.isNotEmpty ? _device : null,
              ),
              trailing: RaisedButton(
                onPressed: _isButtonUnavailable
                    ? null
                    : _connected
                        ? _disconnect
                        : _connect,
                child: Text(_connected ? 'Disconnect' : 'Connect'),
              ),
            )
          ],
        ),
      ),
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
                                              onPressed: () => _scaffoldKey
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

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('No device'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}
