import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopping_buddy/models/grocery_item.dart';

class HiveHelper {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GroceryItemAdapter());
  }

  static Future<Box<GroceryItem>> openBox() async {
    return await Hive.openBox<GroceryItem>('groceryBox');
  }

  static Future<List<GroceryItem>> getGroceryItems() async {
    var box = await openBox();
    return box.values.toList();
  }

  static Future<void> addGroceryItem(GroceryItem item) async {
    var box = await openBox();
    await box.add(item);
  }

  // Update count and isCheck for an item
  static Future<void> updateGroceryItem(
      int index, double count, bool isCheck) async {
    var box = await openBox();
    var existingItem = box.getAt(index);
    if (existingItem != null) {
      // Create a new instance with updated values
      var updatedItem = GroceryItem(
        name: existingItem.name, // Keep the name the same
        count: count,
        isCheck: isCheck,
      );
      await box.putAt(index, updatedItem); // Update the item in the box
    }
  }

  static Future<void> deleteGroceryItem(int index) async {
    var box = await openBox();
    await box.deleteAt(index);
  }
}
