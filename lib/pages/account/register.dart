import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/auth/firebase_constants.dart';
import 'package:restaurant/components/button.dart';
import 'package:restaurant/components/text_field.dart';

import '../../auth/verify_email_page.dart';

class RegisterPage extends StatefulWidget {
  final Function() onTap;

  const RegisterPage({super.key, required this.onTap});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final customerNameController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  bool _isLoading = false;
  // Sign in user
  bool passwordsMatch() {
    return passwordTextController.text == confirmPasswordTextController.text;
  }

  Future<void> signUp({
    required String userEmail,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text.trim(),
        password: passwordTextController.text.trim(),
      );

      if (userCredential.user != null) {
        await saveDataToFirestore(userCredential.user!);
        Navigator.pop(context);
      } else {
        // Handle case when userCredential.user is null
        displayMessage("Registration failed. Please try again.");
      }
    } catch (e) {
      // Handle any errors that occur during the registration process
      debugPrint(e.toString());
      displayMessage("Registration failed. Please try again.");
    }
  } // End SignUp func

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }
// Save Customer data

  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance
        .collection("customers")
        .doc(currentUser.uid)
        .set({
      "customerUID": currentUser.uid,
      "customer_email": currentUser.email,
      "customer_name": customerNameController.text.trim(),
    });
  }

  Future<bool> isEmailAlreadyTaken(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("customers")
          .where("customer_email", isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking email existence: $e');
      return false;
    }
  }

  bool isStrongPassword(String password) {
    // Define your password strength criteria here
    // For example, at least 8 characters with a mix of letters, numbers, and symbols
    RegExp regex =
        RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~%^!/?|]).{8,}$');
    return regex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(const EmailVerificationScreen());
    final forKey = GlobalKey<FormState>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Column(children: [
                    Expanded(
                      child: Form(
                        child: ListView(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //logo
                            const ClipOval(
                              child: Image(
                                image: AssetImage('images/logo2.jpg'),
                                fit: BoxFit.fitHeight,
                                width:
                                    200, // Set the desired width of the image
                                height:
                                    200, // Set the desired height of the image
                              ),
                            ),
                            const SizedBox(height: 20),
                            //message
                            Text(
                              "قم بانشاء حساب خاص بك !",
                              style: TextStyle(
                                fontFamily: 'Al-Jazeera',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Username textfiled
                            MyTextFiled(
                              controller: customerNameController,
                              hinText: 'إسمك الكامل',
                              obscureText: false,
                            ),

                            const SizedBox(height: 8),

                            //email textfiled
                            MyTextFiled(
                              controller: emailTextController,
                              hinText: 'البريد الإلكتروني',
                              obscureText: false,
                            ),

                            const SizedBox(height: 8),

                            // password textfiled
                            MyTextFiled(
                              controller: passwordTextController,
                              hinText: 'لاتقل عن 8 خانات - كلمة المرور',
                              obscureText: true,
                            ),
                            const SizedBox(height: 8),

                            //confirm password textfiled
                            MyTextFiled(
                              controller: confirmPasswordTextController,
                              hinText: ' تأكيد كلمة المرور',
                              obscureText: true,
                            ),
                            const SizedBox(height: 10),
                            //sign in button

                            _isLoading
                                ? const CircularProgressIndicator()
                                : MyButton(
                                    onTap: () async {
                                      if (!passwordsMatch()) {
                                        displayMessage(
                                            "كلمة المرور غير متطابقة!!");
                                        return;
                                      }
                                      if (!isStrongPassword(
                                          passwordTextController.text)) {
                                        displayMessage(
                                            "يجب تعيين كلمة مرور تحتوي على رموز وحروف وارقام كبيرة وصغيرة "
                                            'A-f-0_9-@^&'
                                            "");
                                        return;
                                      }

                                      if (await isEmailAlreadyTaken(
                                          emailTextController.text)) {
                                        displayMessage(
                                            "البريد الالكتروني المستخدم موجود بالفعل!!");
                                        return;
                                      }
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      await signUp(
                                        userEmail: emailTextController.text,
                                        password: passwordTextController.text,
                                        context: context,
                                      );
                                      if (auth.currentUser != null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    const EmailVerificationScreen()));
                                      }
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    },
                                    text: 'إنشاء حساب',
                                  ),

                            const SizedBox(height: 10),
                            // go to the register page
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'لديك حساب من قبل؟',
                                  style: TextStyle(
                                    fontFamily: 'Al-Jazeera',
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: widget.onTap,
                                  child: const Text(
                                    'سجل دخول',
                                    style: TextStyle(
                                      fontFamily: 'Al-Jazeera',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ]),
                )),
          ),
        ),
      ),
    );
  }

  Future<void> checkUnregisteredAccounts() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final CollectionReference _customersCollection =
        FirebaseFirestore.instance.collection('customers');

    List<String> _customersEmails =
        []; // List of email addresses from Firestore
    List<String> _authEmails =
        []; // List of email addresses from Authentication
    List<String> _unregisteredEmails =
        []; // List of unregistered email addresses

    QuerySnapshot customersSnapshot = await _customersCollection.get();
    _customersEmails =
        customersSnapshot.docs.map((doc) => doc['email'] as String).toList();

    User? authUser = _auth.currentUser;
    if (authUser != null) {
      _authEmails.add(authUser.email!);
    }

    _unregisteredEmails = _customersEmails
        .where((email) => !_authEmails.contains(email))
        .toList();

    print('Unregistered Email Addresses: $_unregisteredEmails');
  }

  void main() {
    checkUnregisteredAccounts();
  }
}
