//import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diteventsapp/models/api_response.dart';
import 'package:diteventsapp/models/user.dart';
import 'package:diteventsapp/screens/home.dart';
import 'package:diteventsapp/screens/onboding/onboding_screen.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/user_services.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  bool isShowConfetti = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _tel1Controller = TextEditingController();
  final TextEditingController _tel2Controller = TextEditingController();

  int _campus = 1;

  final List<DropdownMenuItem<int>> _campuses = [
    const DropdownMenuItem(value: 1, child: Text('KNUST')),
    const DropdownMenuItem(value: 2, child: Text('UG')),
    const DropdownMenuItem(value: 3, child: Text('UDS')),
  ];
  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
      (route) => false,
    );
  }

  void _loginUser(
    String? username,
    String? fullname,
    String? email,
    String? password,
    String? tel1,
    String? tel2,
    String? campusId,
    String? roleId,
  ) async {
    ApiResponse response = await register(
      username,
      fullname,
      email,
      password,
      tel1,
      tel2,
      campusId,
      roleId,
    );
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  late SMITrigger confetti;

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  void signUp(BuildContext context) {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (_formKey.currentState!.validate()) {
        _loginUser(
          _usernameController.text,
          _fullnameController.text,
          _emailController.text,
          _passwordController.text,
          _tel1Controller.text,
          _tel2Controller.text,
          _campus.toString(), // Convert _campus to a String
          2.toString(), // Convert 2 to a String
        );
        // show success
        check.fire();
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
          confetti.fire();
        });
      } else {
        error.fire();
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const font = 14.0;
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Register",
                style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Register an accout here",
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  children: [
                    const Text(
                      "username",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: font,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                      child: TextFormField(
                        controller: _usernameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                        onSaved: (username) {},
                        decoration: const InputDecoration(
                            prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(
                                  Icons.person,
                                  color: Color(0xFFFE0037),
                                ))),
                      ),
                    ),
                  ],
                ),
              ),

              // fullname
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  children: [
                    const Text(
                      "Full Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: font,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                      child: TextFormField(
                        controller: _fullnameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                        onSaved: (fullname) {},
                        decoration: const InputDecoration(
                            prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.person_2_outlined,
                            color: Color(0xFFFE0037),
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              //email

              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  children: [
                    const Text(
                      "Email",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: font,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                      child: TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                        onSaved: (email) {},
                        decoration: const InputDecoration(
                            prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(
                                  Icons.email,
                                  color: Color(0xFFFE0037),
                                ))),
                      ),
                    ),
                  ],
                ),
              ),

              //password

              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  children: [
                    const Text(
                      "Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: font,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                        onSaved: (password) {},
                        obscureText: true,
                        decoration: const InputDecoration(
                            prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(
                                  Icons.lock,
                                  color: Color(0xFFFE0037),
                                ))),
                      ),
                    ),
                  ],
                ),
              ),

              //campuses
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  children: [
                    const Text(
                      "Campus",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: font,
                      ),
                    ),
                    DropdownButtonFormField<int>(
                      value: _campus,
                      items: _campuses,
                      onChanged: (value) {
                        setState(() {
                          _campus = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              //tel1

              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  children: [
                    const Text(
                      "Telephone 1",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: font,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                      child: TextFormField(
                        controller: _tel1Controller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                        onSaved: (tel1) {},
                        decoration: const InputDecoration(
                            prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.phone,
                            color: Color(0xFFFE0037),
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ),

              //tel2

              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  children: [
                    const Text(
                      "Telephone 2",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: font,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                      child: TextFormField(
                        controller: _tel2Controller,
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return "";
                        //   }
                        //   return null;
                        // },
                        onSaved: (tel2) {},
                        decoration: const InputDecoration(
                            prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.phone,
                            color: Color(0xFFFE0037),
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 24),
                child: ElevatedButton.icon(
                  onPressed: () {
                    signUp(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF77D8E),
                      minimumSize: const Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25)))),
                  icon: const Icon(
                    CupertinoIcons.arrow_right,
                    color: Color(0xFFFE0037),
                  ),
                  label: const Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: font,
                    ),
                  ),
                ),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OnboardingScreen()),
                  );
                },
                child: const Column(
                  children: [
                    Icon(Icons.close, color: Colors.white),
                    Text("Close", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                "assets/RiveAssets/check.riv",
                onInit: (artboard) {
                  StateMachineController controller =
                      getRiveController(artboard);
                  check = controller.findSMI("Check") as SMITrigger;
                  error = controller.findSMI("Error") as SMITrigger;
                  reset = controller.findSMI("Reset") as SMITrigger;
                },
              ))
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
                child: Transform.scale(
                scale: 6,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/confetti.riv",
                  onInit: (artboard) {
                    StateMachineController controller =
                        getRiveController(artboard);
                    confetti =
                        controller.findSMI("Trigger explosion") as SMITrigger;
                  },
                ),
              ))
            : const SizedBox()
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child, this.size = 100});
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: size,
            width: size,
            child: child,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
