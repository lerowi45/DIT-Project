// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:diteventsapp/models/api_response.dart';
import 'package:diteventsapp/models/comment.dart';
import 'package:diteventsapp/models/event.dart';
import 'package:diteventsapp/models/user.dart';
import 'package:diteventsapp/screens/event_screen.dart';
import 'package:diteventsapp/services/coment_services.dart';
import 'package:diteventsapp/services/event_services.dart';
import 'package:diteventsapp/services/user_services.dart';

import '../constant.dart';
import 'login.dart';

class CommentScreen extends StatefulWidget {
  final Event? event;

  const CommentScreen({super.key, this.event});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<dynamic> _commentsList = [];
  bool _loading = true;
  int userId = 0;
  int _editCommentId = 0;
  final TextEditingController _txtCommentController = TextEditingController();

  //get Id
  Future<void> getUserId() async {
    ApiResponse response = await getUserData();
    if (response.error == null) {
      userId = (response.data as User).id ?? 0;
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Get comments
  Future<void> _getComments() async {
    //userId = await getUserId();
    ApiResponse response = await getComments(widget.event?.id ?? 0);
    //print(response.error);
    if (response.error == null) {
      setState(() {
        _commentsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // create comment
  void _createComment() async {
    ApiResponse response =
        await createComment(widget.event?.id ?? 0, _txtCommentController.text);

    if (response.error == null) {
      _txtCommentController.clear();
      _getComments();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // edit comment
  void _editComment() async {
    ApiResponse response =
        await editComment(_editCommentId, _txtCommentController.text);

    if (response.error == null) {
      _editCommentId = 0;
      _txtCommentController.clear();
      _getComments();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Delete comment
  void _deleteComment(int commentId) async {
    ApiResponse response = await deleteComment(commentId);

    if (response.error == null) {
      _getComments();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // ignore: unused_element
  void _handleEventLikeDislike(int? eventId) async {
    ApiResponse response = await likeUnlikeEvent(eventId);

    if (response.error == null) {
      return;
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    _getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(children: [
              EventCard(
                  event: widget.event!, userId: widget.event!.creator!.id!),
              Expanded(
                  child: RefreshIndicator(
                      onRefresh: () {
                        return _getComments();
                      },
                      child: Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _commentsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              Comment comment = _commentsList[index];
                              return Container(
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black26,
                                            width: 0.5))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  image: comment.user!.avatar !=
                                                          null
                                                      ? DecorationImage(
                                                          image: NetworkImage(
                                                              '${comment.user!.avatar}'),
                                                          fit: BoxFit.cover)
                                                      : null,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.blueGrey),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${comment.user!.username}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            )
                                          ],
                                        ),
                                        comment.user!.id == userId
                                            ? PopupMenuButton(
                                                child: const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    child: Icon(
                                                      Icons.more_vert,
                                                      color: Colors.black,
                                                    )),
                                                itemBuilder: (context) => [
                                                  const PopupMenuItem(
                                                      value: 'edit',
                                                      child: Text('Edit')),
                                                  const PopupMenuItem(
                                                      value: 'delete',
                                                      child: Text('Delete'))
                                                ],
                                                onSelected: (val) {
                                                  if (val == 'edit') {
                                                    setState(() {
                                                      _editCommentId =
                                                          comment.id ?? 0;
                                                      _txtCommentController
                                                              .text =
                                                          comment.comment ?? '';
                                                    });
                                                  } else {
                                                    _deleteComment(
                                                        comment.id ?? 0);
                                                  }
                                                },
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text('${comment.comment}')
                                  ],
                                ),
                              );
                            }),
                      ))),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.black26, width: 0.5)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: kInputDecoration('Comment'),
                        controller: _txtCommentController,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (_txtCommentController.text.isNotEmpty) {
                          setState(() {
                            _loading = true;
                          });
                          if (_editCommentId > 0) {
                            _editComment();
                          } else {
                            _createComment();
                          }
                        }
                      },
                    )
                  ],
                ),
              )
            ]),
    );
  }
}
