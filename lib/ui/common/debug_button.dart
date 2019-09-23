import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twinown_nova/ui/routes/timeline_route.dart';

class DebugButton extends StatelessWidget {
  @override
  Widget build(context) {
    return FloatingActionButton(
      onPressed: () {
        // Debug Action
        Provider.of<TimelineRouteNotifier>(context, listen: false).increment(1);
      },
      tooltip: "Debug",
      child: Icon(Icons.check),
    );
  }
}
