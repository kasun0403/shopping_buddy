import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_buddy/provider/authentication_provider.dart';
import 'package:shopping_buddy/screens/authentication/login_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'HISTORY',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Provider.of<AuthenticationProvider>(context, listen: false).isLoggedIn
              ? const SizedBox()
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
                                ));
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
