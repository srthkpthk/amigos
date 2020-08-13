import 'package:flutter/cupertino.dart';

class CommentBy {
  final String name;
  final bool isVerified;
  final String profileUrl;
  final String userName;
  final String userId;

  CommentBy(
      {@required this.name,
      @required this.isVerified,
      @required this.profileUrl,
      @required this.userName,
      @required this.userId});

  CommentBy.fromJsonMap(Map<String, dynamic> map)
      : name = map["name"],
        isVerified = map["isVerified"],
        profileUrl = map["profileUrl"],
        userName = map["userName"],
        userId = map["userId"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['name'] = name;
    map['isVerified'] = isVerified;
    map['profileUrl'] = profileUrl;
    map['userName'] = userName;
    map['userId'] = userId;
    return map;
  }
}
