import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/pages/cart/cart_model.dart';
import 'package:restaurant/pages/product/SingleProduct.dart';

class CartItems extends StatefulWidget {
  final SingleProduct product;

  const CartItems({
    required this.product,
  });
  @override
  State<CartItems> createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  void removeFromCart() {
    Provider.of<Restaurant>(context, listen: false)
        .removeFromCart(widget.product);
  }

  void refreshAmountValue(var cartProv) {
    cartProv = Provider.of<Restaurant>(context, listen: false).cart;
    Provider.of<Restaurant>(context, listen: false)
        .calculateItemsTotal(cartProv)
        .toStringAsFixed(2);

    Provider.of<Restaurant>(context, listen: false)
        .calculateTotal(cartProv)
        .toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        // padding: EdgeInsets.all(5),
        height: 110,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white30),
        child: Column(
          children: [
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        widget.product.pro_name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Al-Jazeera',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        ' ${(widget.product.pro_price * double.parse('${widget.product.quantity}'))}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Image(
                        image: AssetImage(
                          'assets/riyal.png',
                        ),
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // SizedBox(width: 5.0),
                            Container(
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (widget.product.quantity > 1) {
                                      widget.product.quantity--;
                                      refreshAmountValue(context);
                                    }
                                  });
                                },
                                icon: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.amber,
                                      // border: Border.all(color: Colors.red),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(
                                    Icons.remove,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '${widget.product.quantity}',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Al-Jazeera',
                                ),
                              ),
                            ),
                            Container(
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    widget.product.quantity++;
                                    refreshAmountValue(context);
                                  });
                                },
                                icon: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          size: 20,
                        ),
                        onPressed: removeFromCart,
                      ),
                    ],
                  ),
                ],
              ),
              leading: SizedBox(
                height: 80,
                width: 50,
                // padding: EdgeInsets.all(25),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.product.pro_image,
                    height: 50,
                    width: 50,
                    errorBuilder: (context, error, stackTrace) {
                      // Display a placeholder image or error message when the image fails to load
                      return const Icon(Icons.error_outline, color: Colors.red);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ); //end test contain
  }
}
