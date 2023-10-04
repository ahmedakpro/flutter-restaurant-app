import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'categories.dart';
import 'subcategory.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Map<String, dynamic>> myarr_category = [];

  // Function to fetch categories from Firestore
  Future<void> fetchCategories() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();

    setState(() {
      myarr_category = List<Map<String, dynamic>>.from(
          querySnapshot.docs.map((doc) => doc.data()).toList());
    });
  }

  void initState() {
    super.initState();
    // Fetch categories and products data when the widget is initialized
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(234, 30, 73, 1),
          title: const Text(
            "قائمة الماكولات",
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: 'Al-Jazeera',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 25),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    final category = Category(
                      cat_id: myarr_category[index]["cat_id"]!,
                      cat_image: myarr_category[index]["cat_image"]!,
                      cat_name: myarr_category[index]["cat_name"]!,
                    );
                    return SingleCategoryWidget(category: category);
                  },
                  itemCount: myarr_category.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SingleCategoryWidget extends StatefulWidget {
  final Category category;

  const SingleCategoryWidget({Key? key, required this.category})
      : super(key: key);

  @override
  State<SingleCategoryWidget> createState() => _SingleCategoryWidgetState();
}

class _SingleCategoryWidgetState extends State<SingleCategoryWidget> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.only(right: 10.0),
        child: Column(
          children: [
            MouseRegion(
              onEnter: (event) {
                setState(() {
                  isHovered = true;
                });
              },
              onExit: (event) {
                setState(() {
                  isHovered = false;
                });
              },
              child: InkWell(
                splashColor:
                    Colors.transparent, // Set splashColor to transparent
                highlightColor:
                    Colors.transparent, // Set highlightColor to transparent
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      // Return the color you want for the overlay when pressed
                      return Color.fromRGBO(234, 30, 73, 1)
                          .withOpacity(0.3); // Example color with opacity
                    }
                    // Return the color you want for the default overlay
                    return Colors.blue
                        .withOpacity(0.3); // Example color with opacity
                  },
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryProductsScreen(
                                category: widget.category,
                              )));
                },
                child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.white),
                    child: Image.network(
                      widget.category.cat_image,
                      errorBuilder: (context, error, stackTrace) {
                        // Display a placeholder image or error message when the image fails to load
                        return const Icon(Icons.error_outline,
                            color: Colors.red);
                      },
                    ),
                  ),
                  title: Text(
                    widget.category.cat_name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Al-Jazeera',
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
