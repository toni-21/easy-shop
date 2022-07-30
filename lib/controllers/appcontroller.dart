import "dart:convert";
import 'package:easy_shop/models/cart_item.dart';
import 'package:easy_shop/models/product.dart';
import 'package:flutter/cupertino.dart';
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import 'package:easy_shop/utils/constants.dart';

class AppController extends GetxController {
  List<Product> cart = [];
  String? _orderId;
  int _quantity = 0;

  int get quantity {
    return _quantity;
  }

  String get orderId {
    return _orderId ?? "dfg43erg";
  }

  void increaseQuantity(Product item) {
    print("ITEM QUANTITY IS: ${item.quantity}");
    _quantity = _quantity + 1;
    update;
  }

  Future<List<Product>> productsListing(
      {required String token, required String id}) async {
    print("STARTING!!!! ");
    print("USER TOKEN IS $token");
    print("USER ID IS $id");
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    try {
      final response = await http.get(
        Uri.parse("${AppConfig.user}$id/products"),
        headers: requestHeaders,
      );
      print(response.body);
      final decodedResponse = json.decode(response.body);
      Map<String, dynamic>? userData = decodedResponse["products"];
      List data = userData == null ? [] : userData["data"];
      bool success = userData == null ? false : userData["success"];

      if (success) {
        print("PRODUCT LIST SUCCESSFUL");

        List<Product> newList = [];

        for (int i = 0; i < data.length; i++) {
          var item = data[i];
          Product product = Product(
              id: item["_id"].toString(),
              name: item["name"].toString(),
              price: double.parse(item["price"].toString()));
          newList.add(product);
          print("ITEM ADDED");
        }
        return newList;
      } else {
        print("PRODUCT LIST FAILED");
        String message =
            userData == null ? "Something went wrong" : userData["message"];
        debugPrint(message);
        return [];
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<Map<String, dynamic>> fundWallet(
      {required String token,
      required String id,
      required String amount}) async {
    print("FUNDING!!!! ");
    print("USER TOKEN IS $token");
    print("USER ID IS $id");
    Map<String, String> requestHeaders = {"Authorization": "Bearer $token"};
    Map<String, dynamic> body = {
      "amount": amount,
    };
    try {
      final response = await http.put(
          Uri.parse("${AppConfig.fund}$id/recharge"),
          headers: requestHeaders,
          body: body);
      print(response.body);
      final decodedResponse = json.decode(response.body);
      Map<String, dynamic>? userData = decodedResponse["user"];
      Map<String, dynamic>? data = userData == null ? null : userData["data"];
      bool success = userData == null ? false : userData["success"];

      if (success) {
        print("WALLET FUND SUCCESSFUL");
        int wal = data!["wallet"];
        double wallet = wal.toDouble();
        Map<String, dynamic> map = {"message": "success", "wallet": wallet};
        print("Map returned");
        return map;
      } else {
        print("WALLET FUND FAILED");
        String message =
            userData == null ? "Something went wrong" : userData["message"];
        Map<String, dynamic> map = {"message": message, "wallet": null};
        return map;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> addToCart(
      {required String token,
      required String userId,
      required String productId,
      required int quantity}) async {
    print("CARTING!!! ");
    print("USER TOKEN IS $token");
    print("USER ID IS $userId");
    print("QUANTITY IS $quantity");
    Map<String, String> requestHeaders = {"Authorization": "Bearer $token"};
    Map<String, dynamic> body = {
      "userId": userId,
      "productId": productId,
      "quantity": quantity.toString(),
    };
    try {
      final response = await http.post(Uri.parse(AppConfig.addToCart),
          headers: requestHeaders, body: body);
      print(response.body);
      final decodedResponse = json.decode(response.body);
      Map<String, dynamic>? userData = decodedResponse["cart"];
      Map<String, dynamic>? data = userData == null ? null : userData["data"];
      bool success = userData == null ? false : userData["success"];

      if (success) {
        print("ITEM ADDED TO CART");
        _orderId = data!["orderId"];
        return "success";
      } else {
        print(" ADD TO CART FAILED");
        String message =
            userData == null ? "Something went wrong" : userData["message"];
        return message;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<List<CartItem>> getCart(
      {required String userId,
      required String orderId,
      required String token}) async {
    print("STARTING!!!! ");
    print("ORDER ID  IS $orderId");
    print("USER ID IS $userId");
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    try {
      final response = await http.get(
        Uri.parse("${AppConfig.user}$userId/cart?orderId=$orderId"),
        headers: requestHeaders,
      );
      print(response.body);
      final decodedResponse = json.decode(response.body);
      Map<String, dynamic>? userData = decodedResponse["cart"];
      List data = userData == null ? [] : userData["data"];
      bool success = userData == null ? false : userData["success"];

      if (success) {
        print("GET CART SUCCESSFUL");
        List<CartItem> newList = [];
        Map<String, dynamic> cartItemsMap = data[0];
        List cartItems = cartItemsMap["items"];
        for (int i = 0; i < cartItems.length; i++) {
          var item = cartItems[i];
          int wal = item["amount"];
          double wallet = wal.toDouble();
          CartItem product = CartItem(
            productId: item["productId"].toString(),
            quantity: item["quantity"],
            amount: wallet,
            unitId: item["amount"].toString(),
          );
          newList.add(product);
          print("ITEM ADDED");
        }
        return newList;
      } else {
        print("GET CART FAILED");
        String message =
            userData == null ? "Something went wrong" : userData["message"];
        debugPrint(message);
        return [];
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
