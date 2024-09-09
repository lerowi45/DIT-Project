import 'package:flutter/material.dart';

const android = "192.168.43.110";
const web = "127.0.0.1";
const baseURL = 'http://$android:8000/api';
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const logoutURL = '$baseURL/logout';
const userURL = '$baseURL/user';
const eventsURL = '$baseURL/events';
const commentsURL = '$baseURL/comments';

// Error messages
const serverError = 'Server error';
const unauthorized = 'unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

const Color backgroundColor2 = Color(0xFF17203A);
const Color backgroundColorLight = Color(0xFFF2F6FF);
const Color backgroundColorDark = Color(0xFF25254B);
const Color shadowColorLight = Color(0xFF4A5367);
const Color shadowColorDark = Colors.black;

// likes and comment btn

Expanded kLikeAndComment(
    int? value, IconData icon, Color color, Function onTap, bool like) {
  return Expanded(
    child: Material(
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(like ? '$value attending' : '$value')
            ],
          ),
        ),
      ),
    ),
  );
}

Widget kLocation(
    String location, IconData icon, Color color, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Text(
            location,
            softWrap: true,
            textAlign: TextAlign.left,
          ),
        )
      ],
    ),
  );
}

// --- input decoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.all(10),
      border: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black)));
}

// button

TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
    style: ButtonStyle(
        backgroundColor: WidgetStateColor.resolveWith((states) => Colors.red),
        padding: WidgetStateProperty.resolveWith(
            (states) => const EdgeInsets.symmetric(vertical: 10))),
    onPressed: () => onPressed(),
    child: Text(
      label,
      style: const TextStyle(color: Colors.white),
    ),
  );
}

// loginRegisterHint
Row kLoginRegisterHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
          child: Text(label, style: const TextStyle(color: Colors.red)),
          onTap: () => onTap())
    ],
  );
}
