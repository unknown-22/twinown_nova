import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client, Response;
import 'package:twinown_nova/blocs/twinown_setting.dart';
import 'package:twinown_nova/resources/models/twinown_account.dart';
import 'package:twinown_nova/resources/models/twinown_client.dart';
import 'package:twinown_nova/resources/models/twinown_post.dart';

class MastodonApi {
  MastodonApi(this.account, this.httpClient);

  final TwinownAccount account;
  final Client httpClient;

  Future<List<TwinownPost>> getHome() async {
    // /api/v1/timelines/home
    Map<String, String> params = {};
    Map<String, String> headers = {
      'Authorization': 'Bearer ${account.authToken}'
    };

    var uri = Uri.https(account.client.host, '/api/v1/timelines/home', params);

    Response resp = await httpClient.get(uri, headers: headers);
    if (resp.statusCode != 200) {
      throw Error();
    }
    List<dynamic> data = jsonDecode(resp.body);
    return List<TwinownPost>.generate(data.length, (i) {
      return TwinownPost(
        "${account.name}@${account.client.host}_${data[i]['id']}",
        "${data[i]['account']['acct']}",
        "${data[i]['account']['display_name']}",
        Uri.parse("${data[i]['account']['avatar']}"),
        "${data[i]['content']}",
        DateTime.parse("${data[i]['created_at']}"),
      );
    });
  }

  Future<Map<String, dynamic>> me(String authToken, String host) async {
    // /api/v1/accounts/verify_credentials
    Map<String, String> params = {};
    Map<String, String> headers = {'Authorization': 'Bearer $authToken'};

    var uri = Uri.https(host, '/api/v1/accounts/verify_credentials', params);

    Response resp = await httpClient.get(uri, headers: headers);
    if (resp.statusCode != 200) {
      throw Error();
    }

    return jsonDecode(resp.body);
  }

  static Future<TwinownClient> createMastodonClient(String host, Client httpClient,
      {String clientName = 'Twinown'}) async {
    var uri = Uri.https(host, '/api/v1/apps');
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({
      'client_name': clientName,
      'redirect_uris': 'urn:ietf:wg:oauth:2.0:oob',
      'scopes': 'write read follow',
    });

    Response resp = await httpClient.post(uri, headers: headers, body: body);
    if (resp.statusCode != 200) {
      throw Error();
    }
    Map<String, dynamic> data = jsonDecode(resp.body);
    var client = TwinownClient(
        host, ClientType.mastodon, data['client_id'], data['client_secret']);
    return client;
  }

  static void authorizeMastodon(TwinownClient client) {
    Map<String, String> params = {
      'response_type': 'code',
      'client_id': client.clientId,
      'client_secret': client.clientSecret,
      'redirect_uri': 'urn:ietf:wg:oauth:2.0:oob',
      'scope': 'write read follow', // push?
    };
    var uri = Uri.https(client.host, '/oauth/authorize', params);
    Process.run('start', [uri.toString().replaceAll('&', '^&')],
        runInShell: true);
  }

  static Future<TwinownAccount> tokenMastodon(
      TwinownClient client, String code, TwinownSetting twinownSetting, Client httpClient) async {
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({
      'client_id': client.clientId,
      'client_secret': client.clientSecret,
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': 'urn:ietf:wg:oauth:2.0:oob',
    });

    var uri = Uri.https(client.host, '/oauth/token');
    Response resp = await httpClient.post(uri.toString(), headers: headers, body: body);
    if (resp.statusCode != 200) {
      throw Error();
    }

    Map<String, dynamic> data = jsonDecode(resp.body);

    Map<String, dynamic> accounts;
    try {
      accounts = await twinownSetting.loadSetting(SettingType.accounts);
    } on SettingFileNotFoundError catch (_) {
      accounts = <String, dynamic>{};
    }

    TwinownAccount tempAccount = TwinownAccount(
        '', ClientType.mastodon, client, data['access_token'], accounts.length);

    var mastodonApi = MastodonApi(tempAccount, httpClient);
    var me = await mastodonApi.me(tempAccount.authToken, client.host);

    return TwinownAccount(me['username'], ClientType.mastodon, client,
        data['access_token'], accounts.length);
  }
}
