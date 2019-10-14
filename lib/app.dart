import 'package:flutter/material.dart';
import 'package:twinown_nova/ui/routes/timeline_route.dart';


class TwinownApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var timelineRoute = TimelineRoute();
    // var loginRoute = MastodonLoginRoute();

    return MaterialApp(
      title: 'Twinown',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: timelineRoute,
    );
  }
}
