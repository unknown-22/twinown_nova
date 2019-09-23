import 'package:flutter/material.dart';

class DebugButton extends FloatingActionButton {
  DebugButton() : super(
      onPressed: _debugAction,
      tooltip: "Debug",
      child: Icon(Icons.check)
  );

  static void _debugAction() {
  }
}
