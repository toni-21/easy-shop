import 'package:easy_shop/controllers/appcontroller.dart';
import 'package:easy_shop/controllers/authcontroller.dart';
import 'package:easy_shop/models/cart_item.dart';
import 'package:easy_shop/pages/checkout.dart';
import 'package:easy_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Cart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartState();
  }
}

class _CartState extends State<Cart> {
  List<CartItem> cartList = [];
  final appCtrl = Get.put(AppController());
  final authCtrl = Get.put(AuthController());

  @override
  void initState() {
    populateList();
    super.initState();
  }

  void populateList() async {
    cartList = await appCtrl.getCart(
        userId: authCtrl.user.id!,
        orderId: appCtrl.orderId,
        token: authCtrl.user.token!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 45, left: 18, right: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: deepPurple,
                size: 27,
              ),
            ),
            Row(
              children: [
                Text(
                  "My Cart",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: deepPurple,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Checkout(),
                      ),
                    );
                  },
                  child: Text(
                    "Proceed to Checkout",
                  ),
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    primary: darkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Flexible(
              child: ListView.builder(
                itemCount: cartList.length,
                itemBuilder: (context, i) {
                  CartItem cartItem = cartList[i];
                  return Row(
                    children: [
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://loremflickr.com/320/240"),
                              fit: BoxFit.cover),
                          border: Border.all(
                            width: 2,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                        margin: EdgeInsets.only(bottom: 20),
                        width: 120,
                        height: 120,
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                        margin: EdgeInsets.only(bottom: 20),
                        width: 180,
                        height: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "MXN3347FMS",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Honeywell spaghetti",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Quantity: 2",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "\$${cartItem.amount}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
