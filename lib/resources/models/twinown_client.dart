import 'package:twinown_nova/blocs/twinown_setting.dart';

enum ClientType {
  twitter,
  mastodon,
}

class TwinownClient {
  TwinownClient(
    this.host,
    this.clientType,
    this.clientId,
    this.clientSecret,
  );

  final String host;
  final ClientType clientType;
  final String clientId;
  final String clientSecret;

  dynamic toJson() {
    return {
      'type': clientType.toString().split('.').last,
      'clientId': clientId,
      'clientSecret': clientSecret,
    };
  }
}

class ClientNotFoundError extends Error {}

TwinownClient loadClient(String host) {
  dynamic clientData = loadSetting(SettingType.clients)[host];

  if (clientData == null) {
    throw ClientNotFoundError();
  }

  ClientType clientType;
  if (clientData['type'] == 'mastodon') {
    clientType = ClientType.mastodon;
  } else {
    throw Error();
  }

  return TwinownClient(
      host, clientType, clientData['clientId'], clientData['clientSecret']
  );
}
