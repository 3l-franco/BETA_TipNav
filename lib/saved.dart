import 'package:flutter/material.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          Text("SAVED PLACES", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, letterSpacing: 3.0)),
        ],
      ),
    );
  }
}