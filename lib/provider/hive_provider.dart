import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveProvider with ChangeNotifier {
  List<String> _goodsList = [];

  // Getter for goodsList
  List<String> get goodsList => _goodsList;

  // Load the grocery list from Hive
  Future<void> loadGoodsFromHive() async {
    var box = await Hive.openBox('groceryBox');
    List<dynamic> storedGoods = box.get('goods', defaultValue: []);
    _goodsList = List<String>.from(storedGoods);
    notifyListeners();
  }

  // Save grocery list temporarily using Hive
  Future<void> saveTemporarily(List<String> goodsList) async {
    var box = await Hive.openBox('groceryBox');
    await box.put('goods', goodsList);
    notifyListeners();
  }

  // Add a new grocery item to the list
  void addGroceryItem(String item) {
    _goodsList.add(item);
    _updateHive();
    notifyListeners();
  }

  // Remove a grocery item from the list
  void removeGroceryItem(int index) {
    _goodsList.removeAt(index);
    _updateHive();
    notifyListeners();
  }

  // Helper method to update the Hive box after any change in the list
  Future<void> _updateHive() async {
    var box = await Hive.openBox('groceryBox');
    await box.put('goods', _goodsList); // Save the updated list to Hive
  }
}
