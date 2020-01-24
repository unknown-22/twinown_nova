import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      _dataQueueList.add([]);
      _listKeyList.add(GlobalKey());
      _scrollControllerList.add(null);
      mastodonApiList.add(MastodonApi(tab.account, httpClient));
    }
  }

  final TwinownSetting twinownSetting;
  final Client httpClient;
  final List<TwinownTab> tabList;
  final TextEditingController quickPostController;

  final List<List<TwinownPost>> _dataQueueList = [];
  final List<List<TwinownPost>> _dataList = [];
  final List<GlobalKey<AnimatedListState>> _listKeyList = [];
  final List<MastodonApi> mastodonApiList = [];
  final List<String> _eventMessageList = [];

  List<List<TwinownPost>> get dataList => _dataList;

  List<String> get eventMessageList => _eventMessageList;

  List<GlobalKey<AnimatedListState>> get listKeyList => _listKeyList;
  String tweetText = '';

  final List<ScrollController> _scrollControllerList = [];
  List<ScrollController> get scrollControllerList => _scrollControllerList;

  int currentIndex = 0;

  void startHomeStream(int tabIndex) {
    mastodonApiList[tabIndex].getHomeStream().listen((post) async {
      _insertItem(tabIndex, 0, post);
      await Future<void>.delayed(Duration(milliseconds: 300));
    });
    mastodonApiList[tabIndex].getHome().then((postList) async {
      for (var post in postList.reversed) {
        // _insertItem(tabIndex, 0, post);
        _dataList[tabIndex].insert(0, post);
        if (_listKeyList[tabIndex].currentState != null) {
          _listKeyList[tabIndex].currentState.insertItem(0);
        }
      }
    });

    Timer.periodic(
      Duration(milliseconds: 300), (_) async {
        if (_scrollControllerList[currentIndex].offset == 0 && _dataQueueList[currentIndex].isNotEmpty) {
          _dataList[tabIndex].insert(0, _dataQueueList[currentIndex].last);
          if (_listKeyList[tabIndex].currentState != null) {
            _listKeyList[tabIndex].currentState.insertItem(0);
          }

          _dataQueueList[currentIndex].removeLast();
          await Future<void>.delayed(Duration(milliseconds: 300));
        }
      },
    );
  }

  void _insertItem(int tabIndex, int index, TwinownPost item) {
    // if (_scrollControllerList[currentIndex].offset == 0 && index == 0) {
    if (index == 0) {
        _dataQueueList[tabIndex].insert(index, item);
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

  void sendTweet() {
    String message = tweetText.replaceAll(RegExp(r'(\r)|(\n)'), '');
    if (message.isNotEmpty) {
      mastodonApiList[0].post(message, tabList[0].account.client.host);
      quickPostController.clear();
      tweetText = '';
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
  TimelineProvider provider;
  List<TwinownTab> tabList;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

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

    return WillPopScope(
      onWillPop: () async {
        if (_key.currentState.isDrawerOpen) {
          Navigator.of(context).pop();
          return true;
        } else {
          _key.currentState.openDrawer();
          return false;
        }
      },
      child: Scaffold(
          key: _key,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: generateLeftDrawerContents(),
            ),
          ),
          endDrawer: Drawer(
            child: ListView.separated(
              itemCount: provider.eventMessageList.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(provider.eventMessageList[index]),
              ),
              separatorBuilder: (BuildContext context, int index) => Divider(
                thickness: 1.0,
              ),
            ),
          ),
          body: MultiProvider(
              providers: [
                ChangeNotifierProvider(builder: (context) => provider)
              ],
              child: Scaffold(
                body: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: PageView(
                          children: pages,
                          onPageChanged: (index) => provider.currentIndex = index,
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
                                maxLines: null,
                                minLines: 1,
                                textInputAction: TextInputAction.next,
                                controller: quickPostController,
                                onChanged: (String message) =>
                                    provider.tweetText = message,
                                onSubmitted: (String message) {
                                  if (!Platform.isWindows) {
                                    provider.sendTweet();
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'ついーとする',
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => provider.sendTweet(),
                              customBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(Icons.send),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }

  List<Widget> generateLeftDrawerContents() {
    var accountList = List.generate(1, (index) {
      return DropdownMenuItem<String>(
        value: tabList[index].account.name,
        child: Text(tabList[index].account.name),
      );
    });

    var leftDrawerContents = <Widget>[
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: FlutterLogo(),
                ),
                Spacer(),
                ListTile(
                  title: Text('あんのーん'),
                  subtitle: Text('unknown_Ex@unkworks.net'),
                ),
                DropdownButton<String>(
                  value: accountList[0].value,
                  isExpanded: true,
                  items: accountList,
                  onChanged: (_) {},
                ),
              ],
            ),
            decoration: BoxDecoration(color: Colors.pinkAccent),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('ツイート'),
          ),
          ListTile(
            leading: Icon(Icons.create),
            title: Text('クイック投稿'),
          ),
          Divider(
            thickness: 1.0,
          ),
        ] +
        List.generate(tabList.length, (index) {
          return ListTile(
            title: Text(tabList[index].account.name),
          );
        }) +
        [
          Divider(
            thickness: 1.0,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Setting'),
          ),
        ];
    return leftDrawerContents;
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
