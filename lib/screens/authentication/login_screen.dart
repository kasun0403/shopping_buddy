import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_buddy/provider/authentication_provider.dart';
import 'package:shopping_buddy/screens/authentication/forget_pw.dart';
import 'package:shopping_buddy/screens/home_screen.dart';
import 'package:shopping_buddy/screens/authentication/sign_up.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent.shade200,
      body: Center(
        child: Consumer<AuthenticationProvider>(
          builder: (context, authProvider, child) {
            return authProvider.isLoading
                ? Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.scaleDown,
                        image: AssetImage(
                          "assets/images/logo1.png",
                        ),
                      ),
                    ),
                    child: const CircularProgressIndicator(color: Colors.white))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Container(
                        padding: const EdgeInsets.all(25.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo
                            const Icon(Icons.lock_outline_rounded,
                                size: 70, color: Colors.redAccent),
                            const SizedBox(height: 10),
                            const Text(
                              "SHOPPING BUDDY!",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Login in to application for get more benifits",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 20),
                            // Email Input
                            TextField(
                              cursorColor: Colors.red,
                              controller: email,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_rounded),
                                hintText: "Email Address",
                                filled: true,
                                fillColor: Colors.grey.shade300,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Password Input
                            TextField(
                              cursorColor: Colors.red,
                              controller: password,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline),
                                hintText: "Password",
                                filled: true,
                                fillColor: Colors.grey.shade300,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Get.to(const ForgotPW()),
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await Provider.of<AuthenticationProvider>(
                                          context,
                                          listen: false)
                                      .signInWithEmailAndPassword(
                                          context, email.text, password.text);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(15),
                                ),
                                child: const Text(
                                  "Log In",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Divider
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text("OR"),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            // Google Login Button
                            OutlinedButton.icon(
                              onPressed: () async {
                                await Provider.of<AuthenticationProvider>(
                                        context,
                                        listen: false)
                                    .signInWithGoogle(context);
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(15),
                                side: const BorderSide(
                                    color: Colors.redAccent, width: 1),
                              ),
                              icon: Image.asset(
                                "assets/images/google.png", // Add your google icon image
                                height: 20,
                                width: 20,
                              ),
                              label: const Text(
                                "Sign in with Google",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Mobile Login

                            const SizedBox(height: 10),
                            // Register Link
                            TextButton(
                              onPressed: () => Get.to(const SignUpPage()),
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: GoogleFonts.lato(
                                      textStyle:
                                          const TextStyle(color: Colors.black)),
                                  children: const [
                                    TextSpan(
                                      text: "Register now",
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            TextButton.icon(
                              style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                Colors.redAccent,
                              )),
                              icon: const Icon(
                                Icons.home,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                    (Route<dynamic> route) => false);
                              },
                              label: const Text(
                                "BACK TO HOME",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
