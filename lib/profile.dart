import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'login.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                height: 140,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1C1C1C), Color(0xFF2A2A2A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),

                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 20),
                child: const Text(
                  "PROFILE",
                  style: TextStyle(
                    color: Color(0xFFFFC107),
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Positioned(
                bottom: -50,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 70),

          const Text(
            "Aldrin Ga",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "Student • 1st year • Information technology",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),

          const SizedBox(height: 50),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                menuItem(
                  Icons.notifications,
                  "Notifications",
                  Color(0xFFFAEE96).withValues(alpha: 0.5),
                  Color(0xFF83710B),
                ),
                divider(),
                menuItem(
                  Icons.person,
                  "Personal Information",
                  Color(0xFFCDFA96).withValues(alpha: 0.5),
                  Color(0xFF4C8300),
                ),
                divider(),
                menuItem(
                  Icons.info,
                  "FAQs",
                  Color(0xFFA0A7F0).withValues(alpha: 0.5),
                  Color(0xFF4A4CBC),
                ),
                divider(),
                menuItem(
                  Icons.history,
                  "History",
                  Color(0xFFFFA4F6).withValues(alpha: 0.5),
                  Color(0xFF8C37AE),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () async {
                await signOut();

                // clear the nav stack so user cant go back after logout
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFFFF9F9F),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Color(0xFFA90F0F)),
                    SizedBox(width: 10),
                    Text(
                      "Log out",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA90F0F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget menuItem(IconData icon, String title, Color bgColor, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: bgColor,
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return const Divider(thickness: 0.9, indent: 10, endIndent: 10);
  }
}
