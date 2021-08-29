import 'dart:convert';
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
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(
                  height: 112,
                  color: color,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
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
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: allProducts(),
            ),
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
                                    onPressed: () {},
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
