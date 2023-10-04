import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/pages/account/login.dart';
import 'package:restaurant/pages/home/resturant_hour.dart';
import 'package:share/share.dart';
import '../../components/Badge.dart';
import '../../components/search_option.dart';
import '../../drop_down/help.dart';
import '../../drop_down/settings.dart';
import '../Favorite/Favorite.dart';
import '../cart/cart_model.dart';
import '../manage_account.dart/home_mannage.dart';
import '../product/categories.dart';
import 'package:restaurant/pages/product/product_detail.dart';
import '../product/SingleProduct.dart';
import '../product/subcategory.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _keyDrawer = GlobalKey<ScaffoldState>();
  bool loadingCategory = false;
  List<Map<String, dynamic>> myarr_product = [];
  List<Map<String, dynamic>> myarr_category = [];
  List<String> _favoriteProductIds = [];

  // Function to fetch categories from Firestore
  Future<void> fetchCategories() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();

    setState(() {
      myarr_category = List<Map<String, dynamic>>.from(
          querySnapshot.docs.map((doc) => doc.data()).toList());
    });
  }

  // Function to fetch products from Firestore
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();

    return List<Map<String, dynamic>>.from(
        querySnapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<String> getProductsCollectionId() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('products');
    String collectionId = collectionRef.id;

    return collectionId;
  }

  @override
  void initState() {
    super.initState();
    // Fetch categories and products data when the widget is initialized
    fetchCategories();
    fetchProducts().then(
      (products) {
        setState(() {
          myarr_product = products;
        });
      },
    );
  }

  bool isSearchVisible = false;
  bool isSearchPageVisible = false;
  bool showloginpage = true;
  final String logInRote = '/logIn';

  Future<void> checkEmailInDatabase(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      // User is not logged in, navigate to login screen
      Navigator.pushReplacementNamed(
          context, logInRote); // Replace with your login route
    }
  }

  void togglePages() {
    setState(() {
      showloginpage = !showloginpage;
    });
  }

  TextStyle textStyle = const TextStyle(
    fontSize: 14,
    fontFamily: 'Al-Jazeera',
    color: Colors.black,
  );
  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            builder: (context) => LoginPage(onTap: togglePages));
      },
      home: Scaffold(
        backgroundColor: Color.fromRGBO(234, 30, 73, 1),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            // right: 30,
                            // left: 30,
                            top: 33,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  buildCartIconWithBadge(context),

                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AcountSettings()),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.person_pin,
                                      size: 30,
                                    ),
                                  ),
                                  const Text(
                                    " مطعم عبود",
                                    style: TextStyle(
                                      fontFamily: 'Al-Jazeera',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),

                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchPage()),
                                        );
                                      },
                                      icon: Icon(Icons.search)),

                                  //dropDown list
                                  PopupMenuButton<String>(
                                    offset: Offset(0,
                                        40), // Adjust the vertical offset as needed
                                    onSelected: (value) {
                                      if (value == "الإعدادات") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SettingsPage()),
                                        );
                                      } else if (value == "مشاركة التطبيق") {
                                        void shareApp(BuildContext context) {
                                          String text =
                                              'Check out this awesome app!';
                                          String url =
                                              'http://market.android.com/details?id=com.example.restaurant';

                                          String shareText = '\n$url';

                                          try {
                                            Share.share(shareText);
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content:
                                                      Text('Sharing failed')),
                                            );
                                          }
                                        }
                                      } else if (value == "مساعدة") {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              HelpPage(),
                                        );
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: "الإعدادات",
                                        child:
                                            Text("الإعدادات", style: textStyle),
                                      ),
                                      PopupMenuItem<String>(
                                        value: "مشاركة التطبيق",
                                        child: Text("مشاركة التطبيق",
                                            style: textStyle),
                                      ),
                                      PopupMenuItem<String>(
                                        value: "مساعدة",
                                        child: Text("مساعدة", style: textStyle),
                                      ),
                                    ],
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.menu_open_sharp,
                                        size: 30,
                                      ),
                                      onPressed:
                                          null, // IconButton requires an onPressed callback, but we set it to null
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: const Text(
                                      " ألذ  المأكولات الشهية بإنتظارك..",
                                      style: TextStyle(
                                        fontFamily: 'Al-Jazeera',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                  RestaurantHoursWidget(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (isSearchPageVisible)
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(right: 15.0),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 254, 170, 61),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "بحث",
                                    hintStyle: TextStyle(
                                        fontFamily: 'Al-Jazeera',
                                        color: Colors.black,
                                        fontSize: 14),
                                    suffixIcon: Icon(Icons.search),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          // width: MediaQuery.of(context).size.width,
                          height: 60.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: myarr_category.length,
                            itemBuilder: (context, index) {
                              final category = Category(
                                cat_id: myarr_category[index]["cat_id"]!,
                                cat_image: myarr_category[index]["cat_image"]!,
                                cat_name: myarr_category[index]["cat_name"]!,
                              );
                              return SingleCategoryWidget(category: category);
                            },
                          ),
                        ),
                        // const Divider(
                        //   height: 5,
                        //   thickness: 3,
                        //   color: Colors.white,
                        // )
                      ],
                    ),
                  ],
                ),
              ),
              // SliverList for the rest of the items

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index < 3 && index < myarr_product.length) {
                      final product = SingleProduct(
                        // Count(),
                        pro_id: myarr_product[index]["pro_id"]!,
                        pro_image: myarr_product[index]["pro_image"]!,
                        pro_name: myarr_product[index]["pro_name"]!,
                        pro_description: myarr_product[index]
                            ["pro_description"]!,
                        pro_price: myarr_product[index]['pro_price'],
                        cat_id: myarr_product[index]["cat_id"]!,
                        quantity: 0,
                      );

                      // Fetch the associated category data for this product
                      final category = myarr_category.firstWhere(
                        (cat) =>
                            cat["cat_id"] == myarr_product[index]["cat_id"],
                        orElse: () => {
                          "cat_id": "cat_id",
                          "cat_image": "cat_image",
                          "cat_name": "cat_name",
                        },
                      );

                      return SingleProductWidget(
                        product: product,
                        category: Category(
                          cat_id: category["cat_id"],
                          cat_image: category["cat_image"],
                          cat_name: category["cat_name"],
                        ),
                        favoriteHandler:
                            FavoriteHandler(FirebaseAuth.instance.currentUser!),
                        isFavorite:
                            _favoriteProductIds.contains(product.pro_id),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                  childCount: myarr_product.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SingleProductWidget extends StatefulWidget {
  final FavoriteHandler favoriteHandler;
  final SingleProduct product;
  final Category category;
  final bool isFavorite;

  const SingleProductWidget(
      {super.key,
      required this.product,
      required this.category,
      required this.favoriteHandler,
      required this.isFavorite});

  @override
  State<SingleProductWidget> createState() => _SingleProductWidgetState();
}

class _SingleProductWidgetState extends State<SingleProductWidget> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  void checkFavoriteStatus() async {
    bool isProductFavorite = await widget.favoriteHandler.isFavorite(
        FirebaseAuth.instance.currentUser!.uid, widget.product.pro_id);

    setState(() {
      isFavorite = isProductFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    void addItemToCart() {
      Provider.of<Restaurant>(context, listen: false).addToCart(widget.product);
    }

    return GestureDetector(
      onTap: () {
        // final productProvider =
        //     Provider.of<ProductProvider>(context, listen: false);
        // productProvider
        //     .selectProduct(product.pro_id); // Update the variable name here

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(
              product: widget.product,
              category: widget.category,
              favoriteHandler: widget.favoriteHandler,
              isFavorite: widget.isFavorite,
            ), // Update the variable name here
          ),
        );
      },
      child: Container(
        color: Colors.white,
        child: Card(
          // padding: EdgeInsets.only(bottom: 5, right: 3, left: 3, top: 2),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      widget.product
                          .pro_image, // Use the pro_image property as the image URL
                    ),
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.product.pro_name,
                      style: const TextStyle(
                        fontFamily: 'Al-Jazeera',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    // Text(
                    //   product.pro_description,
                    //   style: const TextStyle(color: Colors.grey),
                    // ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  // color: Color.fromRGBO(234, 30, 73, 1),
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.topLeft,
                      colors: [Colors.amber, Color.fromRGBO(234, 30, 73, 1)]),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${widget.product.pro_price.toDouble()}',
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
                            height: 20,
                            width: 20,
                          ),
                        ],
                      ),
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
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? Color.fromARGB(255, 254, 170, 61)
                              : Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.shopping_cart_checkout,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Add your shopping cart logic here
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
      ),
    );
  }
}

class SingleCategoryWidget extends StatelessWidget {
  final Category category;

  const SingleCategoryWidget({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoryProductsScreen(
                            category: category,
                          )));
            },
            child: Container(
              width: 60,
              height: 30,
              // padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: Image.network(
                category.cat_image,
                errorBuilder: (context, error, stackTrace) {
                  // Display a placeholder image or error message when the image fails to load
                  return const Icon(Icons.error_outline, color: Colors.red);
                },
              ),
            ),
          ),
          Text(
            category.cat_name,
            style: const TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Al-Jazeera',
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}
