class UserDetails {
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? lastLogin;

  UserDetails(
      {this.id,
        this.username,
        this.email,
        this.firstName,
        this.lastName,
        this.lastLogin});


  factory UserDetails.fromJson(dynamic json){
    return UserDetails(
        id: json["id"],
        email: json["email"],
        username: json["username"],
        firstName: json['firstName'],
        lastName: json['lastName'],
      lastLogin: json['lastLogin'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['username'] = username;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['lastLogin'] = lastLogin;
    return data;
  }
}
