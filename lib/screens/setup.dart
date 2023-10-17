import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/images.dart' as i;
import 'package:geolocator/geolocator.dart';

class Setup extends StatefulWidget {
  static const route = 'setup';

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  late BuildContext _context;
  late String _password;
  bool _loading = false;
  late List<WiFiAccessPoint> _networks = [];
  late StreamSubscription<List<WiFiAccessPoint>> _scanSubscription;

  @override
  initState() {
    _permissions();
    super.initState();
  }

  _permissions() async {
    Geolocator geolocator = Geolocator();

    try {
      bool _serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_serviceEnabled) {
        // Location services are not enabled, show a popup to prompt the user to enable them.
        _showLocationServicePopup();
        return;
      }

      LocationPermission _permissionGranted =
          await Geolocator.requestPermission();
      if (_permissionGranted != LocationPermission.always &&
          _permissionGranted != LocationPermission.whileInUse) {
        // Permissions are denied, show a popup to prompt the user to grant location permission.
        _showLocationPermissionPopup();
        return;
      }

      // Continue with your Wi-Fi scanning logic here.
      _scan();
    } catch (e) {
      print('Error during location permission check: $e');
      // Handle the error as needed.
    }
  }

  _scan() async {
    try {
      CanStartScan canStartScanResult = await WiFiScan.instance.canStartScan();

      if (canStartScanResult == CanStartScan.yes) {
        _scanSubscription = WiFiScan.instance.onScannedResultsAvailable.listen(
          (List<WiFiAccessPoint> results) {
            setState(() {
              _networks = results;
              _loading = false;
            });
          },
        );

        setState(() {
          _loading = true;
        });

        await WiFiScan.instance.startScan();
      } else if (canStartScanResult == CanStartScan.noLocationServiceDisabled) {
        print(
            "Location services are disabled. Prompt the user to enable them.");
        _showLocationServicePopup();
      } else {
        print("Cannot start scan: $canStartScanResult");
      }
    } catch (e, stacktrace) {
      print("Error during Wi-Fi scan: $e\n$stacktrace");
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'An error occurred during Wi-Fi scan. Please try again later.'),
        ),
      );
    }
  }

  _connect(WiFiAccessPoint network) {
    // Implement your connection logic using the selected network
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

  void _showLocationServicePopup() {
    showDialog(
      context: _context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Turn On Location'),
          content: const Text(
              'Please turn on location services to use this feature.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showLocationPermissionPopup() {
    showDialog(
      context: _context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location Permission'),
          content: const Text(
              'Please grant location permission to use this feature.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
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
              onPressed: () async {
                await _permissions(); // Ensure permissions are checked before initiating scan
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
              child: Text(
                'SCAN',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
                                    color:
                                        const Color.fromARGB(255, 61, 159, 64),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    onTap: () => _passwordInput(network),
                                    title: Text(
                                      network.ssid,
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    trailing: Text(
                                      'Level: ${network.level}',
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
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
