import "dart:convert";
import 'package:easy_shop/models/user.dart';
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import 'package:easy_shop/utils/constants.dart';

class AuthController extends GetxController {
  bool _isLoading = false;
  User? _authenticatedUser;
  String? otp;
  String? myName;

  bool get isLoading {
    return _isLoading;
  }

  User get user {
    return _authenticatedUser!;
  }

  void setWallet(double amount) {
    _authenticatedUser!.wallet = amount;
    update();
  }

  Future<String> signUp(
      {required String name,
      required String email,
      required String password}) async {
    print("$name is name, $password is password, $email is email");
    _isLoading = true;
    update();
    Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "password": password,
    };
    try {
      final response = await http.post(
        Uri.parse(AppConfig.signup),
        body: body,
      );
      print(response.body);
      final decodedResponse = json.decode(response.body);
      _isLoading = false;
      update();
      Map<String, dynamic>? userData = decodedResponse["user"];
      Map<String, dynamic> data = userData == null ? {} : userData["data"];
      bool success = userData == null ? false : userData["success"];

      if (success) {
        print("SIGNUP SUCCESSFUL");
        otp = data["otp"];
        myName = name;
        return "success";
      } else {
        print("SIGNUP FAILED");
        List errors = decodedResponse["errors"];
        Map<String, dynamic> minidata = errors[0];
        String message = minidata["msg"];
        return message;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> verify({required String email, required String otp}) async {
    print("$otp is otp, $email is email");
    _isLoading = true;
    update();
    Map<String, dynamic> body = {
      "otp": otp,
      "email": email,
    };
    try {
      final response = await http.post(
        Uri.parse(AppConfig.verify),
        body: body,
      );
      print(response.body);
      final decodedResponse = json.decode(response.body);
      _isLoading = false;
      update();
      Map<String, dynamic>? userData = decodedResponse["user"];
      bool success = userData == null ? false : userData["success"];

      if (success) {
        print("VERIFICATION SUCCESSFUL");
        return "success";
      } else {
        print("VERIFICATION FAILED");
        String message =
            userData == null ? "Something went wrong" : userData["message"];
        return message;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> login(
      {required String email, required String password}) async {
    print("$password is password, $email is email");
    _isLoading = true;
    update();
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };
    try {
      final response = await http.post(
        Uri.parse(AppConfig.login),
        body: body,
      );
      print(response.body);
      final decodedResponse = json.decode(response.body);
      _isLoading = false;
      update();
      Map<String, dynamic>? userData = decodedResponse["user"];
      Map<String, dynamic> data = userData == null ? {} : userData["data"];
      bool success = userData == null ? false : userData["success"];

      if (success) {
        print("LOGIN SUCCESSFUL");
        String id = data["userId"];
        String token = data["token"];
        _authenticatedUser = User(
          id: id,
          name: myName ?? "User",
          email: email,
          token: token,
          wallet: 0,
        );
        return "success";
      } else {
        print("SIGNUP FAILED");
        String message =
            userData == null ? "Something went wrong" : userData["message"];
        return message;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
