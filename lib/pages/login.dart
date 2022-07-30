import 'package:easy_shop/controllers/authcontroller.dart';
import 'package:easy_shop/pages/home.dart';
import 'package:easy_shop/pages/signup.dart';
import 'package:easy_shop/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final authCtrl = Get.put(AuthController());
  bool obsecureText = false;
  bool? termsAccepted = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _submitForm(context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    String response = await authCtrl.login(
        email: emailController.text, password: passwordController.text);
    if (response == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
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
                        "Sign In",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: darkBlue,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Login with your credentials to proceed",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: midBlue,
                        ),
                      ),
                      SizedBox(height: 45),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Email Address",
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
                            if (value == null ||
                                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                    .hasMatch(value)) {
                              return 'Enter a valid email address';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 25),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: obsecureText,
                          decoration: InputDecoration(
                            hintText: "Password",
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: deepPurple),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              icon: obsecureText
                                  ? Icon(CupertinoIcons.eye_slash, size: 25)
                                  : Icon(CupertinoIcons.eye, size: 25),
                              onPressed: () {
                                setState(() {
                                  obsecureText = !obsecureText;
                                });
                              },
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.length < 5) {
                              return 'password is incorrect';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(height: 30),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _submitForm(context);
                          },
                          child: Text("Continue"),
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
                            "Don't have have an account? - ",
                            style: TextStyle(
                              fontSize: 15,
                              color: midBlue,
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              "Signup",
                              style: TextStyle(
                                color: midBlue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ),
                              );
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
