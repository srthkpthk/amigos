import 'package:amigos/src/model/postModel/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostEntity {
  final String id;
  final String postedAt;
  final String imagePath;
  final int flags;
  final String description;
  final List<String> likeList;
  final List<String> tags;
  final List<String> flaggedBy;
  final String userId;
  final User user;

  PostEntity(
      this.id,
      this.postedAt,
      this.imagePath,
      this.flags,
      this.description,
      this.likeList,
      this.tags,
      this.flaggedBy,
      this.userId,
      this.user);

  PostEntity.fromDocument(DocumentSnapshot documentSnapshot)
      : id = documentSnapshot.documentID,
        postedAt = documentSnapshot.data["postedAt"],
        imagePath = documentSnapshot.data["imagePath"],
        flags = documentSnapshot.data["flags"],
        description = documentSnapshot.data["description"],
        likeList = List<String>.from(documentSnapshot.data["likeList"]),
        tags = List<String>.from(documentSnapshot.data["tags"]),
        flaggedBy = List<String>.from(documentSnapshot.data["flaggedBy"]),
        userId = documentSnapshot.data["userId"],
        user = User.fromJsonMap(documentSnapshot.data["user"]);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postedAt'] = postedAt;
    data['imagePath'] = imagePath;
    data['flaggedBy'] = flaggedBy;
    data['description'] = description;
    data['likeList'] = likeList;
    data['tags'] = tags;
    data['flags'] = flags;
    data['userId'] = userId;
    data['user'] = user == null ? null : user.toJson();
    return data;
  }
}
