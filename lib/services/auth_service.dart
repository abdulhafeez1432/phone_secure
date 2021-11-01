import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:phone_secure/model/user.dart';
import 'package:phone_secure/services/sputils.dart';
import 'package:shared_preferences/shared_preferences.dart';

const BASE_URL = 'https://security.essentialpython.com.ng/api/api';

class AuthService {
  Future<String> login({
    required String username,
    required String password,
  }) async {
    try {
      final body = {
        'username': username,
        'password': password,
      };

      final response = await http.post(
        Uri.parse('$BASE_URL/login'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw LoginError.unexpected;
      }
      Map<String, dynamic> data = jsonDecode(response.body);
      User loggedInUser = User.fromJson(data['user']);
      String user = jsonEncode(loggedInUser);

      SPUtil.putString('user', user);
     // SPUtil.putInt('loggedId', loggedInUser.id!);
      //print(user);
      return jsonDecode(response.body)['token'];
    } on LoginError {
      print('login error');
      rethrow;
    } catch (e) {
      print(e);
      throw LoginError.unexpected;
    }
  }

  Future<User> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/register'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode != 200) {
        throw RegisterError.unexpected;
      }

      Map<String, dynamic> data = jsonDecode(response.body);

      //The token has not been used so remove this string
      String token = data['token'];
      User newUser = User.fromJson(data['user']);


      return newUser;
    } on RegisterError {
      rethrow;
    } catch (e) {
      throw RegisterError.unexpected;
    }
  }
}


savePref(int value, String name, String email, int id) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  preferences.setInt("value", value);
  preferences.setString("name", name);
  preferences.setString("email", email);
  preferences.setString("id", id.toString());
  preferences.commit();

}
enum LoginError { unexpected }
enum RegisterError { unexpected }
