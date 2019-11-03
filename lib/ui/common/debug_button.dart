import 'package:flutter/material.dart';

class DebugButton extends StatelessWidget {
  @override
  Widget build(context) {
    return FloatingActionButton(
      onPressed: () async {
        // Debug Action
      },
      tooltip: 'Debug',
      child: Icon(Icons.check),
    );
  }
}
