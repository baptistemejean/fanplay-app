class User {
  String username;
  //String profilePic;

  User({required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(username: json['username']);
  }
}
