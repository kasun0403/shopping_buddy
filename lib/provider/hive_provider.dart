import 'package:flutter/material.dart';
import 'package:shopping_buddy/models/grocery_item.dart';
import 'package:shopping_buddy/services/grocery_hive_service.dart';

class GroceryProvider with ChangeNotifier {
  final GroceryHiveService _hiveService = GroceryHiveService();
  List<GroceryItem> _groceryList = [];

  List<GroceryItem> get groceryList => _groceryList;

  Future<void> loadGroceryListFromHive() async {
    _groceryList = await _hiveService.loadGroceryList();
    notifyListeners();
  }

  Future<void> addGroceryItem(GroceryItem item) async {
    await _hiveService.addGroceryItem(item);
    await loadGroceryListFromHive(); // Refresh list after adding
  }

  Future<void> updateGroceryItem(
      int index, double count, bool isCheck, String measurement) async {
    var existingItem = _groceryList[index];
    var updatedItem = GroceryItem(
        name: existingItem.name,
        count: count,
        isCheck: isCheck,
        measurement: measurement);
    await _hiveService.updateGroceryItem(index, updatedItem);
    await loadGroceryListFromHive(); // Refresh list after updating
  }

  Future<void> removeGroceryItem(int index) async {
    await _hiveService.removeGroceryItem(index);
    await loadGroceryListFromHive(); // Refresh list after removing
  }

  Future<void> clearGroceryList() async {
    await _hiveService.clearGroceryList();
    _groceryList.clear();
    notifyListeners();
  }

  Future<void> toggleCheck(int index) async {
    final item = groceryList[index];
    final updatedItem = item.copyWith(
      isCheck: !item.isCheck,
    );
    await _hiveService.updateGroceryItem(index, updatedItem);
    groceryList[index] = updatedItem;
    notifyListeners();
  }
}
