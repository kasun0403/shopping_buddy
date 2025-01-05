import 'package:hive/hive.dart';

part 'grocery_item.g.dart';

@HiveType(typeId: 0)
class GroceryItem {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final double count;
  @HiveField(2)
  final bool isCheck;

  GroceryItem({
    required this.name,
    required this.count,
    this.isCheck = false,
  });
  GroceryItem copyWith({String? name, double? count, bool? isCheck}) {
    return GroceryItem(
      name: name ?? this.name,
      count: count ?? this.count,
      isCheck: isCheck ?? this.isCheck,
    );
  }
}
