import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BalancePage extends StatefulWidget {
  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  late Future<String> userBalanceFuture;

  @override
  void initState() {
    super.initState();
    userBalanceFuture = fetchUserBalance();
  }

  Future<String> fetchUserBalance() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("customers")
          .doc(currentUser.uid)
          .get();
      return userSnapshot.get("balance").toString();
    }
    return '0.0';
  }

  TextStyle boldTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    fontFamily: 'Al-Jazeera',
    // color: Colors.black,
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
              'رصيدي',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Al-Jazeera',
                color: Colors.white,
              ),
            )),
        body: FutureBuilder<String>(
          future: userBalanceFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return Center(
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 1.5,
                height: 50,
                decoration: BoxDecoration(
                    color: soecondColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Text('رصيدي: ${snapshot.data}', style: boldTextStyle),
              ),
            );
          },
        ),
      ),
    );
  }
}
