import 'package:hive/hive.dart';

part 'grocery_item.g.dart';

@HiveType(typeId: 0)
class GroceryItem {
  @HiveField(0)
  final String name;

  GroceryItem({required this.name});
}
