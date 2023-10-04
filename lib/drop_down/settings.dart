import 'package:flutter/material.dart';
import 'package:restaurant/pages/manage_account.dart/change_city_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextStyle textStyle = const TextStyle(
    fontSize: 16,
    fontFamily: 'Al-Jazeera',
    color: Colors.grey,
  );
  TextStyle boldTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Al-Jazeera',
    color: Colors.white,
  );
  Color primeryColor = Color.fromRGBO(234, 30, 73, 1);
  Color soecondColor = Color.fromARGB(255, 255, 160, 61);
  Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text(
              'الإعدادات',
              style: boldTextStyle,
            ),
            backgroundColor: primeryColor,
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height / 1.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'الاساسية',
                    style: TextStyle(
                      fontSize: 16,
                      color: primeryColor,
                      fontFamily: 'Al-Jazeera',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CityChangePage()),
                        );
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.location_city,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 25),
                          Text(
                            'تغيير المنطقة ',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Al-Jazeera',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      alignment: Alignment.topRight,
                      child: Text(
                        'يمكنك التحويل من منطقة الى اخري عند\n التنقل او السفر',
                        style: textStyle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.replay_outlined,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 25),
                        Text(
                          'اعادة سحب البيانات ',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Al-Jazeera',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        'اصلاح اي مشكلة تتعلق بصحة البيانات لديك',
                        textAlign: TextAlign.right,
                        style: textStyle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.developer_mode_outlined,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 25),
                        Text(
                          'تم التطوير بواسطة  ',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Al-Jazeera',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        'أحمد الخليدي',
                        style: textStyle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 25),
                        Text(
                          'سياسة الخصوصية',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Al-Jazeera',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.system_security_update,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 25),
                        Text(
                          ' التحديث الان',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Al-Jazeera',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.system_security_update_good,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 25),
                        Text(
                          'الاصدار ',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Al-Jazeera',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        '1.8.9',
                        style: textStyle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          )),
    );
  }
}
