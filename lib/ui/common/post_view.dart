import 'package:flutter/material.dart';
import 'package:twinown_nova/resources/models/twinown_post.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({Key key, this.item}) : super(key: key);

  final TwinownPost item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.network(
                  item.iconUri.toString(),
                ),
              ),
            ),
          ),
          // Divider(color: Colors.red, height: 10.0),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${item.displayName} : ${item.accountName}',
                          maxLines: 1,
                        ),
                      ),
                      // Spacer(),
                      Text(
                        item.createdAtLocalString(),
                        maxLines: 1,
                      ),
                    ],
                  ),
                  Text(item.prettyContent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
