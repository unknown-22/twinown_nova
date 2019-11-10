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
      onTap: () {
        showDialog<SimpleDialog>(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                children: _buildMenu(item, provider),
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
              );
            });
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

  List<Widget> _buildMenu(TwinownPost item, TimelineProvider provider) {
    List<Widget> menus = [
      Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PostWidget(item: item, isDetail: true,),
        ),
      ),
      InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: _optionView(item, Icons.reply, '返信する',
              Icons.keyboard_arrow_right),
        ),
      ),
      Divider(
        height: 1.0,
      ),
      InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: _optionView(item, Icons.cached, 'リツイート', null),
        ),
      ),
      Divider(
        height: 1.0,
      ),
      InkWell(
        onTap: () {
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: _optionView(item, Icons.star, 'お気に入りに追加する', null),
        ),
      ),
      Divider(
        height: 1.0,
      ),
      InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: _optionView(item, Icons.person, '${item.accountName}',
              Icons.keyboard_arrow_right),
        ),
      ),
      Divider(
        height: 1.0,
      ),
    ];
    return menus;
  }

  Widget _optionView(
      TwinownPost item, IconData lIcon, String text, IconData rIcon) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Icon(lIcon),
        ),
        Text(text),
        Spacer(),
        if (rIcon == null) Spacer() else Icon(rIcon)
      ],
    );
  }
}
