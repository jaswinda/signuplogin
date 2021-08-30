import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:signuplogin/models/product.dart';
import 'package:signuplogin/services/authentication.dart';
import 'package:signuplogin/services/products.dart';
import 'package:signuplogin/widgets/product_tile.dart';
import '../main.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  int order_qnty = 1;
  double order_total = 0;
  List<Product> list = [];

  @override
  void initState() {
    super.initState();
    getAllProductsOnce();
  }

  getAllProductsOnce() async {
    list = await fetchAllProducts();
    setState(() {
      isLoading = false;
    });
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: allProducts(),
      ),
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: list.map((Product prduct) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    shadowColor: Colors.black,
                    elevation: 10,
                    child: Container(
                        color: Colors.blue[50],
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 80,
                                child: Image.network(
                                  prduct.image,
                                  fit: BoxFit.fitWidth,
                                )),
                            Text(
                              prduct.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(prduct.price.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold))
                          ],
                        )),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  _modalBottomSheetMenu(name, image, price) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder) {
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
                            name.toString().toUpperCase(),
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
                                backgroundImage: NetworkImage(image),
                              ),
                            ),
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
                                  onPressed: () {},
                                  icon: const Icon(Icons.remove),
                                ),
                                const Text(
                                  '1',
                                  style: TextStyle(
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
                                onPressed: () {},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        color: Colors.blue[50],
        child: Stack(
          fit: StackFit.expand,
          children: [
            buildFloatingSearchBar(),
          ],
        ),
      ),
    );
  }

  allProducts() {
    return !isLoading
        ? GridView.count(
            crossAxisCount: 2,
            children: list
                .map((prduct) => Stack(
                      children: [
                        ProductTile(
                            productName: prduct.name,
                            productImage: prduct.image,
                            productDesp: prduct.despcription,
                            productPrice: prduct.price),
                        Positioned(
                            right: 20,
                            top: 10,
                            child: CircleAvatar(
                                child: IconButton(
                                    onPressed: () {
                                      double price = double.parse(prduct.price);
                                      setState(() {
                                        order_qnty = 1;
                                        order_total = price * order_qnty;
                                      });
                                      _modalBottomSheetMenu(
                                          prduct.name, prduct.image, price);
                                    },
                                    icon: const Icon(Icons.shopping_cart))))
                      ],
                    ))
                .toList())
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  Future<List<Product>> fetchAllProducts() async {
    setState(() {
      isLoading = true;
    });
    List<Product> list = [];
    try {
      final response = await ProductsService().getProducts();
      if (response.statusCode == 200 && response != null) {
        Map<String, dynamic> _body = jsonDecode(response.body);
        if (_body['success']) {
          // List jsonResponse = json.decode(_body["data"]);
          List jsonResponse = _body["data"];
          list = jsonResponse.map((data) => Product.fromJson(data)).toList();
        }
        myScakbar(_body["message"]);
      }
    } catch (e) {
      myScakbar("Something went wrong.");
    }

    return list;
  }

  myScakbar(message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
