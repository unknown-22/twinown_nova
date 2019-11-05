import 'dart:convert';

import 'package:twinown_nova/resources/models/twinown_account.dart';

enum TabType {
  homeAutoRefresh, homeStream
}

class TwinownTab {
  TwinownTab(this.account, this.tabType, this.options);

  final TwinownAccount account;
  final TabType tabType;
  final Map<String, String> options;

  dynamic toJson() {
    return {
      'account': '${account.name}@${account.client.host}',
      'type': tabType.toString().split('.').last,
      'options': JsonEncoder.withIndent('  ').convert(options),
    };
  }

  static TabType stringToType(String tabString) {
    switch (tabString) {
      case 'homeAutoRefresh':
        return TabType.homeAutoRefresh;
      case 'homeStream':
        return TabType.homeStream;
    }
    throw 'unknown TabType $tabString';
  }

  static Map<String, String> stringToOptions(Map<String, dynamic> optionsString) {
    Map<String, String> returnValue = {};
    returnValue['streamDuration'] = '10';
    return returnValue;
  }
}
