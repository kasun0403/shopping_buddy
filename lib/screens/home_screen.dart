import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shopping_buddy/models/grocery_item.dart';
import 'package:shopping_buddy/provider/authentication_provider.dart';
import 'package:shopping_buddy/provider/hive_provider.dart';
import 'package:shopping_buddy/screens/history_screen.dart';
import 'authentication/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int itemCount = 0;
  List<GroceryItem> goodList = [];

  void _showAddGroceryDialog(BuildContext context) async {
    TextEditingController groceryController = TextEditingController();
    TextEditingController countController = TextEditingController();

    String selectedMeasurement = 'KG';
    List<String> measurements = ['KG', 'Packs', 'Liters', 'Units'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? errorMessage;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
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
                      'Enter the item name and quantity',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    TextField(
                      controller: groceryController,
                      cursorColor: Colors.red,
                      decoration: InputDecoration(
                        hintText: 'item name',
                        hintStyle:
                            TextStyle(color: Colors.red.withOpacity(0.7)),
                        // errorText: errorMessage,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.red), // Border color
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
                    const SizedBox(height: 10),
                    TextField(
                      controller: countController,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.red,
                      decoration: InputDecoration(
                        errorText: errorMessage,
                        hintText: 'item quantity',
                        hintStyle:
                            TextStyle(color: Colors.red.withOpacity(0.7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedMeasurement,
                      decoration: InputDecoration(
                        hintText: 'Select measurement',
                        hintStyle:
                            TextStyle(color: Colors.red.withOpacity(0.7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                      items: measurements.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style:
                                TextStyle(color: Colors.red.withOpacity(0.7)),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMeasurement = newValue!;
                        });
                      },
                      dropdownColor:
                          Colors.white, // Matches the dialog's background color
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
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
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
                    final customGrocery = groceryController.text.trim();
                    final countText = countController.text.trim();
                    final groceryItem = GroceryItem(
                      name: customGrocery,
                      count: double.tryParse(countText) ?? 0,
                      measurement: selectedMeasurement,
                    );
                    var groceryListItem =
                        Provider.of<GroceryProvider>(context, listen: false)
                            .groceryList;
                    if (groceryListItem
                        .any((item) => item.name == customGrocery)) {
                      setState(() {
                        errorMessage = 'Item already added to the list.';
                      });
                    } else if (customGrocery.isNotEmpty &&
                        countText.isNotEmpty) {
                      Provider.of<GroceryProvider>(context, listen: false)
                          .addGroceryItem(groceryItem);
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        errorMessage = 'Please enter all fields.';
                      });
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
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
    Provider.of<GroceryProvider>(context, listen: false).clearGroceryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                Image.asset("assets/images/logo1.png",
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
            child: Consumer<GroceryProvider>(
              builder: (context, hiveProvider, child) {
                return hiveProvider.groceryList.isEmpty
                    ? const Center(child: Text('No groceries added yet.'))
                    : ListView.builder(
                        itemCount: hiveProvider.groceryList.length,
                        itemBuilder: (context, index) {
                          goodList = hiveProvider.groceryList;
                          bool isCheck =
                              hiveProvider.groceryList[index].isCheck;
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: isCheck
                                  ? Colors.green.withOpacity(0.6)
                                  : Colors.redAccent.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              onTap: () {
                                hiveProvider.toggleCheck(index);
                              },
                              tileColor: Colors.transparent,
                              title: Text(
                                hiveProvider.groceryList[index].name,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                ("item quantity: ${hiveProvider.groceryList[index].count.toStringAsFixed(0)} ${hiveProvider.groceryList[index].measurement}"),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              trailing: SizedBox(
                                width: 80,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    isCheck
                                        ? Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: const Icon(
                                              Icons.check_circle,
                                              color: Colors.green, // Tick icon
                                            ),
                                          )
                                        : const SizedBox(
                                            width: 30,
                                          ),
                                    GestureDetector(
                                      onTap: () {
                                        // Remove the item from the list
                                        hiveProvider.removeGroceryItem(index);
                                        Get.snackbar(
                                            "${hiveProvider.groceryList[index].name} Item Deleted",
                                            "",
                                            snackPosition:
                                                SnackPosition.BOTTOM);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        // width: 15,
                                        child: const Icon(
                                          Icons.delete_sharp,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Container(
              //   // width: 50,
              //   decoration: BoxDecoration(
              //       color: Colors.red,
              //       borderRadius: BorderRadius.circular(100)),
              //   padding: const EdgeInsets.all(8),
              //   margin: const EdgeInsets.all(8.0),
              //   child: const Icon(
              //     Icons.history,
              //     size: 30,
              //     color: Colors.white,
              //   ),
              // ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                color: Colors.transparent,
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HistoryScreen(),
                        ));
                  },
                  icon: const Icon(Icons.history),
                  label: const Text('History'),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                color: Colors.transparent,
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    String title = "**Grocery List**".toUpperCase();

                    String grocery =
                        "$title\n\n${goodList.map((item) => "${item.name} - items: ${item.count.toStringAsFixed(0)}").join('\n')}";

                    try {
                      ByteData byteData =
                          await rootBundle.load('assets/images/logo1.png');

                      // Convert ByteData to Uint8List
                      final Uint8List pngBytes = byteData.buffer.asUint8List();

                      // Save image to temporary directory
                      final directory = await getTemporaryDirectory();
                      final path = "${directory.path}/grocery_lists.png";
                      File(path).writeAsBytesSync(pngBytes);

                      // Share the image and text
                      await Share.shareXFiles([XFile(path)], text: grocery);
                      // await Share.share(
                      //   grocery, // The list of items as text
                      // );
                    } catch (e) {
                      print("Error sharing: $e");
                    }
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                color: Colors.transparent,
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () => _showSaveDialog(context),
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _showSaveDialog(context), // Show the save dialog
      //   tooltip: 'Save List',
      //   child: const Icon(Icons.save),
      // ),
    );
  }
}
