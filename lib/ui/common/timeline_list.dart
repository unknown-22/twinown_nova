import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twinown_nova/resources/api/mastodon.dart';
import 'package:twinown_nova/resources/models/twinown_account.dart';
import 'package:twinown_nova/ui/routes/timeline_route.dart';


class TimelineList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TimelineProvider>(context, listen: false);
    var account = loadAccounts()['unknown_Ex@unkworks.net'];
    provider.account = account;
    provider.mastodonApi = MastodonApi(account);

    return AnimatedList(
      key: provider.listKey,
      initialItemCount: provider.data.length,
      itemBuilder: (context, index, animation) =>
          _buildItem(context, provider.data[index], animation),
    );
  }

  Widget _buildItem(BuildContext context, String item, Animation animation) {
    var provider = Provider.of<TimelineProvider>(context, listen: false);
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        title: Text(item),
        onTap: () => provider.removeItem(item, _buildItem, animation),
      ),
    );
  }
}
