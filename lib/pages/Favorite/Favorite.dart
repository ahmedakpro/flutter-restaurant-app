import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/pages/google_maps/index.dart';
import 'package:restaurant/pages/product/SingleProduct.dart';

import '../cart/cart_model.dart';
import '../product/product_detail.dart';

class FavoritePage extends StatefulWidget {
  final User currentUser;

  const FavoritePage({super.key, required this.currentUser});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late FavoriteHandler _favoriteHandler;
  List<String> _favoriteProductIds = [];
  Map<String, dynamic> _favoriteProducts = {};
  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    _favoriteHandler = FavoriteHandler(widget.currentUser);
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _favoriteProductIds =
        await _favoriteHandler.getFavoriteItems(widget.currentUser.uid);

    for (String productId in _favoriteProductIds) {
      final productData = await _favoriteHandler.getFavoriteProduct(
          widget.currentUser.uid, productId);
      print('Product Data for $productId: $productData');
      if (productData != null) {
        setState(() {
          _favoriteProducts[productId] = productData;
        });
      }
    }
  }

  void checkFavoriteStatus() async {
    List<String> favoriteItems =
        await _favoriteHandler.getFavoriteItems(widget.currentUser.uid);
    setState(() {
      isFavorite = favoriteItems.contains(favoriteItems);
    });
  }

  TextStyle boldTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Al-Jazeera',
    color: Colors.black,
  );
  @override
  Widget build(BuildContext context) {
    Color primeryColor = Color.fromRGBO(234, 30, 73, 1);

    SingleProduct product;

    void addItemToCart(SingleProduct product) {
      Provider.of<Restaurant>(context, listen: false).addToCart(product);
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primeryColor,
          title: Text(
            'المفضلة',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Al-Jazeera',
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // You can adjust the number of columns here
            ),
            itemCount: _favoriteProductIds.length,
            itemBuilder: (context, index) {
              final productId = _favoriteProductIds[index];
              final productData = _favoriteProducts[productId];

              final proImage = productData['pro_image'] as String? ?? '';
              final proName = productData['pro_name'] as String? ?? '';
              final proPrice = productData['pro_price'];

              return GestureDetector(
                onTap: () {},
                child: Card(
                  child: Container(
                    // padding: EdgeInsets.only(right: 5, top: 10),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            if (productData != null &&
                                productData.containsKey('pro_image'))
                              Image.network(
                                productData['pro_image'],
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return CircularProgressIndicator(); // Show a CircularProgressIndicator while the image is loading
                                  }
                                },
                              )
                            else
                              Icon(Icons
                                  .error), // Display an error icon if 'pro_image' is missing or null
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 5, left: 5, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                proName,
                                style: boldTextStyle,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '$proPrice',
                                    style: const TextStyle(
                                      fontFamily: 'Al-Jazeera',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Image(
                                    image: AssetImage(
                                      'assets/riyal.png',
                                    ),
                                    height: 18,
                                    width: 18,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                  isFavorite
                                      ? Icons.favorite_border
                                      : Icons.favorite,
                                  color:
                                      isFavorite ? primeryColor : primeryColor),
                              onPressed: () {
                                checkFavoriteStatus();
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                                if (isFavorite) {
                                  _favoriteHandler.removeFavoriteItem(
                                      widget.currentUser.uid, productId);
                                }
                                _loadFavorites();
                              },
                            ),

                            // add to
                            IconButton(
                              icon: const Icon(Icons.shopping_cart_checkout,
                                  color: Color.fromARGB(255, 218, 25, 0)),
                              onPressed: () {
                                // Add your shopping cart logic here
                                // addItemToCart(wi.product.pro_id);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GoogleMapIndex()));
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class FavoriteHandler {
  final User currentUser;

  FavoriteHandler(this.currentUser);

  Future<List<String>> getFavoriteItems(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .collection('favorite')
          .get();

      final productIds = snapshot.docs.map((doc) => doc.id).toList();
      return productIds;
    } catch (error) {
      print('Error fetching favorite items: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> getFavoriteProduct(
      String userId, String productId) async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .collection('favorite')
          .doc(productId)
          .get();

      if (productSnapshot.exists) {
        return productSnapshot.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (error) {
      print('Error fetching favorite product: $error');
      return {};
    }
  }

  Future<void> addFavoriteItem(String userId, String pro_id, String pro_name,
      String pro_image, double pro_price) async {
    try {
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .collection("favorite")
          .doc(pro_id)
          .set({
        'pro_id': pro_id,
        'pro_name': pro_name,
        'pro_image': pro_image,
        'pro_price': pro_price.toDouble(),
      });
    } catch (error) {
      print('Error adding favorite: $error');
      throw Exception('Failed to add favorite item.');
    }
  }

  Future<void> removeFavoriteItem(String userId, String pro_id) async {
    try {
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .collection('favorite')
          .doc(pro_id)
          .delete();
    } catch (error) {
      print('Error removing favorite: $error');
      throw Exception('Failed to remove favorite item.');
    }
  }

  Future<bool> isFavorite(String userId, String pro_id) async {
    try {
      final DocumentSnapshot favoriteSnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .collection('favorite')
          .doc(pro_id)
          .get();

      return favoriteSnapshot.exists;
    } catch (error) {
      print('Error checking favorite: $error');
      return false;
    }
  }
}
