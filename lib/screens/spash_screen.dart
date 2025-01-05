import 'package:flutter/material.dart';
import 'package:shopping_buddy/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHomeScreen();
  }

  // Function to navigate to HomeScreen after a delay
  _navigateToHomeScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // 3 seconds delay
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/logo1.png'),
      ),
    );
  }
}
