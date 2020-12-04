import 'package:amigos/src/model/commentsModel/comment_by.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CommentEntity {
  final String comment;
  final String commentId;
  final List<String> commentsLikeList;
  final String commentImage;
  final CommentBy commentBy;

  CommentEntity(
      {@required this.comment,
      @required this.commentsLikeList,
      @required this.commentImage,
      @required this.commentBy,
      this.commentId});

  CommentEntity.fromDocument(DocumentSnapshot documentSnapshot)
      : comment = documentSnapshot.data()["comment"],
        commentId = documentSnapshot.data()["commentId"],
        commentsLikeList =
            List<String>.from(documentSnapshot.data()["commentsLikeList"]),
        commentImage = documentSnapshot.data()["commentImage"],
        commentBy = CommentBy.fromJsonMap(documentSnapshot.data()["commentBy"]);

  Map<String, dynamic> toDocument() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['comment'] = comment;
    map['commentsLikeList'] = commentsLikeList;
    map['commentImage'] = commentImage;
    map['commentBy'] = commentBy == null ? null : commentBy.toJson();
    return map;
  }
}
