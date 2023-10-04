import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurant/pages/product/SingleProduct.dart';

class Restaurant extends ChangeNotifier {
  final List<SingleProduct> _userCart = [];
  final List<SingleProduct> _favorites = [];
  // final Count count;
  final List<SingleProduct> _shop = [];

  List<SingleProduct> get cart => _userCart;
  List<SingleProduct> get shop => _shop;
  List<SingleProduct> get favorites => _favorites;

  Map<String, int> _productQuantities = {};

  List<SingleProduct> getUserCart() {
    return _userCart;
  }

  void addToCart(SingleProduct product) {
    _userCart.add(product);

    // Check if the product is already in the cart
    if (_productQuantities.containsKey(product.pro_id)) {
      _productQuantities[product.pro_id]! +
          1; // Increment the quantity if it exists
    } else {
      _productQuantities[product.pro_id] =
          1; // Set initial quantity to 1 if it's a new product
    }

    product.quantity = _productQuantities[
        product.pro_id]!; // Update the quantity in the SingleProduct instance
    notifyListeners();
  }

  void removeFromCart(SingleProduct product) {
    _userCart.remove(product);

    // Check if the product is in the cart
    if (_productQuantities.containsKey(product.pro_id)) {
      int currentQuantity = _productQuantities[product.pro_id]!;
      if (currentQuantity > 1) {
        _productQuantities[product.pro_id] =
            currentQuantity - 1; // Decrement the quantity if it's more than 1
      } else {
        _productQuantities.remove(product
            .pro_id); // Remove the product quantity from the map if it's 1
      }
    }

    if (_productQuantities.containsKey(product.pro_id)) {
      product.quantity = _productQuantities[
          product.pro_id]!; // Update the quantity in the SingleProduct instance
    } else {
      product.quantity =
          0; // Set quantity to 0 if the product is completely removed from the cart
    }

    notifyListeners();
  }

  void clearCart(double deliveryFee) {
    _userCart.clear();
    _productQuantities.clear();
    for (SingleProduct product in _shop) {
      product.quantity = 0;
    }
    deliveryFee = 0.0;

    notifyListeners();
  }

  void toggleFavorite(SingleProduct product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  double deliveryFeeValue() {
    notifyListeners();
    if (cart.length >= 1) {
      return 500.0;
    } else {
      return 0.0;
    }
  }

  double calculateTotal(List<SingleProduct> cart) {
    double itemsTotal = calculateItemsTotal(cart);
    double deliveryFee = deliveryFeeValue();
    double total = itemsTotal + deliveryFee;
    notifyListeners();
    return total;
  }

  double calculateItemsTotal(List<SingleProduct> cart) {
    double total = 0;
    for (var item in cart) {
      total += item.pro_price * item.quantity;
    }
    notifyListeners();
    return total;
  }
}
