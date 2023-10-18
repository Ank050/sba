// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:convert/convert.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../data/images.dart' as i;
// import '../widgets/fan.dart';

// class RelayScreen extends StatefulWidget {
//   final int bulbNum;
//   final int fanNum;
//   final int index;
//   RelayScreen(
//       {super.key,
//       required this.bulbNum,
//       required this.fanNum,
//       required this.index});

//   @override
//   State<RelayScreen> createState() => _RelayScreenState();
// }

// class _RelayScreenState extends State<RelayScreen> {
//   final _key = GlobalKey<FormFieldState>();
//   List<bool> _load = List.filled(10, false),
//       _double = List.filled(10, false),
//       _two = List.filled(10, false),
//       _fan = [false, false];
//   List<double> _fanspeed = [0.0, 0.0];
//   late List<int> _masterdata, _masterieee, _masterload = [-1, -1];
//   bool _master = false, _doubleConfig = false, _loading = true, _timer = false;
//   bool _slaveSelect = false;
//   IconData _icon = Icons.brightness_1_outlined;
//   late Socket _sock;
//   late BuildContext _context;
//   late String _back;
//   late double _h, _w;
//   late int _select;
//   var _data;

//   @override
//   void initState() {
//     _connect();
//     super.initState();
//   }

//   _connect() async {
//     if (i.gate)
//       _sock = await Socket.connect(i.list[i.n].ip, 5555);
//     else {
//       _sock = await Socket.connect('35.200.222.22', 30690);
//       setState(() {
//         _sock.add('ANDROIDID:${i.devid.toUpperCase()} 00 100'.codeUnits);
//       });
//     }
//     _setinitial();
//   }

//   // Function to set initial configuration
//   _setinitial() {
//     // Set initial configuration using the socket
//   }

//   // Function to control the relay based on the given number
//   _control(int numb) {
//     // Control the relay using the given number
//   }

//   // Function to toggle the relay based on the type
//   _toggle(String type) {
//     // Toggle the relay based on the type
//   }

//   // Function to turn off the fan based on the type
//   _fanoff(String type) {
//     // Turn off the fan based on the type
//   }

//   // Function to change the fan speed based on the type and level
//   _speedchange(String type, int level) {
//     // Change the fan speed based on the type and level
//   }

//   // Function to control the backlight with the given value
//   _backlight(String val) {
//     // Control the backlight with the given value
//   }

//   // Function to read master configuration
//   _readmaster() {
//     // Read the master configuration
//   }

//   // Function to remove slave configuration based on the type
//   _removeslave(String type) {
//     // Remove slave configuration based on the type
//   }

//   // Function to write master configuration
//   _writemaster() {
//     // Write master configuration
//   }

//   // Function to write slave configuration
//   _writeslave() {
//     // Write slave configuration
//   }

//   // Function for double-tap configuration
//   _doubleTap() {
//     // Show a dialog for double-tap configuration
//   }

//   // Function for two-way configuration
//   _twoWay() {
//     // Show a dialog for two-way configuration
//   }

//   // Function to select the master load
//   _loadselect(BuildContext ctx) {
//     // Show a dialog to select the master load
//   }

//   // Function to build the load button widget
//   Widget _loadbutton(int n, String type) {
//     // Build the load button widget
//   }

//   // Function to build the fan button widget
//   _fanbutton(int n, String type) {
//     // Build the fan button widget
//   }

//   // Function to handle speed change for fan 1
//   _speed1(double val) {
//     // Handle speed change for fan 1
//   }

//   // Function to handle speed change for fan 2
//   _speed2(double val) {
//     // Handle speed change for fan 2
//   }

//   // Function to handle settings menu options
//   void _settings(String choice) {
//     // Handle settings menu options
//   }

//   // Function to store data in SharedPreferences
//   _storeData() async {
//     // Store data in SharedPreferences
//   }

//   // Function to show error message
//   errormessage() {
//     // Show an error message
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Build the UI using StreamBuilder
//   }

//   @override
//   void dispose() {
//     // Close the socket connection and store data when disposing
//   }
// }

// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:convert/convert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/images.dart' as i;
import '../widgets/fan.dart';

class RelayScreen extends StatefulWidget {
  final int bulbNum;
  final int fanNum;
  final int index;

  RelayScreen(this.bulbNum, this.fanNum, this.index);

  @override
  _RelayScreenState createState() => _RelayScreenState();
}

class _RelayScreenState extends State<RelayScreen> {
  final _key = GlobalKey<FormFieldState>();
  final List<bool> _load = List.filled(10, false),
      _double = List.filled(10, false),
      _two = List.filled(10, false),
      _fan = [false, false];
  final List<double> _fanspeed = [0.0, 0.0];
  late List<int> _masterdata, _masterieee, _masterload = [-1, -1];
  late bool _master = false,
      _doubleConfig = false,
      _loading = true,
      _timer = false;
  late bool _slaveSelect = false;
  late IconData _icon = Icons.brightness_1_outlined;
  late Socket _sock;
  late BuildContext _context;
  late String _back;
  late double _h, _w;
  late int _select;
  var _data;

  @override
  void initState() {
    _connect();
    super.initState();
  }

  _connect() async {
    if (i.gate) {
      _sock = await Socket.connect(i.list[i.n].ip, 5555);
    } else {
      _sock = await Socket.connect('35.200.222.22', 30690);
      setState(() {
        _sock.add('ANDROIDID:${i.devid.toUpperCase()} 00 100'.codeUnits);
      });
    }
    _setinitial();
  }

  _setinitial() {
    final List<int> s = hex.decode(
        '${i.gate ? '' : '2b1d47${i.list[i.n].ieee}'}2b1201${i.list[i.n].boards[widget.index].ieee}ffff08fc5001010e');
    _sock.add(s);
    setState(() {
      _loading = false;
    });
  }

  _control(int numb) {
    final List<int> s = hex.decode(
        '${i.gate ? '' : '2b2147${i.list[i.n].ieee}'}2b1601${i.list[i.n].boards[widget.index].ieee}ffff08fc500101000300100$numb');
    _sock.add(s);
    setState(() {});
  }

  _toggle(String type) {
    final List<int> s = hex.decode(
        '${i.gate ? '' : '2b1d47${i.list[i.n].ieee}'}2b1201${i.list[i.n].boards[widget.index].ieee}ffff${type}0006010102');
    _sock.add(s);
    setState(() {});
  }

  _fanoff(String type) {
    final List<int> s = hex.decode(
        '${i.gate ? '' : '2b2247${i.list[i.n].ieee}'}2b1701${i.list[i.n].boards[widget.index].ieee}ffff${type}0008110103200121ffff');
    _sock.add(s);
    setState(() {});
  }

  _speedchange(String type, int level) {
    final List<int> s = hex.decode(
        '${i.gate ? '' : '2b2247${i.list[i.n].ieee}'}2b1701${i.list[i.n].boards[widget.index].ieee}ffff${type}0008110100200${level}21ffff');
    _sock.add(s);
    setState(() {});
  }

  _backlight(String val) {
    _back = val;
    final List<int> s = hex.decode(
        '2b1701${i.list[i.n].boards[widget.index].ieee}ffff08fc50110112030010000$val');
    _sock.add(s);
    setState(() {});
  }

  _readmaster() {
    final List<int> s = hex.decode(
        '2b1601${i.list[i.n].boards[widget.index].ieee}ffff08fc5011011003001001');
    _sock.add(s);
  }

  _removeslave(String type) {
    final List<int> s = hex.decode(
        '2d1601${i.list[i.n].boards[widget.index].ieee}ffff${type}fc5000011003000002');
    _sock.add(s);
    setState(() {});
  }

  _writemaster() {
    _masterdata[_masterload[1] + 23] = _masterload[1] + 8;
    _masterdata[22] = 0;
    for (int x = 0; x < 4; x++) {
      _masterdata[4 * _masterload[1] + x + 35] = _masterdata[x + 7];
      _masterdata[x + 7] = _masterieee[x + 4];
    }
    _sock.add(_masterdata);
    setState(() {});
  }

  _writeslave() {
    _masterdata[_masterload[1] + 23] = _masterload[1] + 0x88;
    List<int> ieee = hex.decode(i.list[i.n].boards[widget.index].ieee);
    for (int x = 0; x < 4; x++) {
      _masterdata[4 * _masterload[1] + x + 35] = _masterdata[x + 7];
      _masterdata[x + 7] = ieee[x + 4];
    }
    _sock.add(_masterdata);
  }

  _doubleTap() {
    showDialog(
      context: _context,
      builder: (ctx) => AlertDialog(
        content: Text(
            'Do you want to ${_double[_select] ? 'disable' : 'enable'} double tap for ${i.list[i.n].boards[widget.index].lamps[_select]}?'),
        actions: [
          TextButton(
              onPressed: () {
                String l = '';
                for (int i = 0; i < widget.bulbNum; i++) {
                  if (i == _select) {
                    l += _double[i] ? '00' : '01';
                    continue;
                  }
                  l += _double[i] ? '01' : '00';
                }
                final List<int> s = hex.decode(
                    '2b${(widget.bulbNum + 22).toRadixString(16)}01${i.list[i.n].boards[widget.index].ieee}ffff08fc5011011103001000$l');
                _sock.add(s);
                Navigator.pop(ctx);
                setState(
                  () {
                    _doubleConfig = false;
                  },
                );
              },
              child: const Text('Yes')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(
                () {
                  _doubleConfig = false;
                },
              );
            },
            child: const Text('No'),
          )
        ],
      ),
    );
  }

  _twoWay() {
    showDialog(
      context: _context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select the device for master',
            textAlign: TextAlign.center),
        content: SizedBox(
          height: _h / 1.7,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, index) {
              return TextButton(
                onPressed: () {
                  _masterload[0] = index;
                  _masterieee = hex.decode(i.list[i.n].boards[index].ieee);
                  _loadselect(ctx);
                },
                child: Column(
                  children: [
                    Text(i.list[i.n].boards[index].name),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: _h / 18,
                      width: _w / 3,
                      child: Image.asset(
                        i.demoboard[i.list[i.n].boards[index].type]![1],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: i.list[i.n].boards.length,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _masterieee = [];
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }

  _loadselect(BuildContext ctx) {
    showDialog(
      context: _context,
      builder: (cont) => AlertDialog(
        title:
            const Text('Select the master load', textAlign: TextAlign.center),
        content: SizedBox(
          height: _h / 1.5,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, index) {
              return TextButton(
                onPressed: () {
                  _masterload[1] = index;
                  _writemaster();
                  Navigator.of(cont).pop();
                  Navigator.of(ctx).pop();
                },
                child: Column(
                  children: [
                    Text(i.list[i.n].boards[_masterload[0]].lamps[index]),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: _h / 18,
                      width: _w / 3,
                      child: Image.asset(
                        i.lampOn,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: i.list[i.n].boards[_masterload[0]].lamps.length,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _masterieee = [];
              Navigator.of(cont).pop();
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }

  Widget _loadbutton(int n, String type) {
    return Column(
      children: [
        Text(i.list[i.n].boards[widget.index].lamps[n - 1]),
        TextButton(
          onPressed: () {
            if (!_two[n - 1]) {
              if (_doubleConfig) {
                setState(() {
                  _select = n - 1;
                  ScaffoldMessenger.of(_context).hideCurrentSnackBar();
                });
                _doubleTap();
              } else if (_slaveSelect) {
                if (_double[n - 1]) {
                  showDialog(
                    context: _context,
                    builder: (ctx) => AlertDialog(
                      content: const Text(
                          'The selected load should not be in any other configuration'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  );
                } else {
                  setState(
                    () {
                      _select = n - 1;
                      _slaveSelect = false;
                      ScaffoldMessenger.of(_context).hideCurrentSnackBar();
                    },
                  );
                  _twoWay();
                }
              } else {
                if (_double[n - 1] && !_timer) {
                  showDialog(
                    context: _context,
                    builder: (ctx) => AlertDialog(
                      content: Text(
                          'Do you really want to switch ${_load[n - 1] ? 'off' : 'on'}?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              _timer = true;
                              Timer(const Duration(seconds: 5),
                                  () => _timer = false);
                              ScaffoldMessenger.of(_context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Press the switch again')));
                              Navigator.pop(ctx);
                            },
                            child: const Text('Yes')),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('No'),
                        )
                      ],
                    ),
                  );
                }
                if (!_double[n - 1] || _timer) {
                  _timer = false;
                  _toggle(type);
                }
              }
            } else if (_slaveSelect) {
              _select = n - 1;
              _slaveSelect = false;
              showDialog(
                context: _context,
                builder: (ctx) => AlertDialog(
                  content: Text(
                      'Do you want to disable two way for ${i.list[i.n].boards[widget.index].lamps[_select]}?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _removeslave(type);
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('No'),
                    )
                  ],
                ),
              );
            }
          },
          onLongPress: () {
            String name = '';
            showDialog(
              context: _context,
              builder: (cont) {
                return AlertDialog(
                  content: Form(
                    key: _key,
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: "Name"),
                      autofocus: true,
                      initialValue:
                          i.list[i.n].boards[widget.index].lamps[n - 1],
                      maxLength: 15,
                      onChanged: (val) => name = val,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(
                          () {
                            i.list[i.n].boards[widget.index]
                                .setlamp(n - 1, name);
                          },
                        );
                        Navigator.of(cont).pop();
                        //_storeData();
                      },
                      child: const Text("Save"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(cont).pop();
                      },
                      child: const Text("Cancel"),
                    )
                  ],
                );
              },
            );
          },
          style: TextButton.styleFrom(shape: const CircleBorder()),
          child: Container(
            height: widget.bulbNum < 7 ? _h / 7 : _h / 9.5,
            width: widget.bulbNum < 7 ? _w / 4 : _w / 5.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage(
                    _two[n - 1]
                        ? i.twoWay
                        : (_double[n - 1]
                            ? (_load[n - 1] ? i.dOn : i.dOff)
                            : (_load[n - 1] ? i.lampOn : i.lampOff)),
                  ),
                  fit: BoxFit.contain),
            ),
          ),
        )
      ],
    );
  }

  _fanbutton(int n, String type) {
    return TextButton(
      onPressed: () {
        if (_fan[n - 1]) {
          _fanoff(type);
        } else {
          _toggle(type);
        }
      },
      child: SizedBox(
        height: _h / 14,
        width: _w / 8,
        child: _fan[n - 1]
            ? Image.asset(i.fan[_fanspeed[n - 1].toInt()])
            : Image.asset(i.fanOff),
      ),
      onLongPress: () {
        if (_fan[n - 1]) {
          showDialog(
            context: _context,
            builder: (c) => Fan((n == 1) ? _speed1 : _speed2, _fanspeed[n - 1]),
          );
        }
      },
    );
  }

  _speed1(double val) {
    _speedchange('0c', val.toInt());
  }

  _speed2(double val) {
    _speedchange('10', val.toInt());
  }

  void _settings(String choice) {
    if (choice == '1') {
      ScaffoldMessenger.of(_context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 10),
          content: Text('Select the load to set double tap'),
        ),
      );
      setState(
        () {
          _doubleConfig = true;
          Timer(
            const Duration(seconds: 30),
            () {
              setState(
                () {
                  _doubleConfig = false;
                },
              );
            },
          );
        },
      );
    } else if (choice == '2') {
      ScaffoldMessenger.of(_context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 10),
          content: Text('Select the slave switch'),
        ),
      );
      setState(
        () {
          _readmaster();
          _slaveSelect = true;
          Timer(
            const Duration(seconds: 60),
            () {
              if (_slaveSelect) {
                setState(
                  () {
                    _slaveSelect = false;
                  },
                );
              }
            },
          );
        },
      );
    } else if (choice == '3') {
      showDialog(
        context: _context,
        useSafeArea: true,
        builder: (cont) {
          return AlertDialog(
            title: const Center(
              child: Text('Select a configuration'),
            ),
            content: SizedBox(
              height: _h / 4,
              width: _w / 1.5,
              child: ListView(
                children: [
                  Card(
                    color: Colors.grey[300],
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(cont).pop();
                        _backlight('0');
                      },
                      child: const Text('Continuous ON'),
                    ),
                  ),
                  Card(
                    color: Colors.grey[300],
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(cont).pop();
                        _backlight('1');
                      },
                      child: const Text('Delayed OFF'),
                    ),
                  ),
                  Card(
                    color: Colors.grey[300],
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(cont).pop();
                        _backlight('2');
                      },
                      child: const Text('Delayed Dim'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  _storeData() async {
    final pref = await SharedPreferences.getInstance();
    final key = i.list[i.n].ieee;
    final String listJson = json.encode(
      i.list[i.n].boards.map((e) => e.toJson()).toList(),
    );
    pref.setString('board $key', listJson);
  }

  errormessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('An error occured. Try again')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ieee = ModalRoute.of(context)?.settings.arguments;
    _context = context;
    _h = MediaQuery.of(context).size.height;
    _w = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: _sock,
      builder: (ctx, snap) {
        if (snap.hasData) {
          List temp = snap.data as List;
          if (!i.gate) temp = temp.sublist(11, temp.length);
          if (temp != _data) {
            if (temp[10] == ieee) {
              if (temp[18] == 0x01 && temp.length > 25) {
                for (int k = 0, x = 0; k < widget.bulbNum; k++) {
                  if (k == 4 || k == 7) x++;
                  _load[k] = (temp[k + x + 20] % 16 != 0);
                  _double[k] = (temp[k + x + 20] ~/ 16 == 1);
                  _two[k] = (temp[k + x + 20] ~/ 16 == 2);
                }
                for (int k = 0; k < widget.fanNum; k++) {
                  _fan[k] = (temp[24 + k * 4] ~/ 16 == 0);
                  _fanspeed[k] =
                      _fan[k] ? temp[24 + k * 4].toDouble() : _fanspeed[k];
                }
              } else if (temp[18] == 0x11) {
                if (temp[22] == 0x00) {
                  try {
                    _double[_select] = !_double[_select];
                    _select = -1;
                  } catch (_) {}
                  if (_back == '0') {
                    _icon = Icons.brightness_7;
                  } else if (_back == '1')
                    // ignore: curly_braces_in_flow_control_structures
                    _icon = Icons.brightness_5;
                  // ignore: curly_braces_in_flow_control_structures
                  else if (_back == '2') _icon = Icons.brightness_6;
                } else {
                  errormessage();
                }
              } else if (temp[18] == 0x10) {
                if (temp[1] == 0x52 && _masterdata == []) {
                  _masterdata = temp.cast<int>();
                } else {
                  if (temp[22] == 0) {
                    if (_two[_select]) {
                      _two[_select] = false;
                    } else {
                      _two[_select] = true;
                      _masterdata = [];
                      _masterload = [-1, -1];
                      _masterieee = [];
                    }
                    _select = -1;
                  } else {
                    errormessage();
                  }
                }
              }
            } else if (temp[10] == _masterieee[7]) {
              if (temp[22] == 0) {
                _writeslave();
              } else {
                errormessage();
              }
            }
          }
          _data = temp;
        }
        if (widget.bulbNum > 1) {
          _master = false;
          for (int k = 0; k < widget.bulbNum; k++) {
            _master = (_master || _load[k]);
          }
          for (int k = 0; k < widget.fanNum; k++) {
            _master = (_master || _fan[k]);
          }
        }
        return Scaffold(
          appBar: AppBar(
            leading: i.header(),
            title: const Text(
              'Smart Build',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            actions: [
              if (_icon != Icons.brightness_1_outlined)
                Icon(
                  _icon,
                  color: Theme.of(context).iconTheme.color,
                ),
              if (i.gate)
                PopupMenuButton(
                  icon: Icon(
                    Icons.settings,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  itemBuilder: (ctx) {
                    return [
                      const PopupMenuItem<String>(
                        value: '1',
                        child: Text('Double Tap'),
                      ),
                      const PopupMenuItem<String>(
                        value: '3',
                        child: Text('Backlight'),
                      )
                    ];
                  },
                  onSelected: _settings,
                )
            ],
          ),
          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(i.room,
                          height: _h / 5,
                          width: double.infinity,
                          fit: BoxFit.fill),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                i.list[i.n].boards[widget.index].name,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            if (widget.bulbNum > 1)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Switch(
                                        value: _master,
                                        onChanged: (newval) {
                                          setState(
                                            () {
                                              _master = newval;
                                            },
                                          );
                                          _control(_master ? 1 : 0);
                                        },
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                      const Text('Master'),
                                      if (!_master)
                                        TextButton(
                                          onPressed: () {
                                            _control(2);
                                          },
                                          child: const Column(
                                            children: [
                                              Text('Restore'),
                                              Icon(Icons.cached_sharp)
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                  if (widget.fanNum > 0)
                                    Row(
                                      children: [
                                        _fanbutton(1, '0c'),
                                        if (widget.fanNum == 2)
                                          _fanbutton(2, '10')
                                      ],
                                    ),
                                ],
                              ),
                            SizedBox(height: _h / 30),
                            SizedBox(
                              height: _h / 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _loadbutton(1, '08'),
                                      if (widget.bulbNum > 2 &&
                                          widget.bulbNum < 5)
                                        _loadbutton(3, '0a'),
                                      if (widget.bulbNum > 4 &&
                                          widget.bulbNum < 7)
                                        _loadbutton(4, '0b'),
                                      if (widget.bulbNum > 6)
                                        _loadbutton(5, '0d'),
                                      if (widget.bulbNum > 8)
                                        _loadbutton(9, '12'),
                                    ],
                                  ),
                                  if (widget.bulbNum > 1)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        _loadbutton(2, '09'),
                                        if (widget.bulbNum == 4)
                                          _loadbutton(4, '0b'),
                                        if (widget.bulbNum > 4 &&
                                            widget.bulbNum < 7)
                                          _loadbutton(5, '0d'),
                                        if (widget.bulbNum > 6)
                                          _loadbutton(6, '0e'),
                                        if (widget.bulbNum == 10)
                                          _loadbutton(10, '13'),
                                      ],
                                    ),
                                  if (widget.bulbNum > 4)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        _loadbutton(3, '0a'),
                                        if (widget.bulbNum == 6)
                                          _loadbutton(6, '0e'),
                                        if (widget.bulbNum > 6)
                                          _loadbutton(7, '0f'),
                                      ],
                                    ),
                                  if (widget.bulbNum > 6)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        _loadbutton(4, '0b'),
                                        if (widget.bulbNum > 7)
                                          _loadbutton(8, '11'),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          floatingActionButton: _doubleConfig || _slaveSelect
              ? FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.close),
                  onPressed: () {
                    setState(
                      () {
                        _doubleConfig = false;
                        _slaveSelect = false;
                        ScaffoldMessenger.of(_context).hideCurrentSnackBar();
                      },
                    );
                  },
                )
              : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  @override
  void dispose() {
    _sock.close();
    _storeData();
    super.dispose();
  }
}
