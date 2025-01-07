import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_buddy/provider/hive_provider.dart';
import 'package:shopping_buddy/screens/home_screen.dart';
import 'package:shopping_buddy/services/authentication_service.dart';
import 'package:shopping_buddy/utils/utill_functions.dart';

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
      print("true+++++++++++++++++++++$uid");
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
    UtillFunctions().snackbar(
      "User Logout Successfully",
      "",
    );

    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      final emailRegEx = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (!emailRegEx.hasMatch(email)) {
        UtillFunctions().snackbar(
          "Error",
          "Please enter a valid email address",
        );

        return;
      }
      if (password.isEmpty || password.length <= 6) {
        UtillFunctions().snackbar(
          "Error",
          "Please enter valid password min 6 charactors",
        );

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
      UtillFunctions().snackbar(
        "Logging Success",
        "",
      );

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      UtillFunctions().snackbar(
        "Error message",
        e.code,
      );

      print("Some error are occur in Authentication Provider $e");
      rethrow;
    } catch (e) {
      UtillFunctions().snackbar(
        "Error message",
        e.toString(),
      );
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

      Future.delayed(Duration.zero, () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false);
      });
      UtillFunctions().snackbar(
        "Logging Success",
        "",
      );
      notifyListeners();
    } catch (e) {
      print("$e");
    } finally {
      setLoadingStatus(false);
    }
  }

  Future<void> signUp(
      BuildContext context, String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        UtillFunctions().snackbar(
          "Error",
          "All fields are required!",
        );

        return;
      }
      final emailRegEx = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (!emailRegEx.hasMatch(email)) {
        UtillFunctions().snackbar(
          "Error",
          "Please enter a valid email address",
        );
        return;
      }
      if (password.isEmpty || password.length < 6) {
        UtillFunctions().snackbar(
          "Error",
          "Please enter valid password min 6 charactors",
        );
        return;
      }
      setLoadingStatus(true);
      User? user = await _authService.signUp(email.trim(), password.trim());
      setUser(user);
      setLogginStatus(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', user!.uid);
      setUid(user.uid);
      UtillFunctions().snackbar(
        "Success",
        "Account created successfully!",
      );

      Future.delayed(Duration.zero, () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false);
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.code == 'email-already-in-use') {
        errorMessage = "The email address is already in use by another account";
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      Future.delayed(Duration.zero, () {
        UtillFunctions().snackbar(
          "Error",
          errorMessage,
        );
      });
    } finally {
      setLoadingStatus(false);
    }
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    if (email.isEmpty) {
      UtillFunctions().snackbar(
        "Error",
        "Please enter your email",
      );
      return;
    }
    final emailRegEx = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegEx.hasMatch(email)) {
      UtillFunctions().snackbar(
        "Error",
        "Please enter a valid email address",
      );
      return;
    }
    setLoadingStatus(true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.trim(),
      );
      UtillFunctions().snackbar(
        "Success",
        "Password reset link sent to your email!",
      );
      Future.delayed(Duration.zero, () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false);
      });
    } on FirebaseAuthException catch (e) {
      UtillFunctions().snackbar(
        "Error",
        e.message ?? "Something went wrong",
      );
    } finally {
      setLoadingStatus(false);
    }
  }
}
