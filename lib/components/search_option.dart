import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/Favorite/Favorite.dart';
import '../pages/home/home.dart';
import '../pages/product/categories.dart';
import '../pages/product/SingleProduct.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> products = [];
  SingleProduct? product;
  List<String> _favoriteProductIds = [];

  @override
  Widget build(BuildContext context) {
    final SingleProduct product;
    final Category category;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: TextField(
            onChanged: (query) {
              _performSearch(query);
            },
            style: TextStyle(
              fontFamily: 'Al-Jazeera',
            ),
            decoration: InputDecoration(
              hintText: 'إبحث...',
              hintStyle: TextStyle(
                fontFamily: 'Al-Jazeera',
                fontSize: 16, // You can adjust the font size as needed
              ),
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            final product = SingleProduct(
              // Count(),
              pro_id: _searchResults[index]["pro_id"]!,
              pro_image: _searchResults[index]["pro_image"]!,
              pro_name: _searchResults[index]["pro_name"]!,
              pro_description: _searchResults[index]["pro_description"]!,
              pro_price: _searchResults[index]["pro_price"],
              cat_id: _searchResults[index]["cat_id"]!,
              quantity: 0,
            );

            return SingleProductWidget(
              product: product,
              category: Category(
                cat_id: _searchResults[index]["cat_id"],
                cat_image:
                    "cat_image", // You need to provide the cat_image here
                cat_name: "cat_name", // You need to provide the cat_name here
              ),
              favoriteHandler:
                  FavoriteHandler(FirebaseAuth.instance.currentUser!),
              isFavorite: _favoriteProductIds.contains(product.pro_id),
            );
          },
        ),
      ),
    );
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('pro_name', isGreaterThanOrEqualTo: query)
        .where('pro_name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    setState(() {
      _searchResults = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
