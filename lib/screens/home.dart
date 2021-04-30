import 'dart:convert';
import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_application_1/screens/chartPage.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_application_1/screens/topBar.dart';

import '../clip/clipping.dart';

//TODO
//CLEAR : FOR TEST CHART
import 'dart:math';

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
  int _deviceState;
  bool isDisconnecting = false;
  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection.isConnected;

// Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  List<FlSpot> _value1 = [for (double i = 0; i <= 60; i++) FlSpot(i, 0)];
  List<FlSpot> _value2 = [for (double i = 0; i <= 60; i++) FlSpot(i, 0)];

  Color primaryColor1 = const Color(0xff6340f2);
  Color primaryColor2 = const Color(0xfffa7167);

  Color secondaryColor1 = Color(0xff1a1f32);
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
      _deviceState = 0;
    });

    await connection.finish();
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
          Stack(
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
                child: Icon(
                  IconData(0xe5ec, fontFamily: 'MaterialIcons'),
                  color: primaryColor1,
                  size: 40,
                ),
              ))
            ],
          ),
          Container(
              child: ListTile(
            title: Text(
              "Enable Bluetooth",
              style: TextStyle(
                  color: secondaryColor1,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            trailing: Switch(
              activeColor: primaryColor1,
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
          )),
          Container(
            child: ListTile(
              leading: DropdownButton(
                hint: Text(
                  'Select device',
                  style: TextStyle(color: secondaryColor1, fontSize: 12),
                ),
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
            ),
          )
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
                      // ignore: unnecessary_statements
                      () async =>
                          await Future<void>.delayed(Duration(seconds: 10));
                      var wave = ascii.decode(snapshot.data).split(',');
                      var i = (_value1.last.x) + 1;
                      // double v1 = double.parse(wave[0]);
                      // double v2 = double.parse(item[1]);
                      print(wave[0] + " // " + wave[1]);
                      _value1.removeAt(0);
                      _value1.add(FlSpot(i, double.parse(wave[0])));

                      _value2.removeAt(0);
                      // item = _generateData(i);
                      _value2.add(FlSpot(i, double.parse(wave[0])));
                      i += 1;
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
                                            wave1: _value1.last.y,
                                            wave2: _value2.last.y,
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
                                                    20, 20, 20, 10),
                                                child: ChartPage(
                                                  value: _value1,
                                                  lineColor: [primaryColor1],
                                                ),
                                              )),
                                              Expanded(
                                                  child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    20, 10, 20, 20),
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
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}
