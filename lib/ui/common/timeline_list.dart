import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twinown_nova/resources/api/mastodon.dart';
import 'package:twinown_nova/resources/models/twinown_account.dart';
import 'package:twinown_nova/resources/models/twinown_post.dart';
import 'package:twinown_nova/ui/common/post_view.dart';
import 'package:twinown_nova/ui/routes/timeline_route.dart';

class TimelineList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TimelineListState();
}

class TimelineListState extends State<TimelineList> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TimelineProvider>(context, listen: false);

    return AnimatedList(
      key: provider.listKey,
      initialItemCount: provider.data.length,
      itemBuilder: (context, index, animation) =>
          _buildItem(context, provider.data[index], animation),
    );
  }

  Widget _buildItem(
      BuildContext context, TwinownPost item, Animation animation) {
    var provider = Provider.of<TimelineProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        provider.removeItem(item, _buildItem, animation);
      },
      child: SizeTransition(
        sizeFactor: animation,
        child: Column(
          children: <Widget>[
            PostWidget(item: item),
            Divider(
              height: 1.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeUser();
  }

  Future<void> initializeUser() async {
    var provider = Provider.of<TimelineProvider>(context, listen: false);
    loadAccounts(provider.twinownSetting)
        .then((Map<String, TwinownAccount> accounts) {
      provider.account = accounts['unknown_Ex@unkworks.net'];
      provider.mastodonApi = MastodonApi(provider.account, provider.httpClient);
    });
  }
}
