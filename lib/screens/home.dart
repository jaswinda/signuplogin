import 'package:flutter/material.dart';
import 'package:signuplogin/services/authentication.dart';

import '../main.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.blue[50],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Image.asset('assets/images/logo.png',
                    width: 300, height: 100),
              ),
              ListTile(
                title: const Text('Sign Out'),
                onTap: () async {
                  await Authentication().logout();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const UserChecker()));
                },
              ),
            ],
          ),
        ),
      ),
      body: const Center(
        child: Text(
          "Welcome To Home Screen",
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
