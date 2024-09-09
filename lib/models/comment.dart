import 'user.dart';

class Comment {
  int? id;
  String? comment;
  int? userId;
  int? eventId;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  Comment({
    this.id,
    this.comment,
    this.userId,
    this.eventId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  // map json to comment model
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'],
        comment: json['body'],
        userId: json['user_id'],
        eventId: json['event_id'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        user: json['user'] != null
            ? User(
                id: json['user']['id'],
                username: json['user']['username'],
                avatar: json['user']['avatar'],
              )
            : null);
  }
}
