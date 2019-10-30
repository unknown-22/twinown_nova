import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'app.dart';
import 'blocs/twinown_setting.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(
      TwinownApp(twinownSetting: TwinownSetting(), httpClient: Client()));
}
