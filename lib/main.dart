import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flips',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _lastFlip = false;

  void _flipCoin() {
    setState(() {
      _lastFlip = Random().nextBool();
      if (_lastFlip){
        _counter++;
      } else {
        _counter = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            ButtonTheme(
              minWidth: 130,
              height: 130,
              child: MaterialButton(
                onPressed: _flipCoin,
                shape: CircleBorder(),
                color: _lastFlip ? Colors.grey : Colors.brown,
                textColor: Colors.white,
                child: Text(
                  _lastFlip ? 'H' : 'T',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
