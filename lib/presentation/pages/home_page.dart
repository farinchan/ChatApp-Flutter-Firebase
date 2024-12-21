import 'package:flutter/material.dart';
import 'package:flutter_chat_firebase/core/extensions/build_context_ext.dart';
import 'package:flutter_chat_firebase/presentation/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut();
              context.pushReplacement(const LoginPage());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
