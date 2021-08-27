import 'package:flutter/material.dart';
import 'package:signuplogin/screens/home.dart';
import 'package:signuplogin/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    home: UserChecker(),
  ));
}

class UserChecker extends StatefulWidget {
  const UserChecker({Key? key}) : super(key: key);

  @override
  State<UserChecker> createState() => _UserCheckerState();
}

class _UserCheckerState extends State<UserChecker> {
  @override
  void initState() {
    super.initState();
    checkForUser();
  }

  checkForUser() async {
    await _isUserLoggedIn()
        ? _navigateReplace(const Home())
        : _navigateReplace(const SignUp());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  _navigateReplace(pushClass) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => pushClass));
  }

  Future<bool> _isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool userStatus = prefs.getString('token') == null ? false : true;

    return userStatus;
  }
}
