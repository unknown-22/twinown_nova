import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:twinown_nova/blocs/twinown_setting.dart';
import 'package:twinown_nova/resources/models/twinown_account.dart';
import 'package:twinown_nova/resources/models/twinown_client.dart';

class MastodonApi {
  MastodonApi(this.account);

  final TwinownAccount account;

  Future<List<String>> getHome() async {
    // /api/v1/timelines/home
    Map<String, String> params = {};
    Map<String, String> headers = {'Authorization': 'Bearer ${account.authToken}'};

    var uri = Uri.https(
        account.client.host,
        '/api/v1/timelines/home',
        params
    );

    http.Response resp = await http.get(uri, headers: headers);
    if (resp.statusCode != 200) {
      throw Error();
    }
    List<dynamic> data = jsonDecode(resp.body);
    return List<String>.generate(
      data.length,
      (i) => '${data[i]['account']['display_name']} : ${data[i]['content']}'
    );
  }

  Future<Map<String, dynamic>> me(String authToken, String host) async {
    // /api/v1/accounts/verify_credentials
    Map<String, String> params = {};
    Map<String, String> headers = {'Authorization': 'Bearer $authToken'};

    var uri = Uri.https(
        host,
        '/api/v1/accounts/verify_credentials',
        params
    );

    http.Response resp = await http.get(uri, headers: headers);
    if (resp.statusCode != 200) {
      throw Error();
    }

    return jsonDecode(resp.body);
  }
}


Future<TwinownClient> createMastodonClient(String host, {String clientName = 'Twinown'}) async {
  var uri = Uri.https(host, '/api/v1/apps');
  Map<String, String> headers = {'content-type': 'application/json'};
  String body = json.encode({
    'client_name': clientName,
    'redirect_uris': 'urn:ietf:wg:oauth:2.0:oob',
    'scopes': 'write read follow',
  });

  http.Response resp = await http.post(uri, headers: headers, body: body);
  if (resp.statusCode != 200) {
    throw Error();
  }
  Map<String, dynamic> data = jsonDecode(resp.body);
  var client = TwinownClient(
      host,
      ClientType.mastodon,
      data['client_id'],
      data['client_secret']
  );
  return client;
}

void authorizeMastodon(TwinownClient client) {
  Map<String, String> params = {
    'response_type': 'code',
    'client_id': client.clientId,
    'client_secret': client.clientSecret,
    'redirect_uri': 'urn:ietf:wg:oauth:2.0:oob',
    'scope': 'write read follow', // push?
  };
  var uri = Uri.https(client.host, '/oauth/authorize', params);
  Process.run(
      'start', [uri.toString().replaceAll('&', '^&')], runInShell: true
  );
}

Future<TwinownAccount> tokenMastodon(TwinownClient client, String code) async {
  Map<String, String> headers = {'content-type': 'application/json'};
  String body = json.encode({
    'client_id': client.clientId,
    'client_secret': client.clientSecret,
    'grant_type': 'authorization_code',
    'code': code,
    'redirect_uri': 'urn:ietf:wg:oauth:2.0:oob',
  });

  var uri = Uri.https(client.host, '/oauth/token');
  http.Response resp = await http.post(uri.toString(), headers: headers, body: body);
  if (resp.statusCode != 200) {
    throw Error();
  }

  Map<String, dynamic> data = jsonDecode(resp.body);

  Map<String, dynamic> accounts = loadSetting(SettingType.accounts);

  TwinownAccount tempAccount = TwinownAccount(
    '',
    ClientType.mastodon,
    client,
    data['access_token'],
    accounts.length
  );

  var mastodonApi = MastodonApi(tempAccount);
  var me = await mastodonApi.me(tempAccount.authToken, client.host);

  return TwinownAccount(
    me['username'],
    ClientType.mastodon,
    client,
    data['access_token'],
    accounts.length
  );
}
