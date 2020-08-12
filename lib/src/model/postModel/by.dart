class By {
  final String name;
  final bool isVerified;
  final String profileUrl;
  final String userName;
  final String userId;

  By(this.name, this.isVerified, this.profileUrl, this.userName, this.userId);

  @override
  String toString() {
    return 'By{name: $name, isVerified: $isVerified, profileUrl: $profileUrl, userName: $userName, userId: $userId}';
  }

  By.fromJsonMap(Map<String, dynamic> map)
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
