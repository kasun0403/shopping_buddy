import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_buddy/provider/authentication_provider.dart';
import 'package:shopping_buddy/provider/firebase_provider.dart';
import 'package:shopping_buddy/screens/authentication/login_screen.dart';
import 'package:shopping_buddy/screens/history_data_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'HISTORY',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Provider.of<AuthenticationProvider>(context, listen: false).isLoggedIn
              ? FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
                  future: Provider.of<FirebaseProvider>(context, listen: false)
                      .fetchGroceryHistory(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.scaleDown,
                                  image: AssetImage(
                                    "assets/images/logo1.png",
                                  ),
                                ),
                              ),
                              child: const CircularProgressIndicator(
                                  color: Colors.redAccent)),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return const Center(child: Text('No history found.'));
                    }

                    final history = snapshot.data!;

                    return Expanded(
                      child: ListView.builder(
                        itemCount: history.keys.length,
                        itemBuilder: (context, index) {
                          final date = history.keys.elementAt(index);
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2.5),
                            decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              title: Text(
                                date,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              tileColor: Colors.transparent,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HistoryDataScreen(
                                      date: date,
                                      items: history[date]!,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          textAlign: TextAlign.center,
                          "User still not login Please Login to the SHOPPING BUDDY to view your history",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.login),
                          label: const Text('Log in'),
                        ),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
