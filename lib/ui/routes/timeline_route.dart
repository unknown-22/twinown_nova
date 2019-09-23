import 'package:flutter/material.dart';
import 'package:twinown_nova/ui/common/debug_button.dart';

import 'package:provider/provider.dart';
import 'package:twinown_nova/ui/common/timeline_list.dart';


class TimelineProvider with ChangeNotifier {
  TimelineProvider() {
    // TODO some init
  }

  int _count = 0;
  int get count => _count;

  void countIncrement(int delta) {
    _count += delta;
    debugPrint(_count.toString());
    notifyListeners();
  }

  final List<String> _data = ['data1', 'data2', 'data3', 'data4', 'data5'];
  List<String> get data => _data;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  GlobalKey<AnimatedListState> get listKey => _listKey;

  void insertItem(int index, String item) {
    _data.insert(index, item);
    _listKey.currentState.insertItem(index);
  }

  void removeItem(String item, Function buildFunction, Animation animation) {
    var removeIndex = _data.indexOf(item);
    _data.removeAt(removeIndex);
    listKey.currentState.removeItem(
      removeIndex,
      (context, animation) => buildFunction(context, item, animation)
    );
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
    return Scaffold(
      appBar: AppBar(title: Text('Twinown')),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              builder: (context) => TimelineProvider()
          )
        ],
        child: Scaffold(
          body: TimelineList(),
          floatingActionButton: DebugButton(),
        )
      )
    );
  }
}