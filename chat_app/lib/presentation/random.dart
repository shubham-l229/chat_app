import 'package:flutter/material.dart';

class RandomClass extends StatefulWidget {
  const RandomClass({super.key});

  @override
  State<RandomClass> createState() => _RandomClassState();
}

class _RandomClassState extends State<RandomClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Class'),
      ),
    );
  }
}
