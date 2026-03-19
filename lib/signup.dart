import 'package:flutter/material.dart';
import 'login.dart';
import 'services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscured = true; // hidden by default
  bool _agreeToTerms = true;

  final Color _bgColor = const Color(0xFF231E1F);
  final Color _emailLabelColor = const Color(0xFFFFFFFF);
  final Color _pinkishLabelColor = const Color(0xFFFFDFDF);
  final Color _accentColor = const Color(0xFFFFBF00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //HERE
              Image.asset('images/logotop.png'),
              const SizedBox(height: 15),

              Text(
                "Your Email Address",
                style: TextStyle(color: _emailLabelColor, fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Enter your email",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),
              Text(
                "Choose a Password",
                style: TextStyle(color: _pinkishLabelColor, fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: _isObscured,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Enter password",
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: IconButton(
                      icon: Icon(
                        _isObscured
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.black,
                      ),
                      onPressed:
                          () => setState(() => _isObscured = !_isObscured),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "I agree with terms of use",
                    style: TextStyle(color: _pinkishLabelColor, fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
                    child: Icon(
                      _agreeToTerms
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: _agreeToTerms ? Colors.green : Colors.grey,
                      size: 28,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    // existing validations — hindi binago
                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill all fields"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (!_agreeToTerms) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("You must agree to terms of use"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // show loading while firebase creates the account
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder:
                          (_) => const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFFFBF00),
                            ),
                          ),
                    );

                    String? error = await signUp(email, password);

                    Navigator.pop(context); // close loading dialog

                    if (error == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Account created successfully!"),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );

                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 100, height: 1, color: Colors.white54),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "or",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Container(width: 100, height: 1, color: Colors.white54),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _socialButton("Google", Icons.g_mobiledata, Colors.red),
                  _socialButton("Facebook", Icons.facebook, Colors.blue),
                ],
              ),

              const SizedBox(height: 40),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      children: [
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(
                            color: _accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String label, IconData icon, Color iconColor) {
    return Container(
      width: 150,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
