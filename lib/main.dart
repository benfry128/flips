import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Brightness _brightness = Brightness.light;

  void _toggleTheme() {
    setState(() {
      _brightness = _brightness == Brightness.light ? Brightness.dark : Brightness.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flips',
      theme: ThemeData(
        brightness: _brightness,
        textTheme: TextTheme(
          displayMedium: TextStyle(
            color: Colors.white
          )
        )
      ),
      home: MyHomePage(toggleTheme: _toggleTheme, brightness: _brightness),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.toggleTheme, required this.brightness});

  final VoidCallback toggleTheme;
  final Brightness brightness;

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
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _settingsDialogBuilder(context),
        child: Icon(
          Icons.settings,
        )
      ),
    );
  }

  Future<void> _settingsDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Dark'),
                Switch(
                  value: widget.brightness == Brightness.light,
                  onChanged: (bool value) {
                    widget.toggleTheme();
                  },
                ),
                const Text('Light'),
              ]
            )
        );
      }
    );
  }
}
