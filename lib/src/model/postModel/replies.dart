import 'package:amigos/src/model/postModel/by.dart';

class Replies {

  final By by;
  final String reply;
  final List<String> replyLikeList;

	Replies(this.by, this.reply, this.replyLikeList);

  Replies.fromJsonMap(Map<String, dynamic> map):
		by = By.fromJsonMap(map["by"]),
		reply = map["reply"],
		replyLikeList = List<String>.from(map["replyLikeList"]);

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['by'] = by == null ? null : by.toJson();
		data['reply'] = reply;
		data['replyLikeList'] = replyLikeList;
		return data;
	}
}
