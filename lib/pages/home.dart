import 'package:easy_shop/controllers/appcontroller.dart';
import 'package:easy_shop/controllers/authcontroller.dart';
import 'package:easy_shop/pages/cart.dart';
import 'package:easy_shop/pages/checkout.dart';
import 'package:easy_shop/pages/fund_wallet.dart';
import 'package:http/retry.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_shop/models/product.dart';
import 'package:easy_shop/utils/utils.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final appCtrl = Get.put(AppController());
  final authCtrl = Get.put(AuthController());

  Widget productsGridView({required List productList, token, id}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: productList.length,
        itemBuilder: (BuildContext context, int index) {
          final Product product = productList[index];

          return Container(
            height: 200,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    child: Image.network(
                      "https://loremflickr.com/320/240",
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            product.name,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          product.quantity.toString(),
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: deepPurple),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          "\$${product.price}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              product.quantity = product.quantity + 1;
                              print("Added");
                            });
                          },
                          icon: Icon(Icons.add_rounded),
                          padding: EdgeInsets.all(0),
                          // alignment:Alignment.bottomRight,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final String response = await appCtrl.addToCart(
                              token: authCtrl.user.token!,
                              userId: authCtrl.user.id!,
                              productId: product.id,
                              quantity: product.quantity);
                          if (response == "success") {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                    "Item has been addedto the cart"),
                                content: Text(response),
                                actions: <Widget>[
                                  SizedBox(
                                    height: 45,
                                    width: 150,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Back to Home"),
                                      style: ElevatedButton.styleFrom(
                                        textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        primary: darkBlue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                        },
                        child: Text("Add to Cart"),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          primary: deepPink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double wallet = authCtrl.user.wallet!;
    String name = authCtrl.user.name!;
    return GetBuilder<AppController>(
        init: AppController(),
        builder: (appCtrl) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Easy Shop",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Cart()),
                    );
                  },
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    size: 23,
                  ),
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Good day, \n$name",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Available balance is \n\$$wallet",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 7),
                          SizedBox(
                            height: 36,
                            width: 124,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FundWallet(wallet: wallet)),
                                );
                              },
                              child: Text("Fund Wallet"),
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                primary: darkBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Flexible(
                    child: FutureBuilder(
                        future: appCtrl.productsListing(
                          token: authCtrl.user.token!,
                          id: authCtrl.user.id!,
                        ),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Product>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            final productsListing = snapshot.data ?? [];
                            return productsGridView(
                                productList: productsListing);
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
