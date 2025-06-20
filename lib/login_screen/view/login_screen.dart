import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.orange),
            width: MediaQuery.of(context).size.width / 2,
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.green),
            width: MediaQuery.of(context).size.width / 2,
          ),
        ],
      ),
    );
  }
}
