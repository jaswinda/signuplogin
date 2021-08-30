import 'package:signuplogin/models/product.dart';

class CartItem extends Product {
  int orderQuantity;
  CartItem(
      {required productId,
      required image,
      required price,
      required despcription,
      required name,
      required this.orderQuantity})
      : super(
            id: productId,
            image: image,
            price: price,
            despcription: despcription,
            name: name);
}
