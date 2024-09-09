import 'package:flutter/material.dart';
import 'package:diteventsapp/screens/onboding/components/register_form.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 300,
              height: 700,
              child: RegisterForm(),
            ),
          ),
        ],
      ),
    );
  }
}
