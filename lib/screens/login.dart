import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:signuplogin/services/authentication.dart';
import 'package:signuplogin/widgets/custom_field.dart';

import '../main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            _title(),
            const Text(
              'Login',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
            CustomField(
              title: 'Username',
              controller: username,
              validator: (value) {
                return null;
              },
            ),
            CustomField(
              title: 'Password',
              controller: password,
              isPassword: true,
              validator: (value) {
                return null;
              },
            ),
            isLoading
                ? const CircularProgressIndicator()
                : InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        login(username.text, password.text);
                      }
                    },
                    child: _submitButton()),
            _loginAccountLabel()
          ]),
        ),
      ),
    );
  }

  login(email, password) async {
    Map data = {
      'email': email,
      'password': password,
    };
    changeLoadingState();
    final response = await Authentication().login(data);

    if (response.statusCode == 200 && response != null) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (resposne['success']) {
        Map<String, dynamic> user = resposne;

        await Authentication().saveUserToLocal(resposne['token']);

        myScakbar(resposne['message'] + " " + user["email"]);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const UserChecker()));
      } else {
        myScakbar(resposne['message']);
      }
    } else {
      myScakbar('Something Went Wrong!');
    }
    changeLoadingState();
  }

  changeLoadingState() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  myScakbar(message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(children: [
        TextSpan(
          text: 'Everest',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        TextSpan(
          text: 'Technology',
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
      ]),
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: const Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.black, Colors.blue])),
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              "Doesn't have an account ?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Center(
              child: Text(
                'Sign Up',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
