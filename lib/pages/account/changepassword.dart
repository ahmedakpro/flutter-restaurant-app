import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String _errorText = '';
  bool isStrongPassword(String password) {
    // Define your password strength criteria here
    // For example, at least 8 characters with a mix of letters, numbers, and symbols
    RegExp regex =
        RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~%^!/?|]).{8,}$');
    return regex.hasMatch(password);
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        final credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: _oldPasswordController.text,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(_newPasswordController.text);
        _showSuccessDialog();
      } catch (error) {
        setState(() {
          _errorText = 'كلمة المرور القديمة غير صحيحة';
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تم تغيير كلمة المرور بنجاح'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('حسناً'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.black;
    Color primeryColor = Color.fromRGBO(234, 30, 73, 1);
    Color soecondColor = Color.fromARGB(255, 255, 160, 61);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primeryColor,
          title: Text(
            'تغيير كلمة المرور',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Al-Jazeera',
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: soecondColor,
                          width:
                              2), // Set the color of the bottom line when the field is focused
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primeryColor),
                        borderRadius: BorderRadius.circular(15)),
                    labelText: 'كلمة المرور القديمة',
                    labelStyle: TextStyle(
                      fontFamily: 'Al-Jazeera',
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'يرجى إدخال كلمة المرور القديمة';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: soecondColor,
                          width:
                              2), // Set the color of the bottom line when the field is focused
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primeryColor),
                        borderRadius: BorderRadius.circular(15)),
                    labelText: 'كلمة المرور الجديدة',
                    labelStyle: TextStyle(
                      fontFamily: 'Al-Jazeera',
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'يرجى إدخال كلمة المرور الجديدة';
                    }
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: soecondColor,
                          width:
                              2), // Set the color of the bottom line when the field is focused
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primeryColor),
                        borderRadius: BorderRadius.circular(15)),
                    labelText: 'تأكيد كلمة المرور',
                    labelStyle: TextStyle(
                      fontFamily: 'Al-Jazeera',
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'يرجى تأكيد كلمة المرور';
                    }
                    if (value != _newPasswordController.text) {
                      return 'كلمة المرور غير متطابقة';
                    }

                    if (!isStrongPassword(_newPasswordController.text)) {
                      return "يجب تعيين كلمة مرور تحتوي على رموز وحروف وارقام كبيرة وصغيرة "
                          'A-f-0_9-@^&'
                          "";
                    }

                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: soecondColor, // Set the background color
                  ),
                  onPressed: _changePassword,
                  child: Text(
                    'تغيير كلمة المرور',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Al-Jazeera',
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _errorText,
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Al-Jazeera',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
