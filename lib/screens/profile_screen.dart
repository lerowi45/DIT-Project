import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:diteventsapp/models/user.dart';
import 'package:diteventsapp/screens/home.dart';
import 'package:diteventsapp/services/user_services.dart';

// This class handles the Page to dispaly the user's info on the "Edit Profile" Screen
class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _avatar;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatar = File(pickedFile.path);
        editProfile(_avatar);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 50,
          ),
          const Center(
              child: Padding(
                  padding: EdgeInsets.only(bottom: 20, top: 20),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ))),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              image: _avatar == null
                  ? null
                  : DecorationImage(
                      image: FileImage(_avatar ?? File('')),
                      fit: BoxFit.cover,
                    ),
            ),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.image, size: 50, color: Colors.black38),
                onPressed: () {
                  getImage();
                },
              ),
            ),
          ),
          buildUserInfoDisplay(
            widget.user.username,
            'Name',
            const Home(),
          ),
          buildUserInfoDisplay(
            widget.user.tel1,
            'Phone',
            const Home(),
          ),
          buildUserInfoDisplay(
            widget.user.email,
            'Email',
            const Home(),
          ),
          Expanded(
            flex: 4,
            child: buildAbout(widget.user),
          )
        ],
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(
          String? getValue, String title, Widget editPage) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Container(
                  width: 350,
                  height: 40,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              navigateSecondPage(editPage);
                            },
                            child: Text(
                              getValue ?? 'No Value',
                              style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.4,
                                  color: Colors.white),
                            ))),
                    const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                      size: 40.0,
                    )
                  ]))
            ],
          ));

  // Widget builds the About Me Section
  Widget buildAbout(User user) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tell Us About Yourself',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 1),
          Container(
              width: 350,
              height: 200,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              ))),
              child: Row(children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      //navigateSecondPage(EditDescriptionFormPage());
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: user.about == null
                            ? const Text(
                                'No Description',
                                style: TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                    color: Colors.red),
                              )
                            : Text(
                                user.about!,
                                style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                    color: Colors.white),
                                textAlign: TextAlign.left,
                              ),
                      ),
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                  size: 40.0,
                )
              ]))
        ],
      ));

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}
