
class User {

  final String name;
  final bool isVerified;
  final String profileUrl;
  final String userName;
  final String userId;

	User(
		this.name,
		this.isVerified,
		this.profileUrl,
		this.userName,
		this.userId);

	User.fromJsonMap(Map<String,dynamic> map): 
		name = map["name"],
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
