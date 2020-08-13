import 'package:amigos/src/model/postModel/replies.dart';
import 'package:amigos/src/model/postModel/user.dart';

class Comments {

  final User by;
  final String comment;
  final List<String> commentLikeList;
  final int commentNumber;
  final List<Replies> replies;

	Comments(
		this.by,
		this.comment,
		this.commentLikeList,
		this.commentNumber,
		this.replies);

	Comments.fromJsonMap(Map<String,dynamic> map): 
		by = User.fromJsonMap(map["by"]),
		comment = map["comment"],
		commentLikeList = List<String>.from(map["commentLikeList"]),
		commentNumber = map["commentNumber"],
		replies = List<Replies>.from(map["replies"].map((it) => Replies.fromJsonMap(it)));

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> map = Map<String, dynamic>();
		map['by'] = by == null ? null : by.toJson();
		map['comment'] = comment;
		map['commentLikeList'] = commentLikeList;
		map['commentNumber'] = commentNumber;
		map['replies'] = replies != null ? 
			this.replies.map((v) => v.toJson()).toList()
			: null;
		return map;
	}
}
