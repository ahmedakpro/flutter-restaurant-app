import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/auth/firebase_constants.dart';
import 'package:restaurant/components/bottom_nav_bar.dart';
import 'package:restaurant/pages/account/register.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) {
        // The widget has been disposed, cancel the timer
        timer.cancel();
      } else {
        checkEmailVerified();
      }
    });
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      // TODO: implement your code after email verification
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email Successfully Verified")));

      timer?.cancel();
    }
  }

  void deleteUnverifiedUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      try {
        // Delete the user's account from Firebase Authentication
        await user.delete();
      } catch (e) {
        debugPrint('Error deleting user: $e');
      }
    }
  }

  Future<void> deleteDataFromFirestore() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Check if the user still exists in Firebase Authentication
        await currentUser.reload();
        if (currentUser.email != null) {
          await FirebaseFirestore.instance
              .collection("customers")
              .doc(currentUser.uid)
              .delete();
          print("Document deleted successfully");
        } else {
          print("User does not exist. No data deleted.");
        }
      }
    } catch (e) {
      print("Error deleting customer data: $e");
    }
  }

  @override
  void dispose() {
    deleteUnverifiedUser(); // Call the function when the screen is disposed
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color.fromRGBO(234, 30, 73, 1),
            width: 12,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          )),
      child: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: isEmailVerified
                ? const BottomNavBar()
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 180,
                          width: 180,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/logo2.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(15)),
                            child: const Text(
                              'من فضلك تفقد بريدك الإلكتروني',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Al-Jazeera',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                          child: Center(
                            child: Text(
                              'لقد قمنا بإرسال رابط للتحقق من أن البريد الالكتروني ملكك على  \n \n ',
                              style: TextStyle(
                                fontFamily: 'Al-Jazeera',
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(234, 30, 73, 1),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            '${auth.currentUser?.email}',
                            style: const TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontFamily: 'Al-Jazeera',
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(child: CircularProgressIndicator()),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                          child: Center(
                            child: Text(
                              'جاري التحقق من البريد الإلكتروني ...',
                              style: TextStyle(
                                fontFamily: 'Al-Jazeera',
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 57),
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.height / 15,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(234, 30, 73, 1),
                                    borderRadius: BorderRadius.circular(15)),
                                child: GestureDetector(
                                  child: const Text(
                                    'اعادة الارسال',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Al-Jazeera',
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                  onTap: () {
                                    try {
                                      FirebaseAuth.instance.currentUser
                                          ?.sendEmailVerification();
                                    } catch (e) {
                                      debugPrint('$e');
                                    }
                                  },
                                ),
                              ),

                              // Add a cancel button
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.height / 15,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15)),
                                child: GestureDetector(
                                  child: const Text(
                                    'إلغاء',
                                    style: TextStyle(
                                        fontFamily: 'Al-Jazeera',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                  onTap: () {
                                    bool showloginpage = true;
                                    void togglePages() {
                                      setState(() {
                                        showloginpage = !showloginpage;
                                      });
                                    }

                                    // Handle cancel button press
                                    // For example, you can navigate back to the previous screen
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegisterPage(
                                                onTap: togglePages,
                                              )),
                                    );
                                    deleteUnverifiedUser();
                                    deleteDataFromFirestore();
                                  },
                                ),
                              ),
                            ],
                          ),
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
