import 'package:flutter/material.dart';
import 'main.dart';
import 'signup.dart';
import 'services/sheets_service.dart';   // para ma-access yung checkLogin()
import 'services/session_service.dart';  // ← DINAGDAG: para ma-save ang session


class TipNavApp extends StatelessWidget {
  const TipNavApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TipNav App',
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscured = true;
  bool _rememberMe = true;

  final Color _bgColor = const Color(0xFF231E1F);
  final Color _emailLabelColor = const Color(0xFFFFFFFF);
  final Color _passwordLabelColor = const Color(0xFFFFDFDF);
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
              Image.asset('images/logotop.png'),                             //HERE YUNG IMAGE
              const SizedBox(height: 15),
              Text(
                "Email",
                style: TextStyle(
                  color: _emailLabelColor,
                  fontSize: 16,
                  height: 1.0,
                ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Password",
                    style: TextStyle(
                      color: _passwordLabelColor,
                      fontSize: 16,
                      height: 1.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: _accentColor,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              TextField(
                controller: passwordController,
                obscureText: _isObscured,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter password",
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: IconButton(
                      icon: Icon(
                        _isObscured
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () =>
                          setState(() => _isObscured = !_isObscured),
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Remember me next time",
                    style: TextStyle(color: _passwordLabelColor, fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _rememberMe = !_rememberMe),
                    child: Icon(
                      _rememberMe
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: _rememberMe ? Colors.green : Colors.grey,
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

                  // ============================================
                  // BINAGO: dinagdag ang saveSession() pagkatapos
                  // mag-login para hindi na kailangan mag-login ulit
                  // pag na-close at binuksan ulit ang app
                  // ============================================
                  onPressed: () async {
                    String email    = emailController.text.trim();
                    String password = passwordController.text.trim();

                    // wag hayaang blangko
                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill in all fields"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // show loading habang nag-che-check sa sheet
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFFBF00),
                        ),
                      ),
                    );

                    bool isValid = await checkLogin(email, password);

                    Navigator.pop(context); // close loading dialog

                    if (isValid) {
                      // DINAGDAG: i-save ang session para hindi na mag-login ulit
                      await saveSession(email);

                      // go to HomePage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Invalid email or password",
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      );
                    }
                  },
                  // ============================================

                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // ============================================
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 130, height: 2, color: Colors.white),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "or",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Container(width: 130, height: 2, color: Colors.white),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      children: [
                        TextSpan(
                          text: "Sign Up",
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
      width: 155,
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