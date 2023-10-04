import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../pages/cart/cart_model.dart';
import '../pages/cart/cart_page.dart';

Widget buildCartIconWithBadge(BuildContext context) {
  final Color Bcolor;
  var restaurantProvider = Provider.of<Restaurant>(context);
  int cartItemCount = restaurantProvider.cart.length;
  Bcolor = Color.fromRGBO(234, 30, 73, 1);
  return GestureDetector(
    onTap: () {
      // Show the cart dialog when the cart icon is tapped
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CartPage(
            // count: Count(),
            ),
      ));
    },
    child: Stack(
      children: [
        Icon(
          Icons.shopping_cart, // Replace this with your cart icon
          color: Color.fromARGB(255, 254, 170, 61),
          size: 30,
        ),
        if (cartItemCount >
            0) // Show the badge only when there are items in the cart
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Text(
                cartItemCount.toString(),
                style: TextStyle(
                  color: Bcolor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
