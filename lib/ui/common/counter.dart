import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twinown_nova/ui/routes/timeline_route.dart';


class Counter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<TimelineProvider>(context);
    return Text(
      '${counter.count}',
      style: Theme.of(context).textTheme.display1,
    );
  }
}
