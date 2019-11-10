import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:twinown_nova/resources/models/twinown_account.dart';
import 'package:twinown_nova/resources/models/twinown_client.dart';
import 'package:twinown_nova/resources/models/twinown_tab.dart';

enum SettingType { clients, accounts, tabs }

class SettingFileNotFoundError extends Error {}

class TwinownSetting {
  Future<Map<String, TwinownClient>> loadClientMap() async {
    Map<String, dynamic> clientData = await loadSetting(SettingType.clients);
    assert(clientData.isNotEmpty);

    Map<String, TwinownClient> clients = {};
    for (var client in clientData.entries) {
      clients[client.key] = TwinownClient(
        client.key,
        client.value['type'] == 'mastodon'
            ? ClientType.mastodon
            : ClientType.twitter,
        client.value['clientId'],
        client.value['clientSecret'],
      );
    }
    return clients;
  }

  Future<Map<String, TwinownAccount>> loadAccountMap(
      Map<String, TwinownClient> clients) async {
    Map<String, dynamic> accountData = await loadSetting(SettingType.accounts);
    assert(accountData.isNotEmpty);

    Map<String, TwinownAccount> accounts = {};
    for (var account in accountData.entries) {
      accounts[account.key] = TwinownAccount(
          account.value['name'],
          ClientType.mastodon,
          clients[account.value['client']],
          account.value['authToken'],
          account.value['sort']);
    }
    return accounts;
  }

  Future<List<TwinownTab>> loadTabList(
      Map<String, TwinownAccount> accounts) async {
    List<dynamic> tabData = await loadSetting(SettingType.tabs);

    return List.generate(
        tabData.length,
        (i) => TwinownTab(
              accounts[tabData[i]['account']],
              TwinownTab.stringToType(tabData[i]['type']),
              {}, // TODO
              // TwinownTab.stringToOptions(tabData[i]['options']),
            ));
  }

  dynamic loadSetting(SettingType settingType) async {
    Directory settingDirectory = await _getSettingDirectory();
    String typeKey = settingType.toString().split('.').last;
    File twinownSettingFile =
        File('${settingDirectory.path}/twinown_${typeKey}_setting.json');

    if (!twinownSettingFile.existsSync()) {
      throw SettingFileNotFoundError();
    }

    return _getSettingData(twinownSettingFile);
  }

  Future<Directory> _getSettingDirectory() async {
    Directory settingDirectory;
    if (Platform.isWindows) {
      Map<String, String> envVars = Platform.environment;
      settingDirectory = Directory('${envVars['UserProfile']}/.twinown');
    } else if (Platform.isAndroid) {
      settingDirectory = await getApplicationDocumentsDirectory();
    } else {
      throw Error();
    }
    if (!settingDirectory.existsSync()) {
      settingDirectory.createSync();
    }
    return settingDirectory;
  }

  Future<dynamic> _getSettingData(File twinownSettingFile) async {
    return json.decode(await twinownSettingFile.readAsString());
  }

  Future<void> writeSetting(SettingType settingType, String data) async {
    Directory settingDirectory = await _getSettingDirectory();

    String typeKey = settingType.toString().split('.')?.last;
    File twinownSettingFile =
        File('${settingDirectory.path}/twinown_${typeKey}_setting.json');
    twinownSettingFile.writeAsStringSync(data);
  }

  Future<void> addAccount(TwinownAccount account) async {
    Map<String, dynamic> accounts;
    try {
      accounts = await loadSetting(SettingType.accounts);
    } on SettingFileNotFoundError catch (_) {
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
    } on SettingFileNotFoundError catch (_) {
      clients = <String, dynamic>{};
    }
    clients[client.host] = client;
    var data = JsonEncoder.withIndent('  ').convert(clients);
    writeSetting(SettingType.clients, data);
  }

  Future<void> addTab(TwinownTab tab) async {
    List<TwinownTab> tabs;
    try {
      tabs = await loadSetting(SettingType.tabs);
    } on SettingFileNotFoundError catch (_) {
      tabs = <TwinownTab>[];
    }
    tabs.add(tab);
    var data = JsonEncoder.withIndent('  ').convert(tabs);
    writeSetting(SettingType.tabs, data);
  }
}
