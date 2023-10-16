import 'package:flutter/material.dart';
import "cluster.dart";

bool open = true;
bool gate = true;
late String devID;
List<Cluster> list = [];
// Cluster A =
//     Cluster('Test', '192.168.1.26', 'deep', hex.decode('3CC1F60600000001'), []);

const fan = [
  'images/fan 0.png',
  'images/fan 1.png',
  'images/fan 2.png',
  'images/fan 3.png',
  'images/fan 4.png',
  'images/fan 5.png',
  'images/fan 6.png',
  'images/fan 7.png'
];

const lampOn = 'images/bulb on.png';
const lampOff = 'images/bulb off.png';
const fanOff = 'images/fan off.png';
const info = 'images/add icon.png';
const dOn = 'images/D tap on.png';
const dOff = 'images/D tap off.png';
const twoWay = 'images/two way.png';
const home = 'images/home network.png';
const internet = 'images/internet.png';
const room = 'images/living_room.jpg';

Widget header() {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Image.asset('images/icons/logo.png'),
  );
}
