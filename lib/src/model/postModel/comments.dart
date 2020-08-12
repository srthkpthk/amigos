import 'package:amigos/src/model/postModel/by.dart';
import 'package:amigos/src/model/postModel/replies.dart';

class Comments {
  final By by;
  final String comment;
  final List<String> commentLikeList;
  final List<Replies> replies;

  Comments(this.by, this.comment, this.commentLikeList, this.replies);

  Comments.fromJsonMap(Map<String, dynamic> map)
      : by = By.fromJsonMap(map["by"]),
        comment = map["comment"],
        commentLikeList = List<String>.from(map["commentLikeList"]),
        replies = List<Replies>.from(
            map["replies"].map((it) => Replies.fromJsonMap(it)));

  @override
  String toString() {
    return 'Comments{by: $by, comment: $comment, commentLikeList: $commentLikeList, replies: $replies}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['by'] = by == null ? null : by.toJson();
    data['comment'] = comment;
    data['commentLikeList'] = commentLikeList;
    data['replies'] =
        replies != null ? this.replies.map((v) => v.toJson()).toList() : null;
    return data;
  }
}
