import 'package:flutter/material.dart';

class HistoryDataScreen extends StatelessWidget {
  final String date;
  final List<Map<String, dynamic>> items;

  const HistoryDataScreen({required this.date, required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details for $date'.toUpperCase()),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
            decoration: BoxDecoration(
                color: item['isCheck'] == true
                    ? Colors.green.withOpacity(0.6)
                    : Colors.redAccent.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(
                item['name'] ?? 'Unknown',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '${(item['count'] as num).toStringAsFixed(2)} ${item['measurement']}',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600),
              ),
              trailing: item['isCheck'] == true
                  ? const Icon(
                      Icons.check_box,
                      color: Colors.white,
                    )
                  : const SizedBox(),
            ),
          );
        },
      ),
    );
  }
}
