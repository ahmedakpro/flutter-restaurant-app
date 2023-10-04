import 'package:flutter/material.dart';
import 'package:restaurant/pages/account/changepassword.dart';
import 'package:restaurant/pages/account/myprofile.dart';

class MyAccountSettings extends StatefulWidget {
  const MyAccountSettings({super.key});

  @override
  State<MyAccountSettings> createState() => _MyAccountSettingsState();
}

class _MyAccountSettingsState extends State<MyAccountSettings> {
  @override
  Widget build(BuildContext context) {
    var mainContainerWidth = MediaQuery.of(context).size.width;
    Color textColor = Colors.black;
    Color iconColor = Color.fromRGBO(234, 30, 73, 1);
    Color bottomContainer = Color.fromARGB(255, 255, 160, 61);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: iconColor,
          title: Text(
            'إدارة الملف الشخصي',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Al-Jazeera',
            ),
          ),
        ),
        backgroundColor: Colors.grey[200],
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
          ),
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(10),
              child: Column(
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
                        SizedBox(height: 5),
                        Icon(
                          Icons.settings,
                          size: 50,
                          color: iconColor,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          width: MediaQuery.of(context).size.width,
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
                                      builder: (context) => ProfilePage()));
                            },
                            child: Text(
                              'البيانات الشخصية',
                              style: TextStyle(
                                  fontFamily: 'Al-Jazeera',
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
                          SizedBox(height: 10),
                          Icon(
                            Icons.lock_open,
                            size: 40,
                            color: iconColor,
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.only(bottom: 5),
                            width: MediaQuery.of(context).size.width,
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
                                        builder: (context) =>
                                            ChangePasswordPage()));
                              },
                              child: Text(
                                'تغيير كلمة المرور',
                                style: TextStyle(
                                    fontFamily: 'Al-Jazeera',
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    fontSize: 16),
                              ),
                            ),
                          )
                        ]),
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
