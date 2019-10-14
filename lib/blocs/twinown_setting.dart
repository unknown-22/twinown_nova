import 'dart:convert';
import 'dart:io';

import 'package:twinown_nova/resources/models/twinown_account.dart';
import 'package:twinown_nova/resources/models/twinown_client.dart';

enum SettingType {
  clients,
  accounts,
  tabs
}


Map<String, dynamic> loadSetting(SettingType settingType) {
  Map<String, String> envVars = Platform.environment;
  String home = '';
  if (Platform.isWindows) {
    home = envVars['UserProfile'];
  } else {
    throw Error();
  }

  Directory settingDirectory = Directory('$home/.twinown');
  String typeKey = settingType.toString().split('.')?.last;
  File twinownSettingFile = File(
      '${settingDirectory.path}/twinown_${typeKey}_setting.json'
  );

  return json.decode(twinownSettingFile.readAsStringSync());
}

void writeSetting(SettingType settingType, String data) {
  Map<String, String> envVars = Platform.environment;
  String home = '';
  if (Platform.isWindows) {
    home = envVars['UserProfile'];
  } else {
    throw Error();
  }

  Directory settingDirectory = Directory('$home/.twinown');
  String typeKey = settingType.toString().split('.')?.last;
  File twinownSettingFile = File(
      '${settingDirectory.path}/twinown_${typeKey}_setting.json'
  );

  twinownSettingFile.writeAsStringSync(data);
}

void addAccount(TwinownAccount account) {
  Map<String, dynamic> accounts = loadSetting(SettingType.accounts);
  accounts['${account.name}@${account.client.host}'] = account;
  var data = JsonEncoder.withIndent('  ').convert(accounts);
  writeSetting(SettingType.accounts, data);
}

void addClient(TwinownClient client) {
  Map<String, dynamic> clients = loadSetting(SettingType.clients);
  clients[client.host] = client;
  var data = JsonEncoder.withIndent('  ').convert(clients);
  writeSetting(SettingType.clients, data);
}
