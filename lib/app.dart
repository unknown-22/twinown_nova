import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:twinown_nova/ui/routes/mastodon_login_route.dart';
import 'package:twinown_nova/ui/routes/timeline_route.dart';

import 'blocs/twinown_setting.dart';

class TwinownApp extends StatefulWidget {
  const TwinownApp({Key key, this.twinownSetting, this.httpClient})
      : super(key: key);

  final TwinownSetting twinownSetting;
  final Client httpClient;

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
        '/mastodon_login': (BuildContext context) => MastodonLoginRoute(
            twinownSetting: widget.twinownSetting,
            httpClient: widget.httpClient),
        '/timeline_route': (BuildContext context) => TimelineRoute(
            twinownSetting: widget.twinownSetting,
            httpClient: widget.httpClient),
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _prepare();
  }

  Future<void> _prepare() async {
    widget.twinownSetting.loadSetting(SettingType.accounts).then((dynamic _) {
      navigatorKey.currentState.pushReplacementNamed('/timeline_route');
    }).catchError((Object _) {
      navigatorKey.currentState.pushReplacementNamed('/mastodon_login');
    }, test: (Object e) => e is SettingFileNotFoundError);
  }
}
