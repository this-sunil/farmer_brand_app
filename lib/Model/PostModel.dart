// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  final bool? status;
  final String? msg;
  final List<Result>? result;

  PostModel({
    this.status,
    this.msg,
    this.result,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    status: json["status"],
    msg: json["msg"],
    result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class Result {
  final int? pid;
  final String? postTitle;
  final String? postDesc;
  final String? postUrl;
  final int? fav;
  final User? user;
  final DateTime? createdAt;

  Result({
    this.pid,
    this.postTitle,
    this.postDesc,
    this.postUrl,
    this.fav,
    this.user,
    this.createdAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    pid: json["pid"],
    postTitle: json["post_title"],
    postDesc: json["post_desc"],
    postUrl: json["post_url"],
    fav: json["fav"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "pid": pid,
    "post_title": postTitle,
    "post_desc": postDesc,
    "post_url": postUrl,
    "fav": fav,
    "user": user?.toJson(),
    "created_at": createdAt?.toIso8601String(),
  };
}

class User {
  final int? id;
  final String? name;
  final int? phone;
  final String? city;
  final String? state;

  User({
    this.id,
    this.name,
    this.phone,
    this.city,
    this.state,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    city: json["city"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "city": city,
    "state": state,
  };
}
