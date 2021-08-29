import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:signuplogin/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsService {
  getProducts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Map data = {
      'token': preferences.getString('token'),
    };
    final response = await http.post(Uri.parse(productsApi),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    return response;
  }
}
