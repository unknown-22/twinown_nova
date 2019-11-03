import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twinown_nova/resources/models/twinown_post.dart';
import 'package:twinown_nova/resources/models/twinown_tab.dart';
import 'package:twinown_nova/ui/common/post_view.dart';
import 'package:twinown_nova/ui/routes/timeline_route.dart';

class TimelineList extends StatefulWidget {
  const TimelineList({Key key, this.twinownTab, this.tabIndex})
      : super(key: key);

  final TwinownTab twinownTab;
  final int tabIndex;

  @override
  State<StatefulWidget> createState() => TimelineListState();
}

class TimelineListState extends State<TimelineList> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TimelineProvider>(context, listen: false);
    List<TwinownPost> posts = provider.dataList[widget.tabIndex];

    return AnimatedList(
      key: provider.listKeyList[widget.tabIndex],
      initialItemCount: posts.length,
      itemBuilder: (context, index, animation) =>
          _buildItem(context, posts[index], animation),
    );
  }

  Widget _buildItem(
      BuildContext context, TwinownPost item, Animation animation) {
    var provider = Provider.of<TimelineProvider>(context, listen: false);
    return InkWell(
      onTap: () =>
          provider.removeItem(widget.tabIndex, item, _buildItem, animation),
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
}
