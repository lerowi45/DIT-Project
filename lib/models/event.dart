import 'package:diteventsapp/models/comment.dart';
import 'package:diteventsapp/models/user.dart';

class Event {
  int? id;
  String? title;
  String? description;
  int? published;
  String? location;
  DateTime? datetime;
  String? keywords;
  int? capacity;
  String? thumbnail;
  int? userId;
  int? categoryId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? likesCount;
  List<Comment>? comments;
  User? creator;
  bool? selfLiked;

  Event({
    this.id,
    this.title,
    this.description,
    this.published,
    this.location,
    this.datetime,
    this.keywords,
    this.capacity,
    this.thumbnail,
    this.userId,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.likesCount,
    this.comments,
    this.creator,
    this.selfLiked,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['id'] as int?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        published: json['published'] as int?,
        location: json['location'] as String?,
        datetime: DateTime.parse(json['datetime']),
        keywords: json['keywords'] as String?,
        capacity: json['capacity'] as int?,
        thumbnail: json['thumbnail'] as String?,
        userId: json['user_id'] as int?,
        categoryId: json['category_id'] as int?,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        likesCount: json['likes_count'],
        selfLiked: json['likes'].length > 0 ?? false,
        comments: json['comments'] != null
            ? List<Comment>.from(
                json['comments'].map((comment) => Comment.fromJson(comment)))
            : null,
        creator: json['creator'] != null
            ? User(
                id: json['creator']['id'],
                username: json['creator']['username'],
                avatar: json['creator']['avatar'],
              )
            : null);
  }
}
