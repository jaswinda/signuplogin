import 'package:localstorage/localstorage.dart';

class CartService {
  final LocalStorage storage = new LocalStorage('items');
  addToCart(Map<String, dynamic> items) {
    storage.setItem("items", items);
  }

  Future<Map<String, dynamic>> getCartItems() async {
    print("before ready: " + storage.getItem("items").toString());

    //wait until ready
    await storage.ready;

    //this will now print 0
    print("after ready: " + storage.getItem("items").toString());
    return storage.getItem("items") ?? {};
  }
}
