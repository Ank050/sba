import 'package:flutter/material.dart';

class Fan extends StatefulWidget {
  final Function speed;
  final double initSpeed;

  const Fan(this.speed, this.initSpeed, {super.key});

  @override
  State<Fan> createState() => _FanState();
}

class _FanState extends State<Fan> {
  var _fanspeed = 0.0;

  @override
  void initState() {
    _fanspeed = widget.initSpeed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Fan Speed'),
            Slider(
              value: _fanspeed,
              divisions: 7,
              min: 0.0,
              max: 7.0,
              label: _fanspeed.toInt().toString(),
              onChanged: (val) {
                setState(
                  () {
                    _fanspeed = val;
                  },
                );
              },
              onChangeEnd: (val) {
                widget.speed(val);
              },
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0'),
                Text('7'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
