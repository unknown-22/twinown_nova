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

Future<Map<String, TwinownAccount>> loadAccounts() async {
  Map<String, dynamic> accountData = await loadSetting(SettingType.accounts);

  if (accountData.isEmpty) {
    throw Error();
  }

  Map<String, TwinownAccount> accounts = {};
  for (var account in accountData.entries) {
    accounts[account.key] = TwinownAccount(
        account.value['name'],
        ClientType.mastodon,
        await loadClient(account.value['client']),
        account.value['authToken'],
        account.value['sort']
    );
  }
  return accounts;
}
