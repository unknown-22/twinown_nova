import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class MastodonApi {
  String clientId;
  String clientSecret;

  MastodonApi(this.clientId, this.clientSecret);

  void authorize() async {
    Map<String, String> params = {
      'response_type': 'code',
      'client_id': clientId,
      'client_secret': clientSecret,
      'redirect_uri': 'urn:ietf:wg:oauth:2.0:oob',
      'scope': 'write read follow', // push?
    };

    var uri = Uri.https(
        'unkworks.net', '/oauth/authorize', params
    );
    debugPrint(uri.toString());
    http.Response resp = await http.get(uri);
    if (resp.statusCode != 200) {
      debugPrint("Failed to post ${resp.statusCode}");
      debugPrint(resp.body);
      return;
    }

    // TODO
  }

  void token() async {
    String url = "https://unkworks.net/oauth/token";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({
      'client_id': clientId,
      'client_secret': clientSecret,
      'grant_type': 'authorization_code',
      'code': '', // TODO ?
      'redirect_uri': 'urn:ietf:wg:oauth:2.0:oob',
    });

    http.Response resp = await http.post(url, headers: headers, body: body);
    if (resp.statusCode != 200) {
      debugPrint("Failed to post ${resp.statusCode}");
      debugPrint(resp.body);
      return;
    }
  }


  void createClient() async {
    String url = "https://unkworks.net/api/v1/apps";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({
      'client_name': 'Twinown',  // TODO 渡せるようにしてもいい？
      'redirect_uris': 'urn:ietf:wg:oauth:2.0:oob',
      'scopes': 'write read follow', // push?
    });

    http.Response resp = await http.post(url, headers: headers, body: body);
    if (resp.statusCode != 200) {
      debugPrint("Failed to post ${resp.statusCode}");
      debugPrint(resp.body);
      return;
    }
    debugPrint(resp.body);
  }

  Future<List<String>> getHome(String authToken) async {
    // /api/v1/timelines/home
    Map<String, String> params = {};
    Map<String, String> headers = {
      'Authorization': 'Bearer $authToken',
    };

    var uri = Uri.https(
        'unkworks.net',
        '/api/v1/timelines/home',
        params
    );

    http.Response resp = await http.get(uri, headers: headers);
    if (resp.statusCode != 200) {
      debugPrint("Failed to post ${resp.statusCode}");
      debugPrint(resp.body);
      return [];
    }
    List<dynamic> data = jsonDecode(resp.body);
    return List<String>.generate(
      data.length,
      (i) => '${data[i]['account']['display_name']} : ${data[i]['content']}'
    );
  }
}
