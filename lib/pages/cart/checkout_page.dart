import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../product/SingleProduct.dart';

class CheckoutPage extends StatefulWidget {
  final List<SingleProduct> cartItems;
  // final Function(double) updateDeliveryFee;
  final double Function(List<SingleProduct>) calculateTotal;
  final User currentUser;
  const CheckoutPage(
      {super.key,
      required this.cartItems,
      // required this.updateDeliveryFee,
      required this.calculateTotal,
      required this.currentUser});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String customerLocation = '';
  String customerPhone = '';
  String customerCity = '';

  double longitude = 0.0;
  double latitude = 0.0;

  final Map<String, String> fieldTranslations = {
    "order_note": "ملاحظة الطلب",
    "location_note": "وصف للموقع ",
    "order_date": "تاريخ الطلب",
    "Address": "العنوان",
    "lng": "خطوط الطول",
    "city": "المدينة",
    "total_amount": "المجموع",
    "customer_phone": "رقم الهاتف",
    "customer_id": "رقم الزبون",
    "lat": "خطوط العرض",
  };

  String completeAddress = "";

  final locationController = TextEditingController();
  final noteController = TextEditingController();
  final locationNoteController = TextEditingController();
  Position? position;
  List<Placemark>? placeMarks;
  getCurrentLocation() async {
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placeMarks![0];

    completeAddress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    locationController.text = completeAddress;
  }

  String generateOrderDetailsMessage(
      List<SingleProduct> cartItems,
      String customerLocation,
      String customerPhone,
      String customerCity,
      double longitude,
      double latitude) {
    String message = "طلب جديد من الزبون:\n\n";

    // Add customer information to the message
    message += "موقع الزبون: $customerLocation\n";

    message += "رقم الهاتف: $customerPhone\n";
    message += "المدينة: $customerCity\n";
    message += "خطوط الطول: $longitude\n";
    message += "خطوط العرض: $latitude\n\n";

    // Add order details
    for (var item in cartItems) {
      message +=
          "${item.pro_name}: ${item.quantity} x ${item.pro_price} = ${item.quantity * item.pro_price}\n";
    }
    message += "\nالمجموع: ${calculateTotal(cartItems)}";

    return message;
  }

  double calculateTotal(List<SingleProduct> cartItems) {
    double total = 0;
    for (var item in cartItems) {
      total += item.quantity * item.pro_price;
    }
    return total;
  }

  Future<void> sendOrderViaWhatsApp(
      List<SingleProduct> cartItems,
      String customerLocation,
      String customerPhoneNumber,
      String customerCity,
      double longitude,
      double latitude,
      User currentUser) async {
    try {
      // Get the customer's phone number and location from Firestore
      DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
          .collection("customers")
          .doc(currentUser.uid)
          .get();
      String customerPhone = customerSnapshot.get("customerPhone");
      String customerCity = customerSnapshot.get("city");

      // Get the current time and manually format it as "hh:mm"
      // Get the current date and time
      final now = DateTime.now();

// Manually format the date and time components
      String year = now.year.toString();
      String month = now.month.toString().padLeft(2, '0');
      String day = now.day.toString().padLeft(2, '0');
      String hour = now.hour.toString().padLeft(2, '0');
      String minute = now.minute.toString().padLeft(2, '0');

      final formattedDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
// Now you can use 'formattedDate' to store in Firestore or elsewhere
      // Fetch additional order data from Firestore
      DocumentReference orderRef =
          await FirebaseFirestore.instance.collection("orders").add({
        "customer_id": FirebaseAuth.instance.currentUser?.uid,
        "customer_phone": customerPhone,
        "city": customerCity,
        "order_date": formattedDate,
        "total_amount": widget.calculateTotal(cartItems),
        "order_items": cartItems.map((item) {
          return {
            "pro_name": item.pro_name,
            "pro_price": item.pro_price,
            "product_quantity": item.quantity,
          };
        }).toList(),
        "order_note": noteController.text,
        "location_note": locationNoteController.text,
        "Address": completeAddress,
        "lat": position!.latitude,
        "lng": position!.longitude,
      });
      // Fetch the order data to create the message
      DocumentSnapshot orderSnapshot = await orderRef.get();
      Map<String, dynamic> orderData =
          orderSnapshot.data() as Map<String, dynamic>;

      // Create the order details message
      String orderDetailsMessage = "طلب جديد من الزبون:\n\nتفاصيل الطلب:\n";
      orderData.forEach((key, value) {
        if (fieldTranslations.containsKey(key)) {
          orderDetailsMessage += "${fieldTranslations[key]}: $value\n";
        }
      });

      // Add order items to the message
      orderDetailsMessage += "\nقائمة المشتريات:\n";
      for (var item in orderData["order_items"]) {
        orderDetailsMessage +=
            "${item['pro_name']}: ${item['product_quantity']} x ${item['pro_price']} = ${item['product_quantity'] * item['pro_price']}\n";
      }

      // Create the complete message
      final whatsappUrl =
          'https://wa.me/967733638657?text=${Uri.encodeComponent(orderDetailsMessage)}';

      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        print('Could not launch $whatsappUrl');
      }
    } catch (e) {
      print('Error sending order via WhatsApp: $e');
    }
  }

  Future<bool> hasMadePayment(User currentUser) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("payments")
          .where("customer_id", isEqualTo: currentUser.uid)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking payment: $e");
      return false;
    }
  }

  void _showPaymentOptionDialog(User? currentUser) {
    String customer_payment = '';

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('اختر طريقة الدفع', style: textStyle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'رقم الحساب', labelStyle: textStyle),
                  onChanged: (value) {
                    customer_payment = value;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('إلغاء',
                    textAlign: TextAlign.center, style: textStyle),
              ),
              TextButton(
                onPressed: () async {
                  // Get customer's payment info
                  DocumentSnapshot paymentSnapshot;
                  try {
                    paymentSnapshot = await FirebaseFirestore.instance
                        .collection("customers")
                        .doc(currentUser?.uid)
                        .get();
                  } catch (e) {
                    print("Error fetching payment info: $e");
                    paymentSnapshot = null!;
                  }

                  if (paymentSnapshot == null) {
                    // Handle case when payment info is not found
                    print("Payment info not found for user.");
                    return;
                  }

                  // Check if the entered account number matches the stored one
                  String storedAccountNumber =
                      paymentSnapshot.get("customer_payment");
                  if (customer_payment != storedAccountNumber) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Directionality(
                          textDirection: TextDirection.rtl,
                          child: AlertDialog(
                            title:
                                Text('رقم الحساب غير صحيح', style: textStyle),
                            content: Text(
                                'الرجاء التحقق من رقم الحساب والمحاولة مرة أخرى.',
                                style: textStyle),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('موافق', style: textStyle),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    // Payment is valid, proceed with saving payment and deducting balance
                    totalAmount =
                        widget.calculateTotal(widget.cartItems.toList());

                    // Check if balance is sufficient
                    double customerBalance =
                        double.parse(paymentSnapshot.get("balance").toString());
                    if (totalAmount > customerBalance) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('رصيدك غير كافي', style: textStyle),
                            content: Text('رصيدك غير كافي لاتمام الدفع.',
                                style: textStyle),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('موافق', style: textStyle),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'عملية دفع',
                              textAlign: TextAlign.center,
                              style: textStyle,
                            ),
                            content: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 200,
                                    width: 200,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            AssetImage('assets/order_done.png'),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                  Text(
                                    'تم دفع قيمة المشتريات بنجاح. تم خصم \n $totalAmount \n من حسابك',
                                    textAlign: TextAlign.center,
                                    style: textStyle,
                                  ),
                                  SizedBox(height: 50),
                                  TextButton(
                                    onPressed: () async {
                                      // Deduct payment amount from balance and save payment data
                                      await handelBalance(
                                          FirebaseAuth.instance.currentUser!);

                                      // Close payment dialog
                                      Navigator.of(context).pop();

                                      // Close checkout dialog
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('موافق', style: textStyle),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );

                      sendOrderViaWhatsApp(
                          widget.cartItems,
                          completeAddress,
                          customerPhone,
                          customerCity,
                          longitude,
                          latitude,
                          FirebaseAuth.instance.currentUser!);

                      // Show processing message dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              title: Text('تم بنجاح', style: textStyle),
                              content: Text(
                                  'تم تقديم طلبك بنجاح. سيتم معالجة الطلب قريباً.',
                                  style: textStyle),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Close processing message dialog
                                    Navigator.of(context).pop();
                                    // Close checkout dialog
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('موافق', style: textStyle),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }
                },
                child: Text('دفع', style: textStyle),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> handelBalance(User currentUser) async {
    try {
      // Deduct payment amount from user's balance
      await FirebaseFirestore.instance
          .collection("customers")
          .doc(currentUser.uid)
          .collection("payments")
          .add({
        "amount": totalAmount,
        "timestamp": FieldValue.serverTimestamp(),
        "type": "debit", // Indicates deduction from balance
      });

      print("Payment data saved to Firestore successfully");

      // Deduct the payment amount from user's balance
      await FirebaseFirestore.instance
          .collection("customers")
          .doc(currentUser.uid)
          .update({
        "balance": FieldValue.increment(-totalAmount),
      });

      print("User's balance deducted successfully");
    } catch (e) {
      print("Error saving payment data to Firestore: $e");
    }
  }

  Future<String> getCustomerPhoneNumber(String customerId) async {
    try {
      DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
          .collection("customers")
          .doc(customerId)
          .get();
      return customerSnapshot.get("customerPhone");
    } catch (e) {
      print("Error fetching customer phone number: $e");
      return "";
    }
  }

  void fetchUserBalance() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("customers")
          .doc(currentUser.uid)
          .get();
      setState(() {
        userBalance = userSnapshot.get("balance").toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserBalance();
  }

  @override
  void _resetFlags() {
    setState(() {
      fieldForLocation = false;
      showNoteArea = false;
      locationNotefield = false;
    });

    @override
    void dispose() {
      hasMadePayment(widget.currentUser);
      super.dispose();
    }
  }

  bool fieldForLocation = false;
  bool showNoteArea = false;
  bool locationNotefield = false;
  double totalAmount = 0.0;
  String userBalance = '0.0'; // Initialize to 0
  TextStyle textStyle = const TextStyle(
    fontSize: 14,
    fontFamily: 'Al-Jazeera',
    color: Colors.black,
  );
  @override
  Widget build(BuildContext context) {
    Color primeryColor = Color.fromRGBO(234, 30, 73, 1);
    Color soecondColor = Color.fromARGB(255, 255, 160, 61);
    double iconHeight = 40;
    double iconWidth = 40;

    // double screenHeight = MediaQuery.of(context).size.height;
    // double dialogHeight = screenHeight / 2;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FractionallySizedBox(
        heightFactor: 0.7, // Set to 0.5 for half the screen height
        widthFactor: 1.2,
        alignment: FractionalOffset.bottomCenter,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: iconWidth,
                              height: iconHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: primeryColor,
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const Text(
                              'اختر  العنوان...',
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Al-Jazeera',
                                color: Colors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _resetFlags();
                                fieldForLocation = true;
                                getCurrentLocation();
                              },
                              child: const Text(
                                'اظافة',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Al-Jazeera',
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (fieldForLocation) ...[
                        Padding(
                          padding: const EdgeInsets.only(right: 25, left: 25),
                          child: TextFormField(
                            controller: locationController,
                            readOnly: true,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: soecondColor,
                                    width:
                                        2), // Set the color of the bottom line when the field is focused
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: primeryColor,
                                ), // Set the color of the bottom line when the field is not focused
                              ),
                              labelText: 'موقع التوصيل',
                              labelStyle: TextStyle(
                                fontFamily: 'Al-Jazeera',
                              ),
                            ),
                          ),
                        ),
                      ],
// Locatin note area
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: iconWidth,
                              height: iconHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: primeryColor,
                              ),
                              child: const Icon(
                                Icons.note_alt_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            Text(
                              'ملاحظة الموقع',
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Al-Jazeera',
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _resetFlags();
                                locationNotefield = true;
                              },
                              child: const Text(
                                'اظافة',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Al-Jazeera',
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (locationNotefield) ...[
                        Padding(
                          padding: const EdgeInsets.only(right: 25, left: 25),
                          child: TextFormField(
                            style: const TextStyle(
                              fontFamily: 'Al-Jazeera',
                            ),
                            controller: locationNoteController,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: soecondColor,
                                    width:
                                        2), // Set the color of the bottom line when the field is focused
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: primeryColor,
                                ), // Set the color of the bottom line when the field is not focused
                              ),
                              labelText: 'وصف لموقعك الفعلي ',
                              labelStyle: TextStyle(
                                fontFamily: 'Al-Jazeera',
                              ),
                            ),
                          ),
                        ),
                      ],
                      //Order Note area
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: iconWidth,
                              height: iconHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: primeryColor,
                              ),
                              child: const Icon(
                                Icons.note_alt_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            Text(
                              'ملاحظة الطلب',
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Al-Jazeera',
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _resetFlags();
                                showNoteArea = true;
                              },
                              child: const Text(
                                'اظافة',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Al-Jazeera',
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // textfrom field for orderNote
                      if (showNoteArea) ...[
                        Padding(
                          padding: const EdgeInsets.only(right: 25, left: 25),
                          child: TextFormField(
                            style: const TextStyle(
                              fontFamily: 'Al-Jazeera',
                            ),
                            controller: noteController,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: soecondColor,
                                    width:
                                        2), // Set the color of the bottom line when the field is focused
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: primeryColor,
                                ), // Set the color of the bottom line when the field is not focused
                              ),
                              labelText: 'ملاحظة الطلب',
                              labelStyle: TextStyle(
                                fontFamily: 'Al-Jazeera',
                              ),
                            ),
                          ),
                        ),
                      ],
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: iconWidth,
                                  height: iconHeight,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: primeryColor,
                                  ),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const Text(
                                  'ادخل رقم حسابك',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Al-Jazeera',
                                    color: Colors.black,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _showPaymentOptionDialog(
                                        FirebaseAuth.instance.currentUser!);
                                  },
                                  child: const Text(
                                    'اظافة',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Al-Jazeera',
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          ' الرصيد ${userBalance.toString()}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Al-Jazeera',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "# ملاحظة : لا يمكنك التراجع في هذة القائمة بعد الدفع !!",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            fontFamily: 'Al-Jazeera',
                          ),
                          textAlign: TextAlign.center,
                        ),
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
