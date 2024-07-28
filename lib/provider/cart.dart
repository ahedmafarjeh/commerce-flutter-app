import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/item.dart';

class Cart with ChangeNotifier {
  List<Item> consumerCart = [];
  int price = 0;
  addProduct(Item product) {
    consumerCart.add(product);
    price += product.price.round();
    notifyListeners(); // such as setStart , so it refresh the page to see the effects
  }

  deleteProduct(Item product) {
    consumerCart.remove(product);
    price -= product.price.round();
    notifyListeners();
  }

  get itemCount {
    return consumerCart.length;
  }
}
