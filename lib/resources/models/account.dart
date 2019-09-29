import 'dart:convert';
import 'dart:io';

class Account {
  final String name;
  final String type;
  final String host;
  final String clientId;
  final String clientSecret;
  final String authToken;

  Account(
    this.name,
    this.type,
    this.host,
    this.clientId,
    this.clientSecret,
    this.authToken,
  );

  Account.fromJson(Map<String, dynamic> json) :
        name = json["name"],
        type = json["type"],
        host = json["host"],
        clientId = json["clientId"],
        clientSecret = json["clientSecret"],
        authToken = json["authToken"];

  Map<String, dynamic> toJson () =>
      {
        "name": name,
        "type": type,
        "host": host,
        "clientId": clientId,
        "clientSecret": clientSecret,
        "authToken": authToken,
      };
}


List<Account> getAccountsFromFile() {
  Map<String, String> envVars = Platform.environment;
  var home = "";
  if (Platform.isWindows) {
    home = envVars['UserProfile'];
  } else {
    // TODO なんらかのエラー
  }
  var settingDirectory = Directory("$home/.twinown");
  var accountSetting = File(
      "${settingDirectory.path}/accountSetting.json"
  );

  var data = accountSetting.readAsStringSync();
  List<dynamic> jsonArray = json.decode(data);
  return jsonArray.map((i) => Account.fromJson(i)).toList();
}
