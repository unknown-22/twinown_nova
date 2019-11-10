import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:twinown_nova/resources/models/twinown_post.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({Key key, this.item, this.isDetail = false})
      : super(key: key);

  final TwinownPost item;
  final bool isDetail;

  Widget _iconWidget(String urlString) {
    if (Platform.isWindows) {
      return Image.network(urlString);
    } else {
      return CachedNetworkImage(imageUrl: urlString);
    }
  }

  Widget _nameWidget(
      BuildContext context, String displayName, String accountName) {
    if (isDetail) {
      return Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$displayName',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                '@$accountName',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.display1.color,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      );
    } else {
      return Flexible(
        flex: 1,
        child: Row(
          children: <Widget>[
            Flexible(
              child: Text(
                displayName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: 4.0,
            ),
            Flexible(
              child: Text(
                '@$accountName',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.display1.color,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 2.0, right: 2.0),
            child: SizedBox(
              width: 48.0,
              height: 48.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                // child: CachedNetworkImage(imageUrl: item.iconUri.toString(),),
                // child: Image(image: CachedNetworkImageProvider(item.iconUri.toString())),
                child: _iconWidget(
                  item.iconUri.toString(),
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0, right: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _nameWidget(context, item.displayName, item.accountName),
                      Text(
                        item.createdAtLocalString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.display1.color,
                        ),
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
