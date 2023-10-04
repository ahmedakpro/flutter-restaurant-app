import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/pages/manage_account.dart/balance_page.dart';
import 'package:restaurant/pages/manage_account.dart/change_city_page.dart';
import 'package:restaurant/pages/manage_account.dart/my_account_settings.dart';
import 'package:restaurant/pages/manage_account.dart/show_orders_page.dart';
import 'package:restaurant/pages/manage_account.dart/user_adresses.dart';

import '../../auth/auth.dart';

class AcountSettings extends StatefulWidget {
  const AcountSettings({super.key});

  @override
  State<AcountSettings> createState() => _AcountSettingsState();
}

class _AcountSettingsState extends State<AcountSettings> {
  @override
  Widget build(BuildContext context) {
    var mainContainerWidth = MediaQuery.of(context).size.width / 3.3;
    Color textColor = Colors.black;
    Color iconColor = Color.fromRGBO(234, 30, 73, 1);
    Color bottomContainer = Color.fromARGB(255, 255, 160, 61);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: iconColor,
          title: Text(
            'إدارة الحساب',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              fontFamily: 'Al-Jazeera',
            ),
          ),
        ),
        backgroundColor: Colors.grey[200],
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            margin: EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: mainContainerWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(19),
                            topRight: Radius.circular(19),
                            bottomLeft: Radius.circular(19),
                            bottomRight: Radius.circular(19),
                          ),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.menu,
                                size: 60,
                                color: iconColor,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                width: MediaQuery.of(context).size.width / 3.2,
                                decoration: BoxDecoration(
                                    color: bottomContainer,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(19),
                                      bottomRight: Radius.circular(19),
                                    )),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => OrdersPage()));
                                  },
                                  child: Text(
                                    'طلباتي',
                                    style: TextStyle(
                                        fontFamily: 'Al-Jazeera',
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                        fontSize: 14),
                                  ),
                                ),
                              )
                            ]),
                      ),
                      Container(
                        width: mainContainerWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(19),
                            topRight: Radius.circular(19),
                            bottomLeft: Radius.circular(19),
                            bottomRight: Radius.circular(19),
                          ),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.attach_money,
                                size: 60,
                                color: iconColor,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                width: MediaQuery.of(context).size.width / 3.2,
                                decoration: BoxDecoration(
                                    color: bottomContainer,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(19),
                                      bottomRight: Radius.circular(19),
                                    )),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => BalancePage()));
                                  },
                                  child: Text(
                                    'رصيدي',
                                    style: TextStyle(
                                        fontFamily: 'Al-Jazeera',
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                        fontSize: 14),
                                  ),
                                ),
                              )
                            ]),
                      ),
                      Container(
                        width: mainContainerWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(19),
                            topRight: Radius.circular(19),
                            bottomLeft: Radius.circular(19),
                            bottomRight: Radius.circular(19),
                          ),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_sharp,
                                color: iconColor,
                                size: 60,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                width: MediaQuery.of(context).size.width / 3.2,
                                decoration: BoxDecoration(
                                    color: bottomContainer,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(19),
                                      bottomRight: Radius.circular(19),
                                    )),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                const MyAccountSettings()));
                                  },
                                  child: Text(
                                    'الحساب',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Al-Jazeera',
                                        color: textColor,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: mainContainerWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(19),
                            topRight: Radius.circular(19),
                            bottomLeft: Radius.circular(19),
                            bottomRight: Radius.circular(19),
                          ),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: iconColor,
                                size: 60,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                width: MediaQuery.of(context).size.width / 3.2,
                                decoration: BoxDecoration(
                                    color: bottomContainer,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(19),
                                      bottomRight: Radius.circular(19),
                                    )),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                const AuthPage()));
                                    FirebaseAuth.instance.signOut();
                                  },
                                  child: Text(
                                    'تسجيل الخروج',
                                    style: TextStyle(
                                        fontFamily: 'Al-Jazeera',
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                        fontSize: 14),
                                  ),
                                ),
                              )
                            ]),
                      ),
                      Container(
                        width: mainContainerWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(19),
                            topRight: Radius.circular(19),
                            bottomLeft: Radius.circular(19),
                            bottomRight: Radius.circular(19),
                          ),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_city,
                                size: 60,
                                color: iconColor,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                width: MediaQuery.of(context).size.width / 3.2,
                                decoration: BoxDecoration(
                                    color: bottomContainer,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(19),
                                      bottomRight: Radius.circular(19),
                                    )),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                CityChangePage()));
                                  },
                                  child: Text(
                                    'تغيير المنطقة',
                                    style: TextStyle(
                                        fontFamily: 'Al-Jazeera',
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                        fontSize: 14),
                                  ),
                                ),
                              )
                            ]),
                      ),
                      Container(
                        width: mainContainerWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(19),
                            topRight: Radius.circular(19),
                            bottomLeft: Radius.circular(19),
                            bottomRight: Radius.circular(19),
                          ),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_pin,
                                size: 60,
                                color: iconColor,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                width: MediaQuery.of(context).size.width / 3.2,
                                decoration: BoxDecoration(
                                    color: bottomContainer,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(19),
                                      bottomRight: Radius.circular(19),
                                    )),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => AddressesPage()));
                                  },
                                  child: Text(
                                    'العناوين',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Al-Jazeera',
                                        color: textColor,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
