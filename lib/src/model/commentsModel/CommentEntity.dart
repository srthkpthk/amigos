import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amigos/src/model/commentsModel/comment_by.dart';

class CommentEntity {

  final String comment;
  final String commentId;
  final List<String> commentsLikeList;
  final String commentImage;
  final CommentBy commentBy;

	CommentEntity({
		this.comment,
		this.commentId,
		this.commentsLikeList,
		this.commentImage,
		this.commentBy});

	CommentEntity.fromDocument(DocumentSnapshot documentSnapshot): 
		comment = documentSnapshot.data["comment"],
		commentId = documentSnapshot.data["commentId"],
		commentsLikeList = List<String>.from(documentSnapshot.data["commentsLikeList"]),
		commentImage = documentSnapshot.data["commentImage"],
		commentBy = CommentBy.fromJsonMap(documentSnapshot.data["commentBy"]);

	Map<String, dynamic> toDocument() {
		final Map<String, dynamic> map = Map<String, dynamic>();
		map['comment'] = comment;
		map['commentId'] = commentId;
		map['commentsLikeList'] = commentsLikeList;
		map['commentImage'] = commentImage;
		map['commentBy'] = commentBy == null ? null : commentBy.toJson();
		return map;
	}
}
