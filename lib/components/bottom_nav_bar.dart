import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/pages/Favorite/Favorite.dart';
import 'package:restaurant/pages/cart/cart_page.dart';
import '../pages/home/home.dart';
import '../pages/manage_account.dart/home_mannage.dart';
import '../pages/product/category_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final GlobalKey<ScaffoldState> _keyDrawer = GlobalKey<ScaffoldState>();
  int _currentIndex = 2;

  final List<Widget> _pages = [
    CategoryPage(),
    CartPage(),
    const Home(),
    FavoritePage(currentUser: FirebaseAuth.instance.currentUser!),
    const AcountSettings(),

    // Add your other pages here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyDrawer,
      endDrawer: BottomNavBar(), // Define your MyDrawer() widget
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        backgroundColor: Colors.white,
        color: const Color.fromARGB(255, 254, 170, 61),
        buttonBackgroundColor: const Color.fromRGBO(234, 30, 73, 1),
        height: 50.0,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.hot_tub, size: 30, color: Colors.white),
          Icon(Icons.shopping_bag_outlined, size: 30, color: Colors.white),
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.favorite, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
          // Add your other bottom navigation items here
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
