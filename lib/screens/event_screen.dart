import 'package:flutter/material.dart';
import 'package:diteventsapp/constant.dart';
import 'package:diteventsapp/models/api_response.dart';
import 'package:diteventsapp/models/event.dart';
import 'package:diteventsapp/screens/comment_screen.dart';
import 'package:diteventsapp/screens/create_event_form.dart';
import 'package:diteventsapp/services/event_services.dart';
import 'package:diteventsapp/services/user_services.dart';

import 'login.dart';

part "event_card.dart";

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<dynamic> _eventList = [];
  int userId = 0;
  bool _loading = true;
  final searchController = TextEditingController();

  // get all events
  Future<void> retrieveEvents() async {
    var id = await getUserId();
    print("retrieving events");
    ApiResponse response = await getEvents(searchController.text);
    print("events retrieved...");
    print(response.data);
    if (response.error == null) {
      setState(() {
        userId = id;
        _eventList = response.data as List<dynamic>;

        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  // event like dislike
  void _handleEventLikeDislike(int? eventId) async {
    ApiResponse response = await likeUnlikeEvent(eventId);

    if (response.error == null) {
      retrieveEvents();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void handleDeleteEvent(int eventId) async {
    ApiResponse response = await deleteEvent(eventId);
    if (response.error == null) {
      retrieveEvents();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    retrieveEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () {
              return retrieveEvents();
            },
            child: Column(
              children: [
                //search box
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        retrieveEvents();
                      });
                    },
                  ),
                ),
                _eventList.isEmpty
                    ? const Expanded(
                        child: Card(
                          child: Center(
                            child: Text("No events found",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: _eventList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Event event = _eventList[index];
                                    return EventCard(
                                      event: event,
                                      userId: userId,
                                      likeDislike: _handleEventLikeDislike,
                                      handleDeleteEvent: handleDeleteEvent,
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                FloatingActionButton(
                    backgroundColor: Color.fromARGB(255, 47, 161, 51),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        '/event.form',
                        arguments: {"title": "Create Event"},
                      );
                    },
                    child: const Icon(Icons.add)),
              ],
            ),
          );
  }
}
