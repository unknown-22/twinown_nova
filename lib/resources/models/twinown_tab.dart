import 'package:twinown_nova/resources/models/twinown_account.dart';

enum TabType {
  homeAutoRefresh,
}

class TwinownTab {
  TwinownTab(this.account, this.tabType, this.options);

  final TwinownAccount account;
  final TabType tabType;
  final Map<String, String> options;

  dynamic toJson() {
    return {
      'account': account.name,
      'type': tabType.toString().split('.').last,
      'options': ''
    };
  }

  static TabType stringToType(String tabString) {
    return TabType.homeAutoRefresh;
  }

  static Map<String, String> toOptions(Map<String, dynamic> optionsString) {
    Map<String, String> returnValue = {};
    returnValue['streamDuration'] = '10';
    return returnValue;
  }
}
