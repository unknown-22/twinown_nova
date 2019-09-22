import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(new MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:',),
            Text('0', style: Theme.of(context).textTheme.display1,),
          ],
        ),
      ),
      floatingActionButton: DebugButton(),
    );
  }
}


class Counter extends Text {
  Counter(String data, {Key key}) : super (data, key: key);
}


class DebugButton extends FloatingActionButton {
  DebugButton() : super(
    onPressed: _debugAction,
    tooltip: "Debug",
    child: Icon(Icons.check)
  );

  static void _debugAction() {
  }
}
