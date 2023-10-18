import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'about.dart';
import 'relay_screen.dart';
import 'setup.dart';
import '../data/images.dart' as i;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _pages = ['About', 'Control', 'Setup'];
  final List<String> _images = [
    'images/icons/about.png',
    'images/icons/control.png',
    'images/icons/setup.png'
  ];
  bool demo = false;

  void navigate(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed(About.route);
        break;
      // case 1:
      //   Navigator.of(context)
      //       .push(MaterialPageRoute(builder: (ctx) => Control(demo)));
      //   break;
      case 2:
        Navigator.of(context).pushNamed(Setup.route);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: i.header(),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 70,
        elevation: 0,
        title: Text(
          'Smart Build',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _pages.asMap().entries.map((entry) {
            final index = entry.key;
            final page = entry.value;
            return Container(
              margin: const EdgeInsets.only(
                  top: 15, bottom: 15, left: 30, right: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 107, 105, 105)
                        .withOpacity(0.4),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () => navigate(index),
                child: Container(
                  height: _w / 2.5,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        _images[index],
                        height: _w / 3.5,
                        fit: BoxFit.scaleDown,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        page,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
