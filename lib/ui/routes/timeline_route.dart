import 'package:flutter/material.dart';
import 'package:twinown_nova/ui/common/counter.dart';
import 'package:twinown_nova/ui/common/debug_button.dart';

import 'package:provider/provider.dart';


class TimelineRouteNotifier with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment(int delta) {
    _count += delta;
    debugPrint(_count.toString());
    notifyListeners();
  }
}


class TimelineRoute extends StatefulWidget {
  TimelineRoute({Key key}) : super(key: key);

  @override
  TimelineRouteState createState() => TimelineRouteState();
}

class TimelineRouteState extends State<TimelineRoute> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) {
          return TimelineRouteNotifier();
        },)
      ],
      child: Scaffold(
        appBar: AppBar(title: Text('Twinown')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Counter(),
            ],
          ),
        ),
        floatingActionButton: DebugButton(),
      )
    );
  }
}
