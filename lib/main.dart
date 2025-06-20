import 'package:algarve_house_hunters_system/login_screen/view/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AlgarveHouseHuntersSystem());
}

class AlgarveHouseHuntersSystem extends StatelessWidget {
  const AlgarveHouseHuntersSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Algarve House Hunters',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
