import 'package:hive/hive.dart';
import 'package:shopping_buddy/models/grocery_item.dart';

class GroceryHiveService {
  final String boxName = 'groceryBox';

  Future<List<GroceryItem>> loadGroceryList() async {
    var box = await Hive.openBox<GroceryItem>(boxName);
    return box.values.toList();
  }

  Future<void> addGroceryItem(GroceryItem item) async {
    var box = await Hive.openBox<GroceryItem>(boxName);
    await box.add(item);
  }

  Future<void> updateGroceryItem(int index, GroceryItem item) async {
    var box = await Hive.openBox<GroceryItem>(boxName);
    await box.putAt(index, item);
  }

  Future<void> removeGroceryItem(int index) async {
    var box = await Hive.openBox<GroceryItem>(boxName);
    await box.deleteAt(index);
  }

  Future<void> clearGroceryList() async {
    var box = await Hive.openBox<GroceryItem>(boxName);
    await box.clear();
  }
}
