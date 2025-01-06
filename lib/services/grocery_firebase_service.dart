import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_buddy/models/grocery_item.dart';
import 'package:intl/intl.dart';

class GroceryFirebaseService {
  final CollectionReference _groceryCollection =
      FirebaseFirestore.instance.collection("grocery");

  Future<void> saveGroceryList(
      BuildContext context, List<GroceryItem> groceryList, String? uid) async {
    if (uid == null) {
      print("User is not logged in. Cannot save grocery list.");
      return;
    }

    // Format today's date
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    DocumentReference userDoc = _groceryCollection.doc(uid);

    try {
      print("Attempting to save grocery list...");

      // Prepare the map structure for the current date
      Map<String, dynamic> dateMap = {
        formattedDate: groceryList.map((item) => item.toJson()).toList()
      };

      // Update the document, merging the new data with existing data
      await userDoc.set({"groceryData": dateMap}, SetOptions(merge: true));

      print("Grocery list saved successfully for user $uid!");
    } catch (e) {
      print("Failed to save grocery list: $e");
    }
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchGroceryHistory(
      String uid) async {
    final docRef = FirebaseFirestore.instance.collection('grocery').doc(uid);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      final groceryData = data?['groceryData'] as Map<String, dynamic>;

      // Group by date
      return groceryData.map((date, items) {
        final itemList = List<Map<String, dynamic>>.from(items as List);
        return MapEntry(date, itemList);
      });
    } else {
      throw Exception('Document does not exist');
    }
  }
}
