import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:diteventsapp/constant.dart';
import 'package:diteventsapp/models/api_response.dart';
import 'package:diteventsapp/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

//login
Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    print("entered try block");
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {'Accept': 'application/json'},
      body: {'email_username': email, 'password': password},
    );

    print( response.statusCode);

    switch (response.statusCode) {
      case 200:
        print(response.body);
        apiResponse.data =
            User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

            print("Got out");
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors['email'] != null
            ? errors['email'][0]
            : errors['password'][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = response.statusCode.toString();
        break;
    }
  } catch (e) {
    print('error occured here');
    print(e);
    apiResponse.error = serverError;
  }

  return apiResponse;
}

//register
Future<ApiResponse> register(
  String? username,
  String? fullname,
  String? email,
  String? password,
  String? tel1,
  String? tel2,
  String? campusId,
  String? roleId,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(registerURL),
      headers: {'Accept': 'application/json'},
      body: {
        'username': username,
        'fullname': fullname,
        'email': email,
        'password': password,
        'tel1': tel1,
        'tel2': tel2,
        'campus_id': campusId,
        'role_id': roleId,
        'password_confirmation': password,
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

//edit profile
Future<ApiResponse> editProfile(
  File? avatar,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    var request = http.MultipartRequest('PATCH', Uri.parse(userURL));

    //adding headers
    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": 'Bearer $token',
      'Connection': 'keep-alive'
    };

    request.headers.addAll(headers);

    //adding file
    if (avatar != null) {
      request.files
          .add(await http.MultipartFile.fromPath('avatar', avatar.path));
    } else {}

    //sending request

    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);
    // print("body: ${response.body}");
    // print("error: ${response.reasonPhrase}");

    // print("Got to switch");

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 404:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = apiResponse.error;
  }
  return apiResponse;
}

//user details
Future<ApiResponse> getUserData() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(userURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

//get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('id') ?? 0;
}

//logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}
