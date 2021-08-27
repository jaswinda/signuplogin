import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:signuplogin/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  signUp(data) async {
    final response = await http.post(Uri.parse(signupApi),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    return response;
  }

  login(data) async {
    try {
      final response = await http.post(Uri.parse(loginApi),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      return response;
    } catch (e) {
      return null;
    }
  }

  saveUserToLocal(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  logout() async {
    await logoutFromServer();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  logoutFromServer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Map data = {
      'token': preferences.getString('token'),
    };
    try {
      final response = await http.post(Uri.parse(logoutApi),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      return response;
    } catch (e) {
      return null;
    }
  }
}
