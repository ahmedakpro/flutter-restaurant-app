import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  File? _avatarImage;
  bool _dataLoaded = false; // Track if data has been loaded from Firestore

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _currentAvatarUrl = '';

  Color primeryColor = Color.fromRGBO(234, 30, 73, 1);
  Color soecondColor = Color.fromARGB(255, 255, 160, 61);
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primeryColor,
          title: Text(
            'الملف الشخصي',
            style: TextStyle(
              fontFamily: 'Al-Jazeera',
            ),
          ),
        ),
        body: currentUser != null
            ? FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('customers')
                    .doc(currentUser.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading data'));
                  }
                  final customerData = snapshot.data?.data() as Map?;
                  _nameController.text = customerData?['customer_name'] ?? '';
                  _emailController.text = customerData?['customer_email'] ?? '';
                  _phoneController.text = customerData?['customerPhone'] ?? '';
                  _currentAvatarUrl =
                      customerData?['avatarUrl'] ?? 'images/logo2.jpg';
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                backgroundImage: _avatarImage != null
                                    ? FileImage(_avatarImage!)
                                    : (_currentAvatarUrl.isNotEmpty
                                        ? NetworkImage(_currentAvatarUrl)
                                        : null) as ImageProvider<Object>,
                                radius: 50,
                                backgroundColor: soecondColor,
                                key: ValueKey<String>(_avatarImage?.path ?? ''),
                                child: _avatarImage == null &&
                                        _currentAvatarUrl.isEmpty
                                    ? Icon(
                                        Icons.add_photo_alternate,
                                        size: 60,
                                        color: Colors.grey[200],
                                      )
                                    : null,
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              style: TextStyle(
                                fontFamily: 'Al-Jazeera',
                              ),
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'الإسم',
                                labelStyle: TextStyle(
                                  fontFamily: 'Al-Jazeera',
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: soecondColor, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: primeryColor),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              style: TextStyle(
                                fontFamily: 'Al-Jazeera',
                              ),
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'البريد الإلكتروني',
                                labelStyle: TextStyle(
                                  fontFamily: 'Al-Jazeera',
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: soecondColor, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: primeryColor),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              style: TextStyle(
                                fontFamily: 'Al-Jazeera',
                                fontSize: 18,
                              ),
                              controller: _phoneController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: primeryColor),
                                    borderRadius: BorderRadius.circular(15)),
                                labelText: 'الهاتف',
                                labelStyle: TextStyle(
                                  fontFamily: 'Al-Jazeera',
                                ),
                                prefix: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    '(+967)',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: soecondColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary:
                                    primeryColor, // Set the background color
                              ),
                              onPressed: () async {
                                await updateProfileInfo(currentUser.uid);
                                _showSuccessDialog();
                              },
                              child: Text(
                                'حفظ التغييرات',
                                style: TextStyle(
                                  fontFamily: 'Al-Jazeera',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  'المستخدم غير مسجل دخول',
                  style: TextStyle(
                    fontFamily: 'Al-Jazeera',
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> updateProfileInfo(String userId) async {
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(userId)
        .update({
      'customer_name': _nameController.text,
      'customer_email': _emailController.text,
      'customerPhone': _phoneController.text,
    });

    if (_avatarImage != null) {
      String imageName = 'avatar_$userId.jpg';
      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref().child(imageName);
      await storageReference.putFile(_avatarImage!);
      String downloadURL = await storageReference.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .update({'avatarUrl': downloadURL});
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              'تم تعديل البيانات بنجاح',
              style: TextStyle(
                fontFamily: 'Al-Jazeera',
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Center(
                  child: Text(
                    'حسناً',
                    style: TextStyle(
                      fontFamily: 'Al-Jazeera',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }
}
