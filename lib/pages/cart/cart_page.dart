// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/pages/cart/cart_items.dart';
import 'package:restaurant/pages/cart/cart_model.dart';
import 'package:restaurant/pages/cart/checkout_page.dart';
import 'package:restaurant/pages/product/SingleProduct.dart';
import 'cart_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
    //  required this.count
  });
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double deliveryFee = 500.00;
  void refreshPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
            // count: Count(),
            ),
      ),
    );
  }

  double deliveryFeeValue() {
    var cartProv = Provider.of<Restaurant>(context, listen: false).cart;
    if (cartProv.length >= 1) {
      return 500.0;
    } else {
      return 0.0;
    }
  }

  TextStyle textStyle = const TextStyle(
    fontSize: 14,
    fontFamily: 'Al-Jazeera',
    color: Colors.black,
  );
  @override
  Widget build(BuildContext context) {
    var restaurantProvider =
        Provider.of<Restaurant>(context); // Get the restaurant provider
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(234, 30, 73, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
                onPressed: () {
                  Provider.of<Restaurant>(context, listen: false)
                      .clearCart(deliveryFee);
                },
                child: const Icon(
                  Icons.delete_outline,
                  size: 30,
                  color: Colors.white,
                )),
            const Text(
              "طلاباتي",
              style: TextStyle(
                fontFamily: 'Al-Jazeera',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Container(
          margin: const EdgeInsets.only(top: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Provider.of<Restaurant>(context).cart.isEmpty
                    ? Center(
                        child: Container(
                          height: 300,
                          width: 300,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/empty_cart.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: Provider.of<Restaurant>(context).cart.length,
                        itemBuilder: (context, index) {
                          // get individual shoe
                          SingleProduct individualShoe =
                              Provider.of<Restaurant>(context).cart[index];
                          // return the cart item

                          return CartItems(
                            product: individualShoe,
                          );
                        },
                      ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'المجموع',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Al-Jazeera',
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'الإجمالي',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Al-Jazeera',
                                ),
                              ),
                              Text(_calculateItemsTotal(restaurantProvider.cart)
                                  .toStringAsFixed(
                                      2)), // Display items total]],
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'رسوم التوصيل',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Al-Jazeera',
                                ),
                              ),
                              Text(deliveryFeeValue().toString()),

                              // Text("$deliveryFee".toString()),
                            ],
                          ),
                          Divider(
                            color: Color.fromRGBO(234, 30, 73, 1),
                            thickness: 1.2,
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'المجموع الكلي',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Al-Jazeera',
                                ),
                              ),
                              Text(
                                _calculateTotal(restaurantProvider.cart)
                                    .toStringAsFixed(2)
                                    .toString(), // Display total
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Al-Jazeera',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        right: 25,
                        left: 25,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: MaterialButton(
                        onPressed: () async {
                          Future<bool> checkRestaurantStatus() async {
                            // Get the current time
                            DateTime now = DateTime.now();

                            // Get the current hour and minute
                            int currentHour = now.hour;
                            int currentMinute = now.minute;

                            // Define the restaurant's opening and closing times
                            int openingHour =
                                10; // Example opening hour (in 24-hour format)
                            int openingMinute = 0; // Example opening minute
                            int closingHour =
                                20; // Example closing hour (in 24-hour format)
                            int closingMinute = 0; // Example closing minute

                            // Compare the current time with the opening and closing times
                            if ((currentHour > openingHour ||
                                    (currentHour == openingHour &&
                                        currentMinute >= openingMinute)) &&
                                (currentHour < closingHour ||
                                    (currentHour == closingHour &&
                                        currentMinute < closingMinute))) {
                              // The restaurant is open
                              return true;
                            } else {
                              // The restaurant is closed
                              return false;
                            }
                          }

                          // Check if the restaurant is open
                          bool isRestaurantOpen = await checkRestaurantStatus();
                          var cartProv =
                              Provider.of<Restaurant>(context, listen: false)
                                  .cart;

                          if (isRestaurantOpen) {
                            List<SingleProduct> cartItems =
                                Provider.of<Restaurant>(context, listen: false)
                                    .cart;
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => CheckoutPage(
                                      cartItems: cartItems,
                                      // updateDeliveryFee: _updateDeliveryFee,
                                      calculateTotal: _calculateTotal,
                                      currentUser:
                                          FirebaseAuth.instance.currentUser!,
                                    ));
                          } else {
                            // Show an AlertDialog indicating that the restaurant is closed

                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(
                                  "المطعم مغلق",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Al-Jazeera',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                                content: const Text(
                                  "عذرًا، المطعم مغلق في الوقت الحالي.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Al-Jazeera',
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Center(
                                      child: const Text(
                                        "حسنًا",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Al-Jazeera',
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (cartProv.isEmpty) {
                            Navigator.pop(context);
                            return showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(
                                  "السلة فارغة",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Al-Jazeera',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                                content: const Text(
                                  "قم بإضافة طلبك لمواصلة العملية",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Al-Jazeera',
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Center(
                                      child: const Text(
                                        "حسنًا",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Al-Jazeera',
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'إدفع قيمة مشترياتك',
                          style: TextStyle(
                            fontFamily: 'Al-Jazeera',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        color: const Color.fromRGBO(234, 30, 73, 1),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  double _calculateItemsTotal(List<SingleProduct> cart) {
    double total = 0;
    for (var item in cart) {
      total += item.pro_price * item.quantity;
    }
    return total;
  }

  double _calculateTotal(List<SingleProduct> cart) {
    double itemsTotal = _calculateItemsTotal(cart);
    double deliveryFee = deliveryFeeValue();
    double total = itemsTotal + deliveryFee;
    return total;
  }
}
