import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController _emailController = TextEditingController();

  void resetPassword() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );

      //pop loading circle
      if (mounted) Navigator.pop(context);
      _showSuccessDialog();
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog(e.toString());
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
          style: TextStyle(
            fontFamily: 'Al-Jazeera',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to login page
            },
            child: Text(
              'حسناً',
              style: TextStyle(
                fontFamily: 'Al-Jazeera',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'حسناً',
              style: TextStyle(
                fontFamily: 'Al-Jazeera',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primeryColor = Color.fromRGBO(234, 30, 73, 1);
    Color soecondColor = Color.fromARGB(255, 255, 160, 61);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primeryColor,
          title: const Text(
            'نسيت كلمة المرور',
            style: TextStyle(
              fontFamily: 'Al-Jazeera',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primeryColor),
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: soecondColor, // Set the background color
                ),
                onPressed: resetPassword,
                child: Text('إرسال رابط إعادة تعيين كلمة المرور'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
