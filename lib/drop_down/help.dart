import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  void openFacebookPage() async {
    const facebookPageUrl =
        'https://www.facebook.com/profile.php?id=100010329970441&mibextid=ZbWKwL';
    if (await canLaunch(facebookPageUrl)) {
      await launch(facebookPageUrl);
    } else {
      // Handle if the URL cannot be launched
      elseHandel(context);
    }
  }

  void openWhatsApp() async {
    const whatsappNumber = '967712471777';
    final whatsappUrl = 'https://wa.me/$whatsappNumber';
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      // Handle if WhatsApp cannot be launched
      elseHandel(context);
    }
  }

  void callCustomerService() async {
    const phoneNumber = '967712471777';
    final phoneUrl = 'tel:$phoneNumber';
    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      // Handle if the phone call cannot be initiated
      elseHandel(context);
    }
  }

  void elseHandel(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Unable to open Facebook page.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  TextStyle textStyle = const TextStyle(
    fontSize: 14,
    fontFamily: 'Al-Jazeera',
    color: Colors.white,
  );
  TextStyle boldTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: 'Al-Jazeera',
    color: Colors.red,
  );
  Color primeryColor = Color.fromRGBO(234, 30, 73, 1);
  Color soecondColor = Color.fromARGB(255, 255, 160, 61);
  Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              height: 30,
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Ahmed AL-khulidi",
                style: boldTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),

            // Facebok area
            GestureDetector(
              onTap: () {
                openFacebookPage();
              },
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: MediaQuery.of(context).size.width,
                color: primeryColor,
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.facebook,
                      color: white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'صفحتنا على فيسبوك',
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),

            // Whatsapp area
            GestureDetector(
              onTap: () {
                openWhatsApp();
              },
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: MediaQuery.of(context).size.width,
                color: primeryColor,
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.whatsapp,
                      color: white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'خدمة العملاء واتس اب',
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),

            //Call area
            GestureDetector(
              onTap: (() {
                callCustomerService();
              }),
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: MediaQuery.of(context).size.width,
                color: primeryColor,
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.call,
                      color: white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'اتصل بخدمة العملاء',
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            //Textbuton
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'اغلاق',
                style: boldTextStyle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
