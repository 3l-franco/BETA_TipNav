import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget {
  // LEM - changed to StatefulWidget so we can reload user data
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color accentColor = const Color(0xFFFFBF00);

  // LEM - get fresh user data from firebase
  User? get user => FirebaseAuth.instance.currentUser;

  // LEM - opens bottom sheet to edit username
  void openEditProfile() {
    final TextEditingController nameCtrl = TextEditingController(
      text: user?.displayName ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Username',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  fillColor: const Color(0xFFF0F0F0),
                  filled: true,
                  hintText: 'Enter your name',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameCtrl.text.trim().isEmpty) return;

                    // LEM - update displayName in firebase auth
                    await user?.updateDisplayName(nameCtrl.text.trim());
                    await user?.reload();

                    Navigator.pop(ctx);
                    setState(() {}); // refresh screen with new name

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // LEM - pull real data from firebase auth
    String displayName = user?.displayName ?? 'TIPian';
    String email = user?.email ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),

              // LEM - initials avatar, no photo upload needed
              Center(
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: accentColor,
                  child: Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : 'T',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // LEM - real name from firebase auth
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                email,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 12),

              // LEM - edit profile button
              GestureDetector(
                onTap: openEditProfile,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: accentColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // menu items - same as original
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
                      'Notifications',
                      const Color(0xFFFAEE96).withOpacity(0.5),
                      const Color(0xFF83710B),
                    ),
                    divider(),
                    menuItem(
                      Icons.person,
                      'Personal Information',
                      const Color(0xFFCDFA96).withOpacity(0.5),
                      const Color(0xFF4C8300),
                    ),
                    divider(),
                    menuItem(
                      Icons.info,
                      'FAQs',
                      const Color(0xFFA0A7F0).withOpacity(0.5),
                      const Color(0xFF4A4CBC),
                    ),
                    divider(),
                    menuItem(
                      Icons.history,
                      'History',
                      const Color(0xFFFFA4F6).withOpacity(0.5),
                      const Color(0xFF8C37AE),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // logout button - same as original
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () async {
                    await signOut();
                    // clear the nav stack so user cant go back after logout
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9F9F),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Color(0xFFA90F0F)),
                        SizedBox(width: 10),
                        Text(
                          'Log out',
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
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget divider() {
    return const Divider(thickness: 0.9, indent: 10, endIndent: 10);
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
}
