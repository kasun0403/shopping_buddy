import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_buddy/models/grocery_item.dart';
import 'package:shopping_buddy/provider/authentication_provider.dart';
import 'package:shopping_buddy/services/grocery_firebase_service.dart';

class FirebaseProvider extends ChangeNotifier {
  final GroceryFirebaseService _firebaseService = GroceryFirebaseService();
  List<GroceryItem> _groceryList = [];

  List<GroceryItem> get groceryList => _groceryList;

  Future<void> addGroceryItemList(
      BuildContext context, List<GroceryItem> item) async {
    User? uid =
        Provider.of<AuthenticationProvider>(context, listen: false).getUser;
    await _firebaseService.saveGroceryList(context, item, uid!.uid);
    notifyListeners();
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchGroceryHistory(
      BuildContext context) async {
    User? uid =
        Provider.of<AuthenticationProvider>(context, listen: false).getUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? prefuid = prefs.getString('uid');

    Map<String, List<Map<String, dynamic>>> groupedByDate =
        await _firebaseService
            .fetchGroceryHistory(uid == null ? prefuid! : uid.uid);
    return groupedByDate;
  }
}
