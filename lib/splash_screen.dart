import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding.dart';
import 'main.dart';
import 'services/session_service.dart';   // ← DINAGDAG: para ma-check kung naka-login pa


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // hintayin yung splash (5 seconds — same ng dati)
    // tapos mag-check ng session bago mag-route
    Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      _checkSessionAndRoute();
    });
  }


  // --------------------------------------------------------
  // BINAGO: dating lagi lang pumupunta sa OnboardingScreen
  // ngayon nag-che-check muna kung naka-login na
  //
  // kung naka-login na  → diretso sa HomePage (skip onboarding + login)
  // kung hindi pa       → normal flow → OnboardingScreen
  // --------------------------------------------------------
  Future<void> _checkSessionAndRoute() async {
    String? savedEmail = await isLoggedIn();

    if (!mounted) return;

    if (savedEmail != null) {
      // may nakalog-in na dati — skip onboarding at login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // wala pang session — normal na flow
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          'images/TIPNaV.gif',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}