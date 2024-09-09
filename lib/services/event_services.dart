import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:diteventsapp/models/api_response.dart';
import 'package:diteventsapp/models/event.dart';
import 'package:diteventsapp/services/user_services.dart';
import 'dart:async';
import '../constant.dart';

// get all Events
Future<ApiResponse> getEvents(String search) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    print("getting event");
    String token = await getToken();
    print(token);

    final response = await http.get(
      Uri.parse("$eventsURL?search=$search"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Connection': 'keep-alive'
      },
    );
    print("response: ");
    print(response.body);

    switch (response.statusCode) {
      case 200:
        // print(json.decode(response.body)['events']);
        apiResponse.data = jsonDecode(response.body)['events']
            .map((p) => Event.fromJson(p))
            .toList();
            print(apiResponse.data);
            print("data");
        // var list = apiResponse.data as List<dynamic>;
        // list.forEach((element) {
        //   print(element.title.creator.username);
        // });
        // we get list of Events, so we need to map each item to Event model
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e.toString());
    apiResponse.error = e.toString();
  }
  return apiResponse;
}

Future<ApiResponse> createEvent(
  String title,
  String description,
  String location,
  DateTime dateTime,
  String keywords,
  int? capacity,
  int categoryId,
  File? thumbnail,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    var request = http.MultipartRequest('POST', Uri.parse(eventsURL));

    //adding headers
    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": 'Bearer $token',
      'Connection': 'keep-alive',
      'Accept': 'application/json',
    };
//    request.headers['Connection'] = 'keep-alive';
    request.headers.addAll(headers);
    request.followRedirects = false;

    //adding fields
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['published'] = '0';
    request.fields['location'] = location;
    request.fields['datetime'] = dateTime.toIso8601String();
    request.fields['keywords'] = keywords;
    request.fields['capacity'] = capacity.toString();
    request.fields['category_id'] = categoryId.toString();

    //adding file
    if (thumbnail != null) {
      request.files
          .add(await http.MultipartFile.fromPath('thumbnail', thumbnail.path));
    } else {
      // print("Thumbnail is null");
    }

    //sending request
    // print("request: $request");

    var res = await request.send();
    //print("res: $res");
    http.Response response = await http.Response.fromStream(res);

     print("stausCode: $response.statusCode");
     print("body: ${response.body}");
     print("error: ${response.reasonPhrase}");

     print("Got to switch");

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
// Future<ApiResponse> createEvent(
//   String title,
//   String description,
//   String location,
//   DateTime dateTime,
//   String keywords,
//   int? capacity,
//   int categoryId,
//   File? thumbnail,
// ) async {
//   ApiResponse apiResponse = ApiResponse();
//   try {
//     String token = await getToken();
//     print(eventsURL);
//     final response = await http.post(Uri.parse(eventsURL), headers: {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token'
//     }, body: {
//       'title': title,
//       'description': description,
//       'published': '0',
//       'location': location,
//       'datetime': dateTime.toIso8601String(),
//       'keywords': keywords,
//       'capacity': capacity.toString(),
//       'thumbnail': thumbnail ?? "assets/images/placeholder.png",
//       'category_id': categoryId.toString()
//     });

//     print("Got to switch");
//     // here if the image is null we just send the body, if not null we send the image too
//     print("${response.request!.url}");

//     switch (response.statusCode) {
//       case 200:
//         apiResponse.data = jsonDecode(response.body);
//         break;
//       case 422:
//         final errors = jsonDecode(response.body)['errors'];
//         apiResponse.error = errors[errors.keys.elementAt(0)][0];
//         break;
//       case 401:
//         apiResponse.error = unauthorized;
//         break;
//       case 404:
//         print("404");
//         apiResponse.error = jsonDecode(response.body)['message'];
//         break;
//       default:
//         apiResponse.error = somethingWentWrong;
//         break;
//     }
//   } catch (e) {
//     apiResponse.error = apiResponse.error;
//     print(e);
//   }
//   return apiResponse;
// }

// Edit Event
Future<ApiResponse> editEvent(
  int eventId,
  String title,
  String description,
  String location,
  DateTime dateTime,
  String keywords,
  int? capacity,
  int categoryId,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(Uri.parse('$eventsURL/$eventId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Connection': 'keep-alive'
    }, body: {
      'title': title,
      'description': description,
      'published': false,
      'location': location,
      'datetime': dateTime,
      'keywords': keywords,
      'capacity': capacity,
      'category_id': categoryId
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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

// Delete Event
Future<ApiResponse> deleteEvent(int eventId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.delete(Uri.parse('$eventsURL/$eventId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Connection': 'keep-alive'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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

// Like or unlike Event
Future<ApiResponse> likeUnlikeEvent(int? eventId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.post(Uri.parse('$eventsURL/$eventId/likes'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Connection': 'keep-alive'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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
