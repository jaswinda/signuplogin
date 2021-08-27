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
    final response = await http.post(Uri.parse(loginApi),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    return response;
  }

  saveUserToLocal(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
