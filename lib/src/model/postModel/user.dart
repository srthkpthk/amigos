class User {
  final String name;
  final bool isVerified;
  final String profileUrl;
  final String userName;
  final String userId;

  User(this.name, this.isVerified, this.profileUrl, this.userName, this.userId);

  User.fromJsonMap(Map<String, dynamic> map)
      : name = map["name"],
        isVerified = map["isVerified"],
        profileUrl = map["profileUrl"],
        userName = map["userName"],
        userId = map["userId"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['isVerified'] = isVerified;
    data['profileUrl'] = profileUrl;
    data['userName'] = userName;
    data['userId'] = userId;
    return data;
  }
}
