import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/images.dart' as i;
import 'package:app_settings/app_settings.dart';
import 'package:convert/convert.dart';

class Setup extends StatefulWidget {
  static const route = 'setup';

  const Setup({Key? key}) : super(key: key);

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  late BuildContext _context;
  late String _password;
  bool _loading = false;
  late List<WiFiAccessPoint> _networks = [];
  late StreamSubscription<List<WiFiAccessPoint>> _scanSubscription;
  late Socket _sock;

  @override
  initState() {
    _permissions();
    super.initState();
  }

  _permissions() async {
    // You may need to check permissions for the wifi_scan package
  }

  _scan() async {
    try {
      CanStartScan canStartScanResult = await WiFiScan.instance.canStartScan();

      switch (canStartScanResult) {
        case CanStartScan.yes:
          setState(() {
            _loading = true;
          });

          _startWiFiScan();
          break;
        case CanStartScan.noLocationServiceDisabled:
          _showLocationServiceDisabledSnackBar();
          break;
        default:
          _showErrorSnackBar('Cannot start scan: $canStartScanResult');
      }
    } catch (e, stacktrace) {
      print("Error during Wi-Fi scan: $e\n$stacktrace");
      _handleScanError();
    }
  }

  _startWiFiScan() async {
    _scanSubscription = WiFiScan.instance.onScannedResultsAvailable.listen(
      (List<WiFiAccessPoint> results) {
        setState(() {
          _networks = results;
          _loading = false;
        });
      },
    );

    await WiFiScan.instance.startScan();
  }

  _showLocationServiceDisabledSnackBar() {
    final snackBar = SnackBar(
      content: const Text(
        'Please enable location services to scan for Wi-Fi networks.',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      backgroundColor: Colors.blue,
      behavior: SnackBarBehavior.floating,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      action: SnackBarAction(
        label: 'Open Settings',
        textColor: Colors.white,
        onPressed: () {
          AppSettings.openAppSettings(type: AppSettingsType.location);
          Navigator.of(context).pop();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
      ),
    );
  }

  _handleScanError() {
    setState(() {
      _loading = false;
    });

    _showErrorSnackBar(
        'An error occurred during Wi-Fi scan. Please try again later.');
  }

  _connect(WiFiAccessPoint network) async {
    _sock = await Socket.connect('192.168.1.50', 5555);
    _sendSTA(network);
  }

  _sendSTA(WiFiAccessPoint network) async {
    _connect(network);
    List<int> data = hex.decode(
        '2b${network.ssid.length + _password.length + 7}5700535401${hex.encode(network.ssid.codeUnits)}3a${hex.encode(_password.codeUnits)}');
    _sock.add(data);
    _sock.listen(
      (dg) {
        if (dg[2] == 0x57 && dg[4] == 0x53 && dg[5] == 0x54) {
          _sock.close();
          ScaffoldMessenger.of(_context).showSnackBar(
            const SnackBar(content: Text('Command sent')),
          );
          Navigator.of(_context).pop();
        }
      },
    );
  }

  _passwordInput(WiFiAccessPoint network) {
    showDialog(
      context: _context,
      builder: (cont) {
        return AlertDialog(
          title: Text(network.ssid),
          content: TextFormField(
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password"),
            onChanged: (val) {
              _password = val;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(cont).pop();
                _connect(network);
              },
              child: const Text("Connect"),
            ),
            TextButton(
              onPressed: () => Navigator.of(cont).pop(),
              child: const Text("Cancel"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    _context = context;
    return Scaffold(
      appBar: AppBar(
        leading: i.header(),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 70,
        elevation: 0,
        title: Text(
          'Smart Home',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                  Timer(const Duration(seconds: 4), () {
                    setState(() {
                      _loading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('An error occurred. Try again later'),
                      ),
                    );
                  });
                });
                _scan();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'SCAN',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        children: _networks
                            .map<Widget>(
                              (network) => Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    onTap: () => _passwordInput(network),
                                    title: Text(
                                      network.ssid,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: Text(
                                      'Level: ${network.level}',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scanSubscription.cancel();
    super.dispose();
  }
}
