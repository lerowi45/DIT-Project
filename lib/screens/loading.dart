import 'package:flutter/material.dart';
import 'package:diteventsapp/constant.dart';
import 'package:diteventsapp/models/api_response.dart';
import 'package:diteventsapp/screens/home.dart';
import 'package:diteventsapp/screens/login.dart';
import 'package:diteventsapp/services/user_services.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void _loadUserData() async {
    String token = await getToken();
    if (token == '') {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
        (route) => false,
      );
    } else {
      ApiResponse response = await getUserData();
      if (response.error == null) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
          (route) => false,
        );
      } else if (response.error == unauthorized) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
          (route) => false,
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response.error}'),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const Center(
            child: CircularProgressIndicator(),
          )),
    );
  }
}
