import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Favorite/Favorite.dart';
import '../home/home.dart';
import 'categories.dart';
import 'SingleProduct.dart';

class CategoryProductsScreen extends StatefulWidget {
  final Category category;
  const CategoryProductsScreen({required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final GlobalKey<ScaffoldState> _keyDrawer = GlobalKey<ScaffoldState>();
  bool loadingCategory = false;
  List<Map<String, dynamic>> products = [];
  List<String> _favoriteProductIds = [];

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
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 25, left: 25, top: 33),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.category.cat_name,
                    style: const TextStyle(
                      fontFamily: 'Al-Jazeera',
                      color: Color.fromRGBO(234, 30, 73, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  Image.network(
                    widget.category.cat_image,
                    height: 50,
                    width: 50,
                    errorBuilder: (context, error, stackTrace) {
                      // Display a placeholder image or error message when the image fails to load
                      return const Icon(Icons.error_outline, color: Colors.red);
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color.fromRGBO(234, 30, 73, 1),
                      size: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where('cat_id', isEqualTo: widget.category.cat_id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Extract the products from the snapshot
                    List<Map<String, dynamic>> products =
                        snapshot.data!.docs.map((doc) => doc.data()).toList();

                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final SingleProduct product = SingleProduct(
                          // Count(),
                          pro_id: products[index]["pro_id"]!,
                          pro_image: products[index]["pro_image"]!,
                          pro_name: products[index]["pro_name"]!,
                          pro_description: products[index]["pro_description"]!,
                          pro_price: products[index]["pro_price"],
                          cat_id: products[index]["cat_id"]!,
                          quantity: 0,
                        );
                        return SingleProductWidget(
                          product: product,
                          category: widget.category,
                          favoriteHandler: FavoriteHandler(
                              FirebaseAuth.instance.currentUser!),
                          isFavorite:
                              _favoriteProductIds.contains(product.pro_id),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error fetching data'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
