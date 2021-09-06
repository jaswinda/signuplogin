import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:signuplogin/screens/payment.dart';
import 'package:signuplogin/services/cart_service.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  double total = 0.0;
  Map<String, dynamic> cartItems = {};
  @override
  void initState() {
    super.initState();
    getCartItemsFromLocalStorage();
  }

  getCartItemsFromLocalStorage() async {
    cartItems = await CartService().getCartItems();
    updateTotal();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.blue[800],
      ),
      body: cartItems.length == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No Items In the Cart",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Continue Shopping"))
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext c) {
                          return Payment(
                            cartItems: cartItems,
                            totalToPay: total,
                          );
                        }));
                      },
                      child: checkoutButton()),
                  Column(
                    children: cartItems.values
                        .map((item) => mySlideable(item))
                        .toList(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget checkoutButton() {
    return Card(
      color: Colors.blue[900],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Total: ' + total.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                ),
              ],
            ),
            Row(
              children: const [
                Text(
                  'Checkout',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void updateTotal() async {
    total = 0.0;
    cartItems.forEach((key, value) {
      total += (double.parse(cartItems[key]["price"]) *
          double.parse(cartItems[key]["orderQuantity"].toString()));
    });
  }

  Widget mySlideable(item) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: cartItem(item),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Archive',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () => {},
        ),
        IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () => {},
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.black45,
          icon: Icons.edit,
          onTap: () => {_modalBottomSheetMenu(item)},
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => {removeItemFromCart(item["productId"])},
        ),
      ],
    );
  }

  removeItemFromCart(productId) {
    setState(() {
      cartItems.remove(productId);
    });
    updateTotal();
  }

  _modalBottomSheetMenu(product) {
    int order_qnty = product["orderQuantity"];
    double price = double.parse(product["price"]);
    double order_total = price * order_qnty;
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder) {
          // to change the data
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 350.0,
              color:
                  Colors.transparent, //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Text(
                            product["name"].toString().toUpperCase(),
                            style: const TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(product["image"]),
                              ),
                            ),
                            Text(product["price"]),
                            const Text(' X '),
                            Text(order_qnty.toString()),
                            const Text(' = '),
                            Text(
                              order_total.toString(),
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Container(
                          color: Colors.grey[200],
                          height: 50,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (order_qnty != 1) {
                                      setState(() {
                                        order_qnty -= 1;
                                        order_total = price * order_qnty;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                                Text(
                                  order_qnty.toString(),
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      order_qnty += 1;
                                      order_total = price * order_qnty;
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  addProductToCart(product, order_qnty);
                                  Navigator.pop(context);
                                },
                                child: const Text('Add To Card')),
                          ],
                        )
                      ],
                    ),
                  )),
            );
          });
        });
  }

  addProductToCart(product, order_qnty) {
    setState(() {
      cartItems[product["productId"]] = {
        'productId': product["productId"],
        'image': product["image"],
        'price': product["price"],
        'despcription': product["despcription"],
        'name': product["name"],
        'orderQuantity': order_qnty
      };
      CartService().addToCart(cartItems);
      updateTotal();
      // CartService().addToCart(cartItems);
    });
  }

  Widget cartItem(item) {
    double price = double.parse(item["price"].toString());
    double total = price * double.parse(item["orderQuantity"].toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.blue[100],
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
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
