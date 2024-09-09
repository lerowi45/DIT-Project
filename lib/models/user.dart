class User {
  int? id;
  String? fullname;
  String? username;
  String? tel1;
  String? tel2;
  String? email;
  String? emailVerifiedAt;
  String? about;
  String? avatar;
  int? campusId;
  int? roleId;
  String? createdAt;
  String? updatedAt;
  String? token;

  User({
    this.id,
    this.fullname,
    this.username,
    this.tel1,
    this.tel2,
    this.email,
    this.emailVerifiedAt,
    this.about,
    this.avatar,
    this.campusId,
    this.roleId,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'] as int?,
      fullname: json['user']['fullname'] as String?,
      username: json['user']['username'] as String?,
      tel1: json['user']['tel1'] as String?,
      tel2: json['user']['tel2'] as String?,
      email: json['user']['email'] as String?,
      emailVerifiedAt: json['user']['email_verified_at'] as String?,
      about: json['user']['about'] as String?,
      avatar: json['user']['avatar'] as String?,
      campusId: json['user']['campus_id'] as int?,
      roleId: json['user']['role_id'] as int?,
      createdAt: json['user']['created_at'] as String?,
      updatedAt: json['user']['updated_at'] as String?,
      token: json['token'] as String?,
    );
  }
}
