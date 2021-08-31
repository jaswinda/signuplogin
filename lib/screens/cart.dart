import 'package:flutter/material.dart';
import 'package:signuplogin/services/cart_service.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  Map<String, dynamic> cartItems = {};
  @override
  void initState() {
    super.initState();
    getCartItemsFromLocalStorage();
  }

  getCartItemsFromLocalStorage() async {
    cartItems = await CartService().getCartItems();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: cartItems.values.map((item) => cartItem(item)).toList(),
        ),
      ),
    );
  }

  Widget cartItem(item) {
    double price = double.parse(item["price"].toString());
    double total = price * double.parse(item["orderQuantity"].toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.blue[50],
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(item["image"]),
                  ),
                ),
                Text(item["price"].toString()),
                const Text(' X '),
                Text(
                  item["orderQuantity"].toString(),
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const Text(' = '),
                Text(
                  total.toString(),
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
