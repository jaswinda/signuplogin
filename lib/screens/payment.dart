import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:signuplogin/screens/home.dart';
import 'package:signuplogin/services/cart_service.dart';
import 'package:signuplogin/services/messages.dart';

class Payment extends StatefulWidget {
  final Map cartItems;
  final double totalToPay;
  const Payment({Key? key, required this.cartItems, required this.totalToPay})
      : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool loading = false;
  String selectedPaymentMethod = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          paymentOptions('assets/images/cod.png', 'Cash On Delivery', '1'),
          paymentOptions('assets/images/khalti.png', 'Khalti', '2'),
          paymentOptions('assets/images/mastercard.png', 'Master Card', '3'),
          if (selectedPaymentMethod != "")
            loading ? const CircularProgressIndicator() : proceedButton()
        ],
      ),
    );
  }

  Widget proceedButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shadowColor: Colors.black, primary: Colors.blue[900]),
          onPressed: onProceed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(child: Text('Proceed')),
            ],
          )),
    );
  }

  Widget paymentOptions(imageUrl, name, method) {
    return Center(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                selectedPaymentMethod = method;
              });
            },
            child: Container(
              color: method == selectedPaymentMethod
                  ? Colors.blue[900]
                  : Colors.amber[100],
              height: 150.0,
              width: 150.0,
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(imageUrl),
              )),
            ),
          ),
          Text(name)
        ],
      ),
    );
  }

  onProceed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    switch (selectedPaymentMethod) {
      case '1':
        Map data = {
          'token': preferences.getString('token'),
          'method': selectedPaymentMethod,
          'order_items': jsonEncode(widget.cartItems),
          'amount': widget.totalToPay.toString()
        };
        responseHandler(data);

        break;
      case '2':
        // print('khalti');
        Map data = {
          'token': preferences.getString('token'),
          'method': selectedPaymentMethod,
          'order_items': jsonEncode(widget.cartItems),
          'amount': widget.totalToPay.toString()
        };

        responseHandler(data);

        break;
      case '3':
        Map data = {
          'token': preferences.getString('token'),
          'method': selectedPaymentMethod,
          'order_items': jsonEncode(widget.cartItems),
          'amount': widget.totalToPay.toString()
        };
        responseHandler(data);

        break;
    }
  }

  responseHandler(data) async {
    changeLoadingState();

    final response = await CartService().order(data);

    if (response.statusCode == 200 && response != null) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (resposne['success']) {
        displayMessage(context, resposne['message'], true);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const Home();
        }));
      } else {
        displayMessage(context, resposne['message'], false);
      }
    } else {
      displayMessage(context, 'Something Went Wrong.', false);
    }
    changeLoadingState();
  }

  changeLoadingState() {
    setState(() {
      loading = !loading;
    });
  }

  myScakbar(message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
