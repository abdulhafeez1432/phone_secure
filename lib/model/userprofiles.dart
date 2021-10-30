class UserProfiles {
  final String? phoneNumber;
  final int? gender;
  final String? address;
  final int? state;

  UserProfiles({required this.phoneNumber, required this.gender, required this.address, required this.state});


  factory UserProfiles.fromJson(Map<String, dynamic> json){
    return UserProfiles(
      phoneNumber: json["phoneNumber"] as String,
      gender: json["gender"] as int,
      address: json['address'] as String? ?? '',
      state: json['state'] as int,
    );
  }
}
