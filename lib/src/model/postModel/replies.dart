import 'package:amigos/src/model/postModel/user.dart';

class Replies {

  final User by;
  final String reply;
  final int replyNumber;
  final List<String> replyLikeList;

	Replies(
		this.by,
		this.reply,
		this.replyNumber,
		this.replyLikeList);

	Replies.fromJsonMap(Map<String,dynamic> map): 
		by = User.fromJsonMap(map["by"]),
		reply = map["reply"],
		replyNumber = map["replyNumber"],
		replyLikeList = List<String>.from(map["replyLikeList"]);

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> map = Map<String, dynamic>();
		map['by'] = by == null ? null : by.toJson();
		map['reply'] = reply;
		map['replyNumber'] = replyNumber;
		map['replyLikeList'] = replyLikeList;
		return map;
	}
}
