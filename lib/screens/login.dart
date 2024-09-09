import 'package:flutter/material.dart';
import 'package:diteventsapp/screens/onboding/onboding_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return const OnboardingScreen();
  }
}
