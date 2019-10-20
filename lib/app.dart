import 'package:flutter/material.dart';
import 'package:twinown_nova/ui/routes/mastodon_login_route.dart';
import 'package:twinown_nova/ui/routes/timeline_route.dart';

import 'blocs/twinown_setting.dart';

class TwinownApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TwinownAppState();
}

class TwinownAppState extends State<TwinownApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Twinown',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Placeholder(),
      routes: <String, WidgetBuilder>{
        '/mastodon_login': (BuildContext context) => MastodonLoginRoute(),
        '/timeline_route': (BuildContext context) => TimelineRoute(),
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    Future(() async {
      try {
        await loadSetting(SettingType.accounts);
      } on SettingFileNotFoundError catch(_) {
        navigatorKey.currentState.pushReplacementNamed('/mastodon_login');
        return;
      }
      navigatorKey.currentState.pushReplacementNamed('/timeline_route');
      return;
    });
  }
}
