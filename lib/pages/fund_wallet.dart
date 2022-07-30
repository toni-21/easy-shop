import 'package:easy_shop/controllers/appcontroller.dart';
import 'package:easy_shop/controllers/authcontroller.dart';
import 'package:easy_shop/pages/home.dart';
import 'package:easy_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

class FundWallet extends StatefulWidget {
  final double wallet;
  const FundWallet({Key? key, required this.wallet}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _FundWalletState();
  }
}

class _FundWalletState extends State<FundWallet> {
  final authCtrl = Get.put(AuthController());
  final appCtrl = Get.put(AppController());
  final TextEditingController _amountController = TextEditingController();

  void _submitForm(BuildContext context) async {
    String token = authCtrl.user.token!;
    String id = authCtrl.user.id!;
    Map<String, dynamic> response = await appCtrl.fundWallet(
        token: token, id: id, amount: _amountController.text);
    if (response["message"] == "success") {
      authCtrl.setWallet(response["wallet"]);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Operation Success!"),
          content: Text(response["message"]),
          actions: <Widget>[
            SizedBox(
              height: 45,
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                child: Text("Back to Home"),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  primary: darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("An error has occured"),
          content: Text(response["message"]),
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          //height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 30, left: 18, right: 18),
          child: ListView(
            children: <Widget>[
              IconButton(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close,
                  color: deepPurple,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Fund Wallet",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: deepPurple,
                ),
              ),
              SizedBox(height: 15),
              Text(
                //"Available balance is \$${Provider.of<AuthProvider>(context, listen: false).user.balance!}",
                "Available balance is ${widget.wallet}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Use the form below to transfer money into your Easy shop account instantly",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 45),
              Text(
                "Type in the amount you wish to transfer",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    hintText: "e.g 5000",
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
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
                ),
              ),
              SizedBox(height: 75),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _submitForm(context);
                  },
                  child: Text("Add Funds"),
                  style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      primary: deepPurple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
