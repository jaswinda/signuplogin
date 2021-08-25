import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  bool isPassword;
  final validator;
  CustomField(
      {Key? key,
      required this.title,
      required this.controller,
      this.isPassword = false,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          TextFormField(
            controller: controller,
            obscureText: isPassword,
            decoration: const InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return title + ' cannot be left empty';
              }
              return validator(value);
            },
          )
        ],
      ),
    );
  }
}
