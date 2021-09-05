import 'package:flutter/material.dart';
import 'package:signuplogin/services/cart_service.dart';

class Payment extends StatefulWidget {
  final Map cartItems;
  const Payment({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
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
          if (selectedPaymentMethod != "") proceedButton()
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
    switch (selectedPaymentMethod) {
      case '1':
        print('cash on delivery');
        break;
      case '2':
        print('khalti');
        Map data = {
          'method': selectedPaymentMethod,
          'order_items': widget.cartItems,
        };
        final response = await CartService().order(data);
        print(response);
        break;
      case '3':
        print('master card');
        break;
    }
  }
}
