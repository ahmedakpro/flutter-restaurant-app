import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/pages/product/categories.dart';
import '../../components/Badge.dart';
import '../Favorite/Favorite.dart';
import '../cart/cart_model.dart';
import 'SingleProduct.dart';

class ProductDetail extends StatefulWidget {
  // final String productId;
  final FavoriteHandler favoriteHandler;
  final SingleProduct product;
  final Category category;
  final bool isFavorite;
  const ProductDetail({
    Key? key,
    required this.product,
    required this.category,
    required this.favoriteHandler,
    required this.isFavorite,
  }) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  SingleProduct? product; // Declare a SingleProduct instance
  void addItemToCart() {
    Provider.of<Restaurant>(context, listen: false).addToCart(widget.product);
  }

  final GlobalKey<ScaffoldState> _keyDrawer = GlobalKey<ScaffoldState>();

  bool loadingCategory = false;
  List<Map<String, dynamic>> products = [];

  // Function to fetch products of a specific category from Firestore
  Future<void> fetchProducts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('cat_id', isEqualTo: widget.category.cat_id)
        .get();

    setState(() {
      products = List<Map<String, dynamic>>.from(
          querySnapshot.docs.map((doc) => doc.data()).toList());
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch products data for the selected category when the widget is initialized
    fetchProducts();
    checkFavoriteStatus();
  }

  bool isFavorite = false;

  void checkFavoriteStatus() async {
    bool isProductFavorite = await widget.favoriteHandler.isFavorite(
        FirebaseAuth.instance.currentUser!.uid, widget.product.pro_id);

    setState(() {
      isFavorite = isProductFavorite;
    });
  }

  final Color myHexColor = Color.fromARGB(255, 254, 170, 61);
  @override
  Widget build(BuildContext context) {
    SingleProduct product = widget.product;
    Category category = widget.category;

    return Scaffold(
      backgroundColor: Color.fromRGBO(234, 30, 73, 1),
      body: Container(
        padding: const EdgeInsets.only(top: 33),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(right: 25, left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 254, 170, 61)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_outlined,
                            color: Color.fromARGB(255, 254, 170, 61),
                          ),
                        ),
                      ),
                      // Add the Cart icon with the Badge here
                      buildCartIconWithBadge(context),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Flexible(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image:
                      product.pro_image != null && product.pro_image.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(product.pro_image),
                              fit: BoxFit.cover,
                            )
                          : null,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 254, 170, 61),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                product.pro_name,
                                style: const TextStyle(
                                  fontFamily: 'Al-Jazeera',
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromRGBO(234, 30, 73, 1),
                                ),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                product.pro_description,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: 'Al-Jazeera',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                                children: List.generate(5, (index) {
                              return const Icon(
                                Icons.star,
                                color: Colors.red,
                                size: 22,
                              );
                            })),
                            Row(
                              children: [
                                const Image(
                                  image: AssetImage(
                                    'assets/riyal.png',
                                  ),
                                  height: 20,
                                  width: 20,
                                ),
                                Text(
                                  '${product.pro_price.toDouble()}',
                                  style: const TextStyle(
                                      fontFamily: 'Al-Jazeera',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 254, 170, 61),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    checkFavoriteStatus();
                                    setState(() {
                                      isFavorite = !isFavorite;
                                    });
                                    if (isFavorite) {
                                      widget.favoriteHandler.addFavoriteItem(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        widget.product.pro_id,
                                        widget.product.pro_name,
                                        widget.product.pro_image,
                                        widget.product.pro_price.toDouble(),
                                      );
                                    } else {
                                      widget.favoriteHandler.removeFavoriteItem(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        widget.product.pro_id,
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                        isFavorite ? Colors.red : Colors.white,
                                  ),
                                ),
                                Image.network(
                                  category.cat_image,
                                  height: 50,
                                  width: 50,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Display a placeholder image or error message when the image fails to load
                                    return const Icon(Icons.error_outline,
                                        color: Colors.red);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.shopping_cart_checkout,
                                  ),
                                  onPressed: () {
                                    addItemToCart();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
