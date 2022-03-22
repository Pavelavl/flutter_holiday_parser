import 'package:flutter/material.dart';
import 'package:parser/home_screen.dart';

void main() {
  runApp(Homescreen());
}

class Homescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Calendar();
  }
}
