import 'package:amigos/src/model/postModel/comments.dart';
import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final Comments _comment;

  Comment(this._comment);

  @override
  Widget build(BuildContext context) {
    return Text(_comment.comment);
  }
}
