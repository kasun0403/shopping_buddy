import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_buddy/provider/hive_provider.dart';
import 'package:shopping_buddy/screens/home_screen.dart';
import 'package:shopping_buddy/services/authentication_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthenticationService _authService = AuthenticationService();
  bool _isLoggedIn = false;
  bool _isLoading = false;
  User? _user;
  String? _uid;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  User? get getUser => _user;
  String? get getUid => _uid;

  void setLogginStatus(bool status) {
    _isLoggedIn = status;
    notifyListeners();
  }

  void setUid(String uid) {
    _uid = uid;
    notifyListeners();
  }

  void setLoadingStatus(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    print(
        "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++$uid");
    if (uid != null && uid.isNotEmpty) {
      setLogginStatus(true);
      setUid(uid);
    } else {
      setLogginStatus(false);
      setUid("");
    }
  }

  void logout(BuildContext context) async {
    _authService.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    setLogginStatus(false);
    setUser(null);
    await Provider.of<GroceryProvider>(context, listen: false)
        .loadGroceryListFromHive();
    Get.snackbar("User Logout Successfully", "",
        snackPosition: SnackPosition.BOTTOM);
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty || password.length < 6) {
        Get.snackbar("Error", "Please enter valid credentials",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      setLoadingStatus(true);
      User? user =
          await _authService.signInWithEmailAndPassword(email, password);
      setUser(user);
      setLogginStatus(true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', user!.uid);
      setUid(user.uid);
      Future.delayed(Duration.zero, () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false);
      });

      Get.snackbar("Logging Success", "", snackPosition: SnackPosition.BOTTOM);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error message", e.code,
          snackPosition: SnackPosition.BOTTOM);
      print("Some error are occur in Authentication Provider $e");
      rethrow;
    } catch (e) {
      Get.snackbar("Error message", e.toString());
    } finally {
      setLoadingStatus(false);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      setLoadingStatus(true);

      User? user = await _authService.signInWithGoogle();
      setLogginStatus(true);

      setUser(user);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', user!.uid);
      setUid(user.uid);

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false);
      });

      Get.snackbar("Logging Success", "", snackPosition: SnackPosition.BOTTOM);
      notifyListeners();
    } catch (e) {
      print("$e");
    } finally {
      setLoadingStatus(false);
    }
  }
}
