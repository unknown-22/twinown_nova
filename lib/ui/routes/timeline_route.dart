import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:twinown_nova/blocs/twinown_setting.dart';
import 'package:twinown_nova/resources/api/mastodon.dart';
import 'package:twinown_nova/resources/models/twinown_post.dart';
import 'package:twinown_nova/resources/models/twinown_tab.dart';

import 'package:provider/provider.dart';
import 'package:twinown_nova/ui/common/timeline_list.dart';

class TimelineRouteArguments {
  TimelineRouteArguments(this.tabList);

  final List<TwinownTab> tabList;
}

class TimelineProvider with ChangeNotifier {
  TimelineProvider(this.twinownSetting, this.httpClient, this.tabList,
      this.quickPostController) {
    for (var tab in tabList) {
      _dataList.add([]);
      _listKeyList.add(GlobalKey());
      mastodonApiList.add(MastodonApi(tab.account, httpClient));
    }
  }

  final TwinownSetting twinownSetting;
  final Client httpClient;
  final List<TwinownTab> tabList;
  final TextEditingController quickPostController;

  final List<List<TwinownPost>> _dataList = [];
  final List<GlobalKey<AnimatedListState>> _listKeyList = [];
  final List<MastodonApi> mastodonApiList = [];

  List<List<TwinownPost>> get dataList => _dataList;

  List<GlobalKey<AnimatedListState>> get listKeyList => _listKeyList;

  void startHomeStream(int tabIndex) {
    mastodonApiList[tabIndex].getHomeStream().listen((post) async {
      _insertItem(tabIndex, 0, post);
      await Future<void>.delayed(Duration(milliseconds: 300));
    });
    mastodonApiList[tabIndex].getHome().then((postList) async {
      for (var post in postList.reversed) {
        _insertItem(tabIndex, 0, post);
        await Future<void>.delayed(Duration(milliseconds: 300));
      }
    });
  }

  void _insertItem(int tabIndex, int index, TwinownPost item) {
    _dataList[tabIndex].insert(index, item);
    if (_listKeyList[tabIndex].currentState != null) {
      _listKeyList[tabIndex].currentState.insertItem(index);
    }
  }

  void removeItem(int tabIndex, TwinownPost item, Function buildFunction,
      Animation animation) {
    var removeIndex = _dataList[tabIndex].indexOf(item);
    if (removeIndex != -1) {
      _dataList[tabIndex].removeAt(removeIndex);
      _listKeyList[tabIndex].currentState.removeItem(removeIndex,
          (context, animation) => buildFunction(context, item, animation));
    }
  }

  void sendTweet(String message) {
    mastodonApiList[0].post(message, tabList[0].account.client.host);
    quickPostController.clear();
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
  TimelineProvider provider;
  List<TwinownTab> tabList;

  @override
  Widget build(BuildContext context) {
    final TimelineRouteArguments args =
        ModalRoute.of(context).settings.arguments;
    tabList = args.tabList;
    List<Widget> pages = List.generate(tabList.length,
        (i) => TimelineList(twinownTab: tabList[i], tabIndex: i));

    TextEditingController quickPostController = TextEditingController();

    provider = TimelineProvider(
        widget.twinownSetting, widget.httpClient, tabList, quickPostController);

    return Scaffold(
        body: MultiProvider(
            providers: [ChangeNotifierProvider(builder: (context) => provider)],
            child: Scaffold(
              body: SafeArea(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: PageView(
                        children: pages,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 4.0, left: 4.0, right: 4.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: TextField(
                              // maxLines: null,
                              // minLines: 1,
                              // keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              controller: quickPostController,
                              onChanged: (_) {},
                              onSubmitted: (String message) {
                                provider.sendTweet(message);
                              },
                              decoration: InputDecoration(
                                labelText: 'ついーとする',
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            // customBorder:
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(Icons.send),
                            ),
                          ),
                          // RaisedButton.icon(onPressed: () {}, icon: Icon(Icons.send), label: Text('')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // body: TimelineList(),
              // floatingActionButton: DebugButton(),
            )));
  }

  @override
  void initState() {
    super.initState();
    initializeTab();
  }

  void initializeTab() {
    Future<void>.delayed(Duration(milliseconds: 0)).then((_) {
      tabList.asMap().forEach((i, tab) {
        if (tab.tabType == TabType.homeStream) {
          provider.startHomeStream(i);
        }
      });
    });
  }
}
