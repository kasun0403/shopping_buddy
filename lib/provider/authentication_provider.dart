import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_buddy/screens/home_screen.dart';
import 'package:shopping_buddy/services/authentication_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthenticationService _authService = AuthenticationService();
  bool _isLoggedIn = false;
  bool _isLoading = false;
  User? _user;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  User? get getUser => _user;

  void setLogginStatus(bool status) {
    _isLoggedIn = status;
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

  void logout() async {
    _authService.signOut();
    setLogginStatus(false);
    setUser(null);
    Get.snackbar("User Logout Successfully", "",
        snackPosition: SnackPosition.BOTTOM);
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      bool isValidPassword(String password) {
        return password.length >=
            6; // Ensure the password is at least 6 characters long
      }

      if (email.isEmpty || password.isEmpty) {
        Get.snackbar("Error", "Please fill in both fields",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      if (!isValidPassword(password)) {
        Get.snackbar("Error", "Password must be at least 6 characters",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      setLoadingStatus(true);
      User? user =
          await _authService.signInWithEmailAndPassword(email, password);
      setUser(user);
      setLogginStatus(true);

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

      await _authService.signInWithGoogle();
      setLogginStatus(true);

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
