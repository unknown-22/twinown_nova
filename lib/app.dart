import 'package:flutter/material.dart';
import 'package:twinown_nova/ui/routes/mastodon_login_route.dart';
import 'package:twinown_nova/ui/routes/timeline_route.dart';


class TwinownApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // TODO 初回起動時変更
    var timelineRoute = TimelineRoute();
    var loginRoute = MastodonLoginRoute();

    return MaterialApp(
      title: 'Flutter Demo',  // FIXME
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: loginRoute,
    );
  }
}
