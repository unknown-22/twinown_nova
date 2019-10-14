import 'package:twinown_nova/blocs/twinown_setting.dart';
import 'package:twinown_nova/resources/models/twinown_client.dart';

class TwinownAccount {
  TwinownAccount(
      this.name,
      this.clientType,
      this.client,
      this.authToken,
      this.sortKey
  );

  final String name;
  final ClientType clientType;
  final TwinownClient client;
  final String authToken;
  final int sortKey;



  dynamic toJson() =>
    {
      'name': name,
      'client': client.host,
      'authToken': authToken,
      'sort': sortKey,
    };
}

Map<String, TwinownAccount> loadAccounts() {
  var accountData = loadSetting(SettingType.accounts);

  if (accountData.isEmpty) {
    throw Error();
  }

  return accountData.map((key, dynamic value) => MapEntry(key, TwinownAccount(
        value['name'],
        ClientType.mastodon,
        loadClient(value['client']),
        value['authToken'],
        value['sort']
    )));
}
