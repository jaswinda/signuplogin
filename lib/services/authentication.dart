import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:signuplogin/services/api.dart';

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
}
