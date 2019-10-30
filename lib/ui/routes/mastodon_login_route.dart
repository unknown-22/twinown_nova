import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:twinown_nova/blocs/twinown_setting.dart';
import 'package:twinown_nova/resources/api/mastodon.dart';
import 'package:twinown_nova/resources/models/twinown_account.dart';
import 'package:twinown_nova/resources/models/twinown_client.dart';

class MastodonLoginProvider with ChangeNotifier {
  MastodonLoginProvider(this.twinownSetting, this.httpClient);

  final TwinownSetting twinownSetting;
  final Client httpClient;

  String hostText = '';
  String codeText = '';
  TwinownClient client;
  PageController controller;

  Future<void> prepareAuthorize() async {
    try {
      client = await loadClient(hostText, twinownSetting);
    } on ClientNotFoundError catch (_) {
      client = await MastodonApi.createMastodonClient(hostText,
          clientName: 'Twinwon');
      twinownSetting.addClient(client);
    }

    MastodonApi.authorizeMastodon(client);
    controller.animateToPage(1,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  Future<void> authorize(BuildContext context) async {
    TwinownAccount account = await MastodonApi.tokenMastodon(
        client, codeText, twinownSetting, httpClient);
    twinownSetting.addAccount(account);
    Navigator.pushReplacementNamed(context, '/timeline_route');
  }

  // TODO validate
  void updateHostText(String hostText) {
    // TODO fix for IME
    this.hostText = hostText;
  }

  // TODO validate
  void updateCodeText(String codeText) {
    // TODO fix for IME
    this.codeText = codeText;
    // this.codeText = 'vpwOnjRk_8mpxxfd_ZaBdFgFxGvaFi-HCF1fAPoV9rg';
  }
}

class HostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MastodonLoginProvider provider =
        Provider.of<MastodonLoginProvider>(context, listen: false);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Spacer(),
          Text('Please Enter Mastodon Host'),
          Padding(
            padding: EdgeInsets.only(top: 20, right: 30, left: 30),
            child: TextField(
              onChanged: (String text) => provider.updateHostText(text),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'exsample.com',
              ),
            ),
          ),
          Spacer(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () => provider.prepareAuthorize(),
      ),
    );
  }
}

class AuthorizationCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MastodonLoginProvider provider =
        Provider.of<MastodonLoginProvider>(context, listen: false);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Spacer(),
          Text('Please Enter Code'),
          Padding(
            padding: EdgeInsets.only(top: 20, right: 30, left: 30),
            child: TextField(
              onChanged: (String text) => provider.updateCodeText(text),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Authorization Code',
              ),
            ),
          ),
          Spacer(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: Icon(Icons.check),
        onPressed: () => provider.authorize(context),
      ),
    );
  }
}

class MastodonLoginPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PageController controller = PageController();
    MastodonLoginProvider provider =
        Provider.of<MastodonLoginProvider>(context, listen: false);
    provider.controller = controller;

    return PageView(
      controller: controller,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        HostPage(),
        AuthorizationCodePage(),
      ],
    );
  }
}

class MastodonLoginRoute extends StatefulWidget {
  const MastodonLoginRoute({Key key, this.twinownSetting, this.httpClient})
      : super(key: key);

  final TwinownSetting twinownSetting;
  final Client httpClient;

  @override
  State<StatefulWidget> createState() => MastodonLoginRouteState();
}

class MastodonLoginRouteState extends State<MastodonLoginRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              builder: (BuildContext context) => MastodonLoginProvider(
                  widget.twinownSetting, widget.httpClient))
        ],
        child: MastodonLoginPageView(),
      ),
    );
  }
}
