import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:signuplogin/screens/login.dart';
import 'package:signuplogin/widgets/custom_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
              'Sign Up',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
            CustomField(
              title: 'Username',
              controller: username,
            ),
            CustomField(
              title: 'Password',
              controller: password,
              isPassword: true,
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
        'Register Now',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Login()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Center(
              child: Text(
                'Login',
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
