import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopping_buddy/provider/authentication_provider.dart';
import 'package:shopping_buddy/provider/hive_provider.dart';
import 'authentication/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController countController = TextEditingController();
  int itemCount = 0;
  void _showAddGroceryDialog(BuildContext context) async {
    TextEditingController groceryController = TextEditingController();
    String? selectedGrocery;
    List<String> goodsList = [];

    // Load the JSON file
    final String response =
        await rootBundle.loadString('assets/json/goods.json');
    goodsList = List<String>.from(json.decode(response));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Add Grocery',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select from the list or add a custom item:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedGrocery,
                  isExpanded: true,
                  items: goodsList.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedGrocery = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Select item',
                    labelStyle: TextStyle(color: Colors.red.withOpacity(0.7)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.red), // Border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.red), // Focused border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.red), // Enabled border color
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Or enter a custom item:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: groceryController,
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                    hintText: 'Enter grocery item',
                    hintStyle: TextStyle(color: Colors.red.withOpacity(0.7)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.red), // Border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.red), // Focused border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.red), // Enabled border color
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Add the selected or custom item to the list
                final customGrocery = groceryController.text.trim();
                if (selectedGrocery != null) {
                  Provider.of<HiveProvider>(context, listen: false)
                      .addGroceryItem(selectedGrocery!);
                } else if (customGrocery.isNotEmpty) {
                  Provider.of<HiveProvider>(context, listen: false)
                      .addGroceryItem(customGrocery);
                }
                Navigator.of(context).pop();
              },
              child: const Text(
                'Add',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  // Show the save dialog (Temporary or Permanent)
  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Permanently'),
        content: const Text('Do you want to save good list permanently?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "NO.",
                style: TextStyle(color: Colors.red),
              )),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              bool isLoggedIn =
                  Provider.of<AuthenticationProvider>(context, listen: false)
                      .isLoggedIn;
              if (isLoggedIn) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Your Item list Saved Permanently!')));
              } else {
                // Navigate to login screen if not logged in
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }
            },
            child: const Text(
              'YES!',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Load data from Hive when the screen initializes
    Provider.of<HiveProvider>(context, listen: false).loadGoodsFromHive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 2,
        title: const Text(
          'SHOPPING BUDDY',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () => _showAddGroceryDialog(context),
            child: Row(
              children: [
                Image.asset("assets/images/tomato.png",
                    fit: BoxFit.scaleDown, height: 30),
                const Text(
                  'Add Groceries',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              Provider.of<AuthenticationProvider>(context, listen: false)
                  .logout();
            },
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      body: Column(
        children: [
          // Display the grocery list
          Expanded(
            child: Consumer<HiveProvider>(
              builder: (context, hiveProvider, child) {
                return hiveProvider.goodsList.isEmpty
                    ? const Center(child: Text('No groceries added yet.'))
                    : ListView.builder(
                        itemCount: hiveProvider.goodsList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              tileColor: Colors.transparent,
                              title: Text(
                                hiveProvider.goodsList[index],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  // Remove the item from the list
                                  hiveProvider.removeGroceryItem(index);
                                },
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSaveDialog(context), // Show the save dialog
        tooltip: 'Save List',
        child: const Icon(Icons.save),
      ),
    );
  }
}
