import 'dart:convert';
import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_application_1/screens/chartPage.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_application_1/screens/topBar.dart';

import '../clip/clipping.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection connection;
  // int _deviceState;
  bool isDisconnecting = false;
  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection.isConnected;

// Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  List<FlSpot> _value1 = [FlSpot(0, -1)];
  List<FlSpot> _value2 = [FlSpot(0, -1)];

  Color primaryColor1 = const Color(0xff6340f2);
  Color primaryColor2 = const Color(0xfffa7167);
  Color primartCorlor1_light = const Color(0xffededf9);
  Color primartCorlor2_light = const Color(0xfffeeefb);

  Color headerTxtColor1 = Color(0xff1a1f32);
  Color bgColor = Color(0xffededef);

  // Color switchColor = Color(0xff1a1f32);
  Stream<Uint8List> _tempData() async* {
    yield ascii.encode('0,0');
  }

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

    // _deviceState = 0; // neutral

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

    // _bluetoothState
  }

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
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        show('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      // _deviceState = 0;
    });

    await connection.finish();
    show('Device disconnected');
    if (!connection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
    setState(() {
      _value1.clear();
      _value2.clear();
      _value1 = [FlSpot(0, -1)];
      _value2 = [FlSpot(0, -1)];
    });

  }

  @override
  Widget build(BuildContext context) {
    double i = 0;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
          child: ListView(
        children: [
          Container(
            child: Stack(
              children: <Widget>[
                ClipPath(
                  clipper: ClippingClass(),
                  child: Container(
                    height: 100.0,
                    decoration: BoxDecoration(color: Color(0xffeeebfe)),
                  ),
                ),
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.center,
                  child: const Icon(
                    IconData(57572, fontFamily: 'MaterialIcons'),
                    color: Color(0xff6340f2),
                    size: 40,
                  ),
                ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Enable Bluetooth",
                    style: TextStyle(
                        color: headerTxtColor1,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Switch(
                      activeColor: primaryColor1,
                      inactiveThumbColor: bgColor,
                      value: _bluetoothState.isEnabled,
                      onChanged: (bool value) {
                        future() async {
                          if (value) {
                            await FlutterBluetoothSerial.instance
                                .requestEnable();
                          } else {
                            await FlutterBluetoothSerial.instance
                                .requestDisable();
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
                      })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton(
                    hint: Text(
                      _bluetoothState.isEnabled ? 'Select device' : 'No device',
                      style: TextStyle(color: headerTxtColor1, fontSize: 12),
                    ),
                    items: _getDeviceItems(),
                    onChanged: (value) => setState(() => _device = value),
                    value: _devicesList.isNotEmpty ? _device : null,
                  ),
                  RaisedButton(
                    disabledColor: bgColor,
                    color: _connected
                        ? primartCorlor2_light
                        : primartCorlor1_light,
                    onPressed: _isButtonUnavailable
                        ? null
                        : _connected
                            ? _disconnect
                            : _connect,
                    child: _connected
                        ? Text(
                            'Disconnect',
                            style: TextStyle(color: primaryColor2),
                          )
                        : Text(
                            'Connect',
                            style: TextStyle(color: primaryColor1),
                          ),
                  ),
                ],
              )
            ]),
          ),
        ],
      )),
      body: Stack(children: [
        SafeArea(
            child: StreamBuilder<Uint8List>(
                stream: connection != null ? connection.input : _tempData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    try {
                      var wave = ascii.decode(snapshot.data).split(',');
                      print(i.toString() + ": " + wave[0] + " // " + wave[1]);
                      if (connection != null) {
                        if (i > 300 || i == 0) {
                          i = 0;
                          _value1.clear();
                          _value2.clear();
                        }

                        _value1.add(FlSpot(i, double.parse(wave[0])));
                        _value2.add(FlSpot(i, double.parse(wave[1])));

                        i += 1;
                      }
                    } catch (NumberFormatException) {}

                    return Container(
                      color: bgColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 4),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 30, right: 30),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Color(0xffffffff),
                                        child: TopBar(
                                            wave1: connection != null
                                                ? _value1.last.y
                                                : 0,
                                            wave2: connection != null
                                                ? _value2.last.y
                                                : 0,
                                            scaffoldKey: _scaffoldKey),
                                      )),
                                ),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 4),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                          // padding: EdgeInsets.only(left:30),
                                          decoration: BoxDecoration(
                                            color: Color(0xffffffff),
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    20, 20, 20, 5),
                                                child: ChartPage(
                                                  value: _value1,
                                                  lineColor: [primaryColor1],
                                                ),
                                              )),
                                              Expanded(
                                                  child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    20, 5, 20, 20),
                                                child: ChartPage(
                                                  value: _value2,
                                                  lineColor: [primaryColor2],
                                                ),
                                              )),
                                            ],
                                          )),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }))
      ]),
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
        backgroundColor:
            _connected ? primartCorlor1_light : primartCorlor2_light,
        content: new Text(
          message,
          style: TextStyle(color: _connected ? primaryColor1 : primaryColor2),
        ),
        duration: duration,
      ),
    );
  }
}
