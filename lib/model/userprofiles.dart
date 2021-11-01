import 'dart:io';

class UserProfiles {
  final String? phoneNumber;
  final String? gender;
  final String? address;
  final String? state;
  final String? passport;

  UserProfiles({required this.phoneNumber, required this.gender, required this.address, required this.state, required this.passport});


  factory UserProfiles.fromJson(dynamic json){
    return UserProfiles(
      phoneNumber: json["phoneNumber"] as String? ?? '',
      gender: json["gender"] as String? ?? '',
      address: json['address'] as String? ?? '',
      state: json['state'] as String? ?? '',
      passport: json['passport'] as String? ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    data['gender'] = gender;
    data['address'] = address;
    data['state'] = state;
    data['passport'] = passport;
    return data;
  }
}


class UserProfilesRequestModel {
  final String? phoneNumber;
  final String? gender;
  final String? address;
  final String? state;
  final String passport;

  UserProfilesRequestModel({required this.phoneNumber, required this.gender, required this.address, required this.state, required this.passport});


  factory UserProfilesRequestModel.fromJson(dynamic json){
    return UserProfilesRequestModel(
      phoneNumber: json["phone_number"] as String? ?? '',
      gender: json["gender"] as String? ?? '',
      address: json['address'] as String? ?? '',
      state: json['state'] as String? ?? '',
      passport: json['passport'] as String    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone_number'] = phoneNumber;
    data['gender'] = gender;
    data['address'] = address;
    data['state'] = state;
    data['passport'] = passport;
    return data;
  }
}
