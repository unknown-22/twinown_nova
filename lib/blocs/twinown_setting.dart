import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:twinown_nova/resources/models/twinown_account.dart';
import 'package:twinown_nova/resources/models/twinown_client.dart';

enum SettingType {
  clients,
  accounts,
  tabs
}

class SettingFileNotFoundError extends Error {}

Future<Map<String, dynamic>> loadSetting(SettingType settingType) async {
  Map<String, String> envVars = Platform.environment;
  Directory settingDirectory;
  if (Platform.isWindows) {
    settingDirectory = Directory('${envVars['UserProfile']}/.twinown');
    if (!settingDirectory.existsSync()) {
      settingDirectory.createSync();
    }
  } else if (Platform.isAndroid) {
    settingDirectory = await getApplicationDocumentsDirectory();
  }
  else {
    throw Error();
  }

  String typeKey = settingType.toString().split('.').last;
  File twinownSettingFile = File(
      '${settingDirectory.path}/twinown_${typeKey}_setting.json'
  );

  if (!twinownSettingFile.existsSync()) {
    throw SettingFileNotFoundError();
  }

  return json.decode(twinownSettingFile.readAsStringSync());
}

Future<void> writeSetting(SettingType settingType, String data) async {
  Map<String, String> envVars = Platform.environment;
  Directory settingDirectory;
  if (Platform.isWindows) {
    settingDirectory = Directory('${envVars['UserProfile']}/.twinown');
    if (!settingDirectory.existsSync()) {
      settingDirectory.createSync();
    }
  } else if (Platform.isAndroid) {
    settingDirectory = await getApplicationDocumentsDirectory();
  } else {
    throw Error();
  }

  String typeKey = settingType.toString().split('.')?.last;
  File twinownSettingFile = File(
      '${settingDirectory.path}/twinown_${typeKey}_setting.json'
  );

  twinownSettingFile.writeAsStringSync(data);
}

Future<void> addAccount(TwinownAccount account) async {
  Map<String, dynamic> accounts;
  try {
    accounts = await loadSetting(SettingType.accounts);
  } on SettingFileNotFoundError catch(_) {
    accounts = <String, dynamic>{};
  }
  accounts['${account.name}@${account.client.host}'] = account;
  var data = JsonEncoder.withIndent('  ').convert(accounts);
  writeSetting(SettingType.accounts, data);
}

Future<void> addClient(TwinownClient client) async {
  Map<String, dynamic> clients;
  try {
    clients = await loadSetting(SettingType.clients);
  } on SettingFileNotFoundError catch(_) {
    clients = <String, dynamic>{};
  }
  clients[client.host] = client;
  var data = JsonEncoder.withIndent('  ').convert(clients);
  writeSetting(SettingType.clients, data);
}
