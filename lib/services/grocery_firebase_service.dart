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

    CollectionReference userGroceryCollection =
        _groceryCollection.doc(uid).collection(formattedDate);
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (GroceryItem item in groceryList) {
      // Use the item's name as the document ID
      DocumentReference docRef = userGroceryCollection.doc(item.name);
      batch.set(docRef, item.toJson());
    }

    try {
      print("Attempting to commit batch...");
      await batch.commit();
      print("Grocery list saved successfully for user $uid!");
    } catch (e) {
      print("Failed to save grocery list: $e");
    }
  }
}
