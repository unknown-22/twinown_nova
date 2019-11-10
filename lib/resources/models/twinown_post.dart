import 'package:intl/intl.dart';

class TwinownPost {
  TwinownPost(this.id, this.accountName, this.displayName, this.iconUri,
      this.content, this.createdAt);

  final String id;
  final String accountName;
  final String displayName;
  final Uri iconUri;
  final String content;
  final DateTime createdAt;

  DateTime get createdAtLocal => createdAt.toLocal();

  String get prettyContent => content
      .replaceAll(RegExp('<br />'), '\n')
      .replaceAll(RegExp('<(".*?"|\'.*?\'|[^\'"])*?>'), '');

  String createdAtLocalString() {
    var nowDateTime = DateTime.now().toLocal();
    if (createdAtLocal.year == nowDateTime.year &&
        createdAtLocal.month == nowDateTime.month &&
        createdAtLocal.day == nowDateTime.day) {
      return DateFormat('HH:mm:ss').format(createdAtLocal);
    } else {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAtLocal);
    }
  }
}
