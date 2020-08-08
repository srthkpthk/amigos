import 'package:random_color/random_color.dart';

class UserEntity {
  final String bio;
  final String dateOfBirth;
  final String email;
  final String fcmToken;
  final int followers;
  final int following;
  final List<String> followersList;
  final List<String> followingList;
  final String id;
  final bool isVerified;
  final String joinedOn;
  final String location;
  final String name;
  final String profileUrl;
  final String userName;

  UserEntity(
      this.bio,
      this.dateOfBirth,
      this.email,
      this.fcmToken,
      this.followers,
      this.following,
      this.followersList,
      this.followingList,
      this.id,
      this.isVerified,
      this.joinedOn,
      this.location,
      this.name,
      this.profileUrl,
      this.userName);

  UserEntity.fromJsonMap(Map<String, dynamic> map)
      : bio = map["bio"],
        dateOfBirth = map["dateOfBirth"],
        email = map["email"],
        fcmToken = map["fcmToken"],
        followers = map["followers"],
        following = map["following"],
        followersList = List<String>.from(map["followersList"]),
        followingList = List<String>.from(map["followingList"]),
        id = map["id"],
        isVerified = map["isVerified"],
        joinedOn = map["joinedOn"],
        location = map["location"],
        name = map["name"],
        profileUrl = map["profileUrl"],
        userName = map["userName"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bio'] = bio;
    data['dateOfBirth'] = dateOfBirth;
    data['email'] = email;
    data['fcmToken'] = fcmToken;
    data['followers'] = followers;
    data['following'] = following;
    data['followersList'] = followersList;
    data['followingList'] = followingList;
    data['id'] = id;
    data['isVerified'] = isVerified;
    data['joinedOn'] = joinedOn;
    data['location'] = location;
    data['name'] = name;
    data['profileUrl'] = profileUrl;
    data['userName'] = userName;
    return data;
  }
}
