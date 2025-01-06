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
}
