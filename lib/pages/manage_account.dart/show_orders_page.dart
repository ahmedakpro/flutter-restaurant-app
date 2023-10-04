import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersPage extends StatelessWidget {
  TextStyle textStyle = const TextStyle(
    fontSize: 14,
    fontFamily: 'Al-Jazeera',
    color: Colors.black,
  );
  TextStyle boldTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Al-Jazeera',
    color: Colors.black,
  );
  @override
  Widget build(BuildContext context) {
    Color primeryColor = Color.fromRGBO(234, 30, 73, 1);

    // Get the current user's ID
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primeryColor,
          title: Text(
            'طلباتي',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Al-Jazeera',
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: StreamBuilder<QuerySnapshot>(
            // Fetch orders for the current user
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('customer_id', isEqualTo: currentUserId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('لايوجد طلبات الى الان...'));
              }
              // Display orders using ListView.builder
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  // Extract order details from Firestore document
                  Map<String, dynamic> orderData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  List<dynamic> orderItems = orderData['order_items'];
                  String orderNote = orderData['order_note'];
                  double totalAmount = orderData['total_amount'];
                  String orderTimestamp = orderData['order_date'];
                  // DateTime orderDate = orderTimestamp.toString();

                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        'تاريخ الطلب: ${orderTimestamp.toString()}',
                        style: textStyle,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ملاحظة الطلب: $orderNote', style: textStyle),
                          Text('المبلغ الإجمالي: $totalAmount',
                              style: textStyle),
                          SizedBox(height: 8),
                          Text('المنتجات:', style: textStyle),
                          Column(
                            children: orderItems.map((item) {
                              return Text(
                                  '${item['pro_name']} - الكمية: ${item['product_quantity']}',
                                  style: textStyle);
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
