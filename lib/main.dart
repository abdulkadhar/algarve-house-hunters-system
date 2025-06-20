import 'package:algarve_house_hunters_system/login_screen/view/login_screen.dart';
import 'package:algarve_house_hunters_system/otp_screen/view/otp_screen.dart';
import 'package:algarve_house_hunters_system/sign_up_screen/view/sign_up_screen.dart';
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
      initialRoute: '/otp-screen',
      routes: {
        '/log-in': (context) => const LoginScreen(),
        '/sign-up': (context) => const SignUpScreen(),
        '/otp-screen': (context) => const OtpScreen(
              emailAddress: 's.abdulkadhar11@gmail.com',
            ),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
