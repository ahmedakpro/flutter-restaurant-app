import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CityChangePage extends StatefulWidget {
  @override
  _CityChangePageState createState() => _CityChangePageState();
}

class _CityChangePageState extends State<CityChangePage> {
// Function to get the current user's ID
  String getCurrentUserId() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // Handle the case when user is not signed in
      throw Exception("User not signed in");
    }
  }

  @override
  void initState() {
    super.initState();
    // Load the user's selected city from Firestore
    loadUserCity();
  }

  void loadUserCity() async {
    try {
      String userId = getCurrentUserId();
      DocumentSnapshot userDoc =
          await firestore.collection('customers').doc(userId).get();
      if (userDoc.exists) {
        setState(() {
          selectedCity = userDoc.get('city') ??
              selectedCity; // Default to "تعز" if not set
        });
      }
    } catch (error) {
      print('Error loading user city: $error');
    }
  }

  String selectedCity = "تعز";

  // Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Function to update the selected city in Firestore
  Future<void> updateSelectedCityInFirestore(String newCity) async {
    try {
      String userId =
          getCurrentUserId(); // Replace with your user id retrieval logic

      await firestore.collection('customers').doc(userId).update({
        'city': newCity,
      });
      print('City updated successfully');
    } catch (error) {
      print('Error updating city: $error');
    }
  }

  TextStyle textStyle = const TextStyle(
    fontSize: 18,
    fontFamily: 'Al-Jazeera',
    color: Colors.black,
  );
  @override
  Widget build(BuildContext context) {
    Color primeryColor = Color.fromRGBO(234, 30, 73, 1);
    Color soecondColor = Color.fromARGB(255, 255, 160, 61);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: primeryColor,
            title: const Text(
              'تغيير المنطقة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Al-Jazeera',
                color: Colors.white,
              ),
            )),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 3),
              DropdownButton<String>(
                value: selectedCity,
                style: textStyle,
                onChanged: (newValue) {
                  setState(() {
                    selectedCity = newValue!;
                  });
                },
                items: const [
                  DropdownMenuItem(value: "تعز", child: Text("تعز")),
                  DropdownMenuItem(value: "عدن", child: Text("عدن")),
                  DropdownMenuItem(value: "الحديدة", child: Text("الحديدة")),
                  DropdownMenuItem(value: "صنعاء", child: Text("صنعاء")),
                  DropdownMenuItem(value: "إب", child: Text("إب")),
                  DropdownMenuItem(value: "ذمار", child: Text("ذمار")),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  // Update selected city in Firebase Firestore
                  await updateSelectedCityInFirestore(selectedCity);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(primary: soecondColor),
                child: Text('حفظ التغييرات'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
