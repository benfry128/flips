import 'dart:async';
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
  bool _flipping = false;
  bool _startOrEnd = false;
  double _plusOneY = 0;
  double _opacity = 0;

  void _flipCoin() {
    setState(() {
      _flipping = false;
      _lastFlip = Random().nextBool();
      if (_lastFlip){
        _counter++;
        _plusOneY = 30;
        _opacity = 1;
      } else {
        _counter = 0;
      }
    });
  }

  void _animate() {
    setState(() {
      _startOrEnd = !_startOrEnd;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Stack(
              children: [
                Center(
                  child: Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.displayLarge,
                  )
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  left: MediaQuery.sizeOf(context).width / 2 + 20 + _plusOneY,
                  onEnd: () => setState(() {_plusOneY = 0;}),
                  child: AnimatedOpacity(
                      opacity: _opacity,
                      duration: const Duration(milliseconds: 250),
                      onEnd: () => setState(() {
                        _opacity = 0;
                      }),
                      child: Text(
                        '+1',
                        style: Theme.of(context).textTheme.displaySmall,
                      )
                  )
                )
              ]
            ),
            ButtonTheme(
              minWidth: 130,
              height: 130,
              child: _flipping ? AnimatedCrossFade(
                firstChild: MaterialButton(
                  onPressed: null,
                  shape: const CircleBorder(),
                  disabledColor: Colors.grey,
                  textColor: Colors.white,
                  child: Text(
                    'H',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                secondChild: MaterialButton(
                  onPressed: null,
                  shape: const CircleBorder(),
                  disabledColor: Colors.brown,
                  textColor: Colors.white,
                  child: Text(
                    'T',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                crossFadeState: _startOrEnd ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 1250),
                firstCurve: const Split(0.5, beginCurve: Split(0.5, beginCurve: SawTooth(20), endCurve: SawTooth(10)), endCurve: SawTooth(3)).flipped,
                secondCurve: const Split(0.5, beginCurve: Split(0.5, beginCurve: SawTooth(20), endCurve: SawTooth(10)), endCurve: SawTooth(3)),
              ) : MaterialButton(
                onPressed: () => setState(() {
                  _flipping = true;
                  Timer(const Duration(milliseconds: 10), _animate);
                  Timer(const Duration(milliseconds: 1250), _flipCoin);
                }),
                shape: const CircleBorder(),
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
