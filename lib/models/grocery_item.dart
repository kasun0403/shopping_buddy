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

  // New fields for Firebase
  @HiveField(4)
  final String? title;
  @HiveField(5)
  final DateTime? createdDate;

  GroceryItem({
    required this.name,
    required this.count,
    this.isCheck = false,
    required this.measurement,
    this.title,
    this.createdDate,
  });

  GroceryItem copyWith({
    String? name,
    double? count,
    bool? isCheck,
    String? measurement,
    String? title,
    DateTime? createdDate,
  }) {
    return GroceryItem(
      name: name ?? this.name,
      count: count ?? this.count,
      isCheck: isCheck ?? this.isCheck,
      measurement: measurement ?? this.measurement,
      title: title ?? this.title,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  // Convert GroceryItem to a map for Firebase
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'count': count,
      'isCheck': isCheck,
      'measurement': measurement,
      'title': title,
      'createdDate':
          createdDate != null ? createdDate!.toIso8601String() : null,
    };
  }

  // Create a GroceryItem from a map (from Firebase)
  factory GroceryItem.fromJson(Map<String, dynamic> map) {
    return GroceryItem(
      name: map['name'],
      count: map['count'],
      isCheck: map['isCheck'],
      measurement: map['measurement'],
      title: map['title'],
      createdDate: DateTime.parse(map['createdDate']),
    );
  }
}
