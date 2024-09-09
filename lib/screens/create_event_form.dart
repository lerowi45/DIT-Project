import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:diteventsapp/constant.dart';
import 'package:diteventsapp/models/api_response.dart';
import 'package:diteventsapp/models/event.dart';
import 'package:diteventsapp/screens/components/datetime.dart';
import 'package:diteventsapp/services/event_services.dart';
import 'package:diteventsapp/services/user_services.dart';

class CreateEventForm extends StatefulWidget {
  final Event? event;
  final String? title;
  const CreateEventForm({Key? key, this.event, this.title}) : super(key: key);

  @override
  State<CreateEventForm> createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final _formKey = GlobalKey<FormState>();
  final _event = EventData();
  File? _thumbnail;
  bool _loading = false;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _thumbnail = File(pickedFile.path);
      });
    }
  }

  void _createEvent() async {
    //String? flyer = _event.thumbnail == null ? null : _thumbnail!.path;
    ApiResponse response = await createEvent(
      _event.title,
      _event.description,
      _event.location,
      _event.datetime,
      _event.keywords,
      _event.capacity,
      _event.categoryId,
      _thumbnail,
    );

    if (response.error == null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).popAndPushNamed('/home');
    } else if (response.error == unauthorized) {
      logout().then(
        (value) => {
          Navigator.pushNamed(context, "/login"),
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  // edit event
  // ignore: unused_element
  void _editEvent(int? eventId) async {
    ApiResponse response = await editEvent(
      eventId!,
      _event.title,
      _event.description,
      _event.location,
      _event.datetime,
      _event.keywords,
      _event.capacity,
      _event.categoryId,
    );
    if (response.error == null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.pushNamed(context, "/login"),
          });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 152, 132),
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        title: Text('${widget.title}'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _event.title == ''
                          ? null
                          : TextEditingController(text: _event.title),
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      onChanged: (value) => _event.title = value,
                      onSaved: (value) => _event.title = value!,
                    ),

                    //Description
                    TextFormField(
                      controller: TextEditingController(
                          text: _event.description == ''
                              ? null
                              : _event.description),
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      onChanged: (value) => _event.description = value,
                      onSaved: (value) => _event.description = value!,
                    ),

                    //Location
                    TextFormField(
                      controller: TextEditingController(
                          text: _event.location == '' ? null : _event.location),
                      decoration: const InputDecoration(labelText: 'Location'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a location';
                        }
                        return null;
                      },
                      onChanged: (value) => _event.location = value,
                      onSaved: (value) => _event.location = value!,
                    ),

                    //Date time
                    DateTimePicker(
                      label: 'Date and Time',
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (dateTime) =>
                          _event.datetime = dateTime,
                    ),
                    TextFormField(
                      controller: TextEditingController(
                          text: _event.keywords == '' ? null : _event.keywords),
                      decoration: const InputDecoration(
                          labelText: 'Keywords (comma-separated)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some keywords';
                        }
                        return null;
                      },
                      onChanged: (value) => _event.keywords = value,
                      onSaved: (value) => _event.keywords = value!,
                    ),

                    //Capacity
                    TextFormField(
                      controller: TextEditingController(
                          // ignore: prefer_null_aware_operators
                          text: _event.capacity == null
                              ? null
                              : _event.capacity.toString()),
                      decoration: const InputDecoration(
                          labelText:
                              'Capacity (number of attendees Expecting)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a capacity';
                        }
                        final capacity = int.tryParse(value);
                        if (capacity == null || capacity <= 0) {
                          return 'Please enter a valid capacity';
                        }
                        return null;
                      },
                      onChanged: (value) => _event.capacity = int.parse(value),
                      onSaved: (value) => _event.capacity = int.parse(value!),
                    ),

                    // Category field
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: 'Category'),
                      validator: (value) {
                        if (value == null || value <= 0) {
                          return 'Please enter a capacity';
                        }
                        _event.categoryId = int.parse(value.toString());
                        if (_event.categoryId <= 0) {
                          return 'Please enter a valid capacity';
                        }
                        return null;
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 1,
                          child: Text('Technology'),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text('Politics'),
                        ),
                        DropdownMenuItem(
                          value: 3,
                          child: Text('General'),
                        ),
                      ],
                      onChanged: (value) => _event.categoryId = value!,
                    ),

                    // Thumbnail field
                    widget.event != null
                        ? const SizedBox()
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            decoration: BoxDecoration(
                              image: _thumbnail == null
                                  ? null
                                  : DecorationImage(
                                      image: FileImage(_thumbnail ?? File('')),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            child: Center(
                              child: IconButton(
                                icon: const Icon(Icons.image,
                                    size: 50, color: Colors.black38),
                                onPressed: () {
                                  getImage();
                                },
                              ),
                            ),
                          ),

                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              _loading = !_loading;
                            });
                            if (widget.event == null) {
                              _createEvent();
                            } else {
                              _editEvent(widget.event!.id);
                            }
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class EventData {
  String title = '';
  String description = '';
  String published = '';
  String location = '';
  DateTime datetime = DateTime.now();
  String keywords = '';
  int? capacity;
  File? thumbnail;
  int categoryId = 0;
}
