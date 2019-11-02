import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:twinown_nova/blocs/twinown_setting.dart';
import 'package:twinown_nova/resources/api/mastodon.dart';
import 'package:twinown_nova/resources/models/twinown_account.dart';
import 'package:twinown_nova/resources/models/twinown_post.dart';
import 'package:twinown_nova/ui/common/debug_button.dart';

import 'package:provider/provider.dart';
import 'package:twinown_nova/ui/common/timeline_list.dart';

class TimelineProvider with ChangeNotifier {
  TimelineProvider(this.twinownSetting, this.httpClient);

  final TwinownSetting twinownSetting;
  final Client httpClient;

  TwinownAccount account;
  MastodonApi mastodonApi;

  int _count = 0;

  int get count => _count;

  void countIncrement(int delta) {
    _count += delta;
    notifyListeners();
  }

  final List<TwinownPost> _data = [];

  List<TwinownPost> get data => _data;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  GlobalKey<AnimatedListState> get listKey => _listKey;

  Future<void> reloadHome() async {
    List<TwinownPost> timeline = await mastodonApi.getHome();

    for (TwinownPost post in timeline.reversed.toList()) {
      insertItem(0, post);
      await Future<void>.delayed(Duration(milliseconds: 300));
    }
  }

  void insertItem(int index, TwinownPost item) {
    _data.insert(index, item);
    _listKey.currentState.insertItem(index);
  }

  void removeItem(
      TwinownPost item, Function buildFunction, Animation animation) {
    var removeIndex = _data.indexOf(item);
    if (removeIndex != -1) {
      _data.removeAt(removeIndex);
      listKey.currentState.removeItem(removeIndex,
          (context, animation) => buildFunction(context, item, animation));
    }
  }
}

class TimelineRoute extends StatefulWidget {
  TimelineRoute({Key key, this.twinownSetting, this.httpClient})
      : super(key: key);

  final TwinownSetting twinownSetting;
  final Client httpClient;

  @override
  TimelineRouteState createState() => TimelineRouteState();
}

class TimelineRouteState extends State<TimelineRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text('Twinown')),
        body: MultiProvider(
            providers: [
          ChangeNotifierProvider(
              builder: (context) =>
                  TimelineProvider(widget.twinownSetting, widget.httpClient))
        ],
            child: Scaffold(
              body: TimelineList(),
              floatingActionButton: DebugButton(),
            )));
  }
}
