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
  @HiveField(3)
  final String measurement;

  GroceryItem({
    required this.name,
    required this.count,
    this.isCheck = false,
    required this.measurement,
  });

  GroceryItem copyWith(
      {String? name, double? count, bool? isCheck, String? measurement}) {
    return GroceryItem(
      name: name ?? this.name,
      count: count ?? this.count,
      isCheck: isCheck ?? this.isCheck,
      measurement: measurement ?? this.measurement,
    );
  }
}
