import 'package:flutter/material.dart';
import 'package:signuplogin/widgets/custom_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
            InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {}
                },
                child: _submitButton()),
            _loginAccountLabel()
          ]),
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
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
