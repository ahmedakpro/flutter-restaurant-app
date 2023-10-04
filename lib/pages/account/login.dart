import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/components/button.dart';
import 'package:restaurant/components/text_field.dart';
import 'package:restaurant/pages/account/forgetPassword.dart';

class LoginPage extends StatefulWidget {
  final Function() onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  void signIn() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      //pop loading circle
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      diisplayMessage(e.code);
    }
  }

  void diisplayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  children: [
                    Expanded(
                      child: Form(
                        child: ListView(
                          children: [
                            //logo
                            const Flexible(
                              child: ClipOval(
                                child: Image(
                                  image: AssetImage('images/logo2.jpg'),
                                  fit: BoxFit.fitHeight,
                                  width:
                                      200, // Set the desired width of the image
                                  height:
                                      200, // Set the desired height of the image
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            //message
                            Text(
                              "مرحبا بعودتك، العديد من الوجبات الشهيه بإنتضارك !",
                              style: TextStyle(
                                fontFamily: 'Al-Jazeera',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 25),

                            //email textfiled
                            MyTextFiled(
                              controller: emailTextController,
                              hinText: 'البريد الإلكتروني',
                              obscureText: false,
                            ),

                            const SizedBox(height: 10),

                            // password textfiled
                            MyTextFiled(
                              controller: passwordTextController,
                              hinText: 'كلمة المرور',
                              obscureText: true,
                            ),

                            const SizedBox(height: 2),

                            // Forgot password button
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'هل نسيت كلمة المرور؟',
                                style: TextStyle(
                                  fontFamily: 'Al-Jazeera',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            //sign in button

                            MyButton(
                              onTap: signIn,
                              text: 'تسجيل الدخول',
                            ),

                            // go to the register page
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'غير مسجل؟',
                                  style: TextStyle(
                                    fontFamily: 'Al-Jazeera',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                TextButton(
                                  onPressed: widget.onTap,
                                  child: const Text(
                                    'انشىء حساب',
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
