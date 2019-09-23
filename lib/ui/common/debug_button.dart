import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twinown_nova/ui/routes/timeline_route.dart';

class DebugButton extends StatelessWidget {
  @override
  Widget build(context) {
    return FloatingActionButton(
      onPressed: () {
        // Debug Action
        var provider = Provider.of<TimelineProvider>(context, listen: false);
        provider.insertItem(0, "hoge");
      },
      tooltip: "Debug",
      child: Icon(Icons.check),
    );
  }
}
