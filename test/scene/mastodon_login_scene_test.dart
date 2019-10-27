import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'first launch test with mastodon login', (WidgetTester tester) async {
        var tempSettingDirectory = Directory.systemTemp.createTempSync('twinown_nova_test');
        debugPrint(tempSettingDirectory.toString());
  });
}
