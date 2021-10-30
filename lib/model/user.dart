// we have two cases here the first is the user we register and the second the user we get from the api
// when we register a user we will not have his id and we need to provide a password to make the registration that is why we have user.register
// when we get the user from the api we will have his id but we don't have a password for that case i use the default constructor, if you want you can change to user.login or something like
// the fromJson and toJson are just helpers to handle the conversions between the app and the api json
class User {
  int? id;
  String username;
  String email;
  String? password;
  String? first_name;
  String? last_name;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.last_name,
    required this.first_name
  }) : password = null;

  User.register({
    required this.username,
    required this.password,
    required this.email,
    required this.first_name,
    required this.last_name
  }) : this.id = null;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      first_name: json['first_name'],
      last_name: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'first_name': first_name,
      'last_name': last_name,
    };
  }
}
