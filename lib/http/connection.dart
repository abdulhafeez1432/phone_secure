import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:phone_secure/model/phonedetails.dart';
import 'package:phone_secure/model/userprofiles.dart';
import 'package:phone_secure/services/sputils.dart';


const BASE_URL = 'https://security.essentialpython.com.ng/api/api';

Future<List<PhoneDetail>> getPhone() async {
  if (SPUtil.getString("token").isEmpty) {
    throw Exception('Login to get your favorite news');
  }

  final response = await http.get(
    Uri.parse('$BASE_URL/listuserphones'),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json;charset=UTF-8',
      'Authorization': "TOKEN ${SPUtil.getString("token")}",

    },
  );


  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // store json data into list
    var list = json.decode(response.body) as List;

    // iterate over the list and map each object in list to Img by calling Img.fromJson
    List<PhoneDetail> listOfPhones =
    list.map((i) => PhoneDetail.fromJson(i)).toList();

    return listOfPhones;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Phone');
  }
}


Future<UserProfiles> getUserProfile() async {

  var url = Uri.parse('$BASE_URL/profiledetail');

  final response = await http.get(url,
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json;charset=UTF-8',
      'Authorization': "TOKEN ${SPUtil.getString("token")}",

    },

  );

  print("get User Details=${json.encode(response.body)} ");

  if (response.statusCode == 200) {

      print("News User response Details site=${response.body}");
      return UserProfiles.fromJson(jsonDecode(response.body));

      //return json.decode(response.body);

  } else {
      throw Exception('Failed to load Site');
    }
}


//Future<UserProfiles> updateProfile(String phoneNumber, int gender,  String address, int state, int id) async {
Future<UserProfiles> updateProfile(String address, String id) async {
  print("token= ${SPUtil.getString("token")}");
  final response = await http.put(

    Uri.parse('$BASE_URL/profiledetail/$id'),
    headers: <String, String>{
      "Accept": "application/json",
      'Content-Type': 'application/json;charset=UTF-8',
      'Authorization': "TOKEN ${SPUtil.getString("token")}"
    },
    body: jsonEncode(<String, String>{"address": address}),
  );
  if (response.statusCode == 201) {
    //print(response.body);
    //return Author.fromJson(json.decode(response.body));
    return UserProfiles.fromJson(jsonDecode(response.body));
    print("added to profile=${response.body}");
    //return Future.value(true);
  } else {
    throw Exception("Can't load author");
  }
}

