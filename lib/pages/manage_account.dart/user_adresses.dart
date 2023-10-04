import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart'; // Import geolocator package
import 'package:firebase_auth/firebase_auth.dart'; // Import firebase_auth package

class AddressesPage extends StatefulWidget {
  @override
  _AddressesPageState createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  late List<String> userAddresses = [];

  Future<List<String>> fetchUserAddresses(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .collection('addresses')
          .get();

      final addresses =
          snapshot.docs.map((doc) => doc['address'] as String).toList();
      return addresses;
    } catch (error) {
      print('Error fetching addresses: $error');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    // Load user addresses from Firebase Firestore during initialization
    loadUserAddresses();
  }

  Future<void> loadUserAddresses() async {
    final user = FirebaseAuth.instance.currentUser;
    // Fetch user addresses from Firebase Firestore and update the list
    // Replace 'fetchUserAddresses()' with your actual implementation
    userAddresses = await fetchUserAddresses(user!.uid);
    setState(() {});
  }

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
    Color soecondColor = Color.fromARGB(255, 255, 160, 61);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: primeryColor,
            title: const Text('العناوين',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Al-Jazeera',
                  color: Colors.white,
                )),
          ),
          body: userAddresses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ليس لديك عناوين مضافة.', style: textStyle),
                      ElevatedButton(
                        onPressed: () async {
                          // Navigate to AddLocationPage when button is pressed
                          await showDialog<String>(
                            context: context,
                            builder: (context) => AddLocationPage(),
                          ).then(
                            (_) {
                              // Refresh addresses after returning from AddLocationPage
                              loadUserAddresses();
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(primary: primeryColor),
                        child: const Text(
                          'أضف عنوانًا',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Al-Jazeera',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: userAddresses.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(userAddresses[index]),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () async {
                                        // Show a dialog for editing the address
                                        final editedAddress =
                                            await showDialog<String>(
                                          context: context,
                                          builder: (context) =>
                                              EditAddressDialog(
                                            initialAddress:
                                                userAddresses[index],
                                          ),
                                        );
                                        if (editedAddress != null) {
                                          // Update the address in Firestore
                                          final user =
                                              FirebaseAuth.instance.currentUser;
                                          await FirebaseFirestore.instance
                                              .collection('customers')
                                              .doc(user!.uid)
                                              .collection('addresses')
                                              .where('address',
                                                  isEqualTo:
                                                      userAddresses[index])
                                              .get()
                                              .then((snapshot) {
                                            for (DocumentSnapshot doc
                                                in snapshot.docs) {
                                              doc.reference.update(
                                                  {'address': editedAddress});
                                            }
                                          });

                                          // Update the address in the userAddresses list
                                          setState(() {
                                            userAddresses[index] =
                                                editedAddress;
                                          });
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        // Delete the address from Firestore and refresh the list
                                        final user =
                                            FirebaseAuth.instance.currentUser;
                                        await FirebaseFirestore.instance
                                            .collection('customers')
                                            .doc(user!.uid)
                                            .collection('addresses')
                                            .where('address',
                                                isEqualTo: userAddresses[index])
                                            .get()
                                            .then((snapshot) {
                                          for (DocumentSnapshot doc
                                              in snapshot.docs) {
                                            doc.reference.delete();
                                          }
                                        });
                                        loadUserAddresses();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'هل تريد إضافة موقع جديد؟',
                              style: textStyle,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // Navigate to AddLocationPage when button is pressed
                                await showDialog<String>(
                                  context: context,
                                  builder: (context) => AddLocationPage(),
                                ).then(
                                  (_) {
                                    // Refresh addresses after returning from AddLocationPage
                                    loadUserAddresses();
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: soecondColor),
                              child: Text(
                                'أضف موقع جديد',
                                style: textStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }
}

class AddLocationPage extends StatefulWidget {
  @override
  _AddLocationPageState createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  //
  String completeAddress = "";
  final locationController = TextEditingController();
  late String newAddress;
  bool addressEdited = false;

  Future<void> addNewAddress(String userId, String address) async {
    try {
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .collection('addresses')
          .add({
        'address': address,
      });
      print('Address added successfully.');
    } catch (error) {
      print('Error adding address: $error');
    }
  }

  @override
  void initState() {
    super.initState();
  }

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
    Color soecondColor = Color.fromARGB(255, 255, 160, 61);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(
          'إضافة عنوان',
          style: boldTextStyle,
        ),
        actions: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25),
                child: TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: soecondColor, width: 2),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Position? position;
                      List<Placemark>? placeMarks;
                      getCurrentLocation() async {
                        Position newPosition =
                            await Geolocator.getCurrentPosition(
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

                        // Add the new address to Firestore
                        final user = FirebaseAuth.instance.currentUser;
                        await addNewAddress(user!.uid, completeAddress);

                        setState(() {
                          addressEdited = true;
                        });
                      }

                      // Call the function to get current location
                      await getCurrentLocation();
                    },
                    style: ElevatedButton.styleFrom(primary: primeryColor),
                    child: const Text(
                      'تحديد العنوان',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Al-Jazeera',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: addressEdited
                        ? () {
                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(primary: soecondColor),
                    child: Text(
                      'موافق',
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EditAddressDialog extends StatefulWidget {
  final String initialAddress;

  EditAddressDialog({required this.initialAddress});

  @override
  _EditAddressDialogState createState() => _EditAddressDialogState();
}

class _EditAddressDialogState extends State<EditAddressDialog> {
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addressController.text = widget.initialAddress;
  }

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
    Color soecondColor = Color.fromARGB(255, 255, 160, 61);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(
          'تعديل العنوان',
          style: boldTextStyle,
        ),
        content: TextFormField(
          controller: addressController,
          decoration:
              InputDecoration(labelText: 'العنوان', labelStyle: textStyle),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, addressController.text);
                },
                style: ElevatedButton.styleFrom(primary: primeryColor),
                child: const Text('حفظ التعديل',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Al-Jazeera',
                      color: Colors.white,
                    )),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(primary: soecondColor),
                child: Text(
                  'إلغاء',
                  style: textStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
