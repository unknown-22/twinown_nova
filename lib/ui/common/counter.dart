import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  final int data;

  Counter(this.data, {Key key}) : super (key: key);

  @override
  State<StatefulWidget> createState() => CounterState(this.data);
}

class CounterState extends State<Counter> {
  final int data;

  CounterState(this.data) : super();

  @override
  Widget build(BuildContext context) {
    return Text(data.toString(), style: Theme.of(context).textTheme.display1,);
  }

}
