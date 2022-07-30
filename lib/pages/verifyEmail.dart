import 'package:easy_shop/controllers/authcontroller.dart';
import 'package:easy_shop/pages/login.dart';
import 'package:easy_shop/pages/signup.dart';
import 'package:easy_shop/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VerifyEmailState();
  }
}

class _VerifyEmailState extends State<VerifyEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void _submitForm(context) async {
    final authCtrl = Get.put(AuthController());
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    String response = await authCtrl.verify(
        email: emailController.text, otp: otpController.text);
    if (response == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("An error has occured"),
          content: Text(response),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                color: Colors.black.withOpacity(0.1),
                padding: const EdgeInsets.all(10),
                child: const Text("okay"),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authCtrl) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 50),
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Verify Email",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: darkBlue,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "The verification code has been sent to your email",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: midBlue,
                        ),
                      ),
                      SizedBox(height: 50),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: deepPurple),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null) {
                              return 'code is incorrect';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: otpController,
                          decoration: InputDecoration(
                            hintText: "Enter your 6-digit code",
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: deepPurple),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.length < 4) {
                              return 'code is incorrect';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 72),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _submitForm(context);
                          },
                          child: Text("Sign In"),
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                              primary: darkBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't get the verification code? ",
                            style: TextStyle(
                              fontSize: 15,
                              color: midBlue,
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              "Resend",
                              style: TextStyle(
                                color: midBlue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              //TODO: Implement resend OTP

                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => SignUp(),
                              //   ),
                              // );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                authCtrl.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container()
              ],
            ),
          ),
        );
      },
    );
  }
}
