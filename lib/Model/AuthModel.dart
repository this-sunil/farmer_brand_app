// To parse this JSON data, do
//
//     final authModel = authModelFromJson(jsonString);

import 'dart:convert';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String authModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  final bool? status;
  final String? msg;
  final String? token;
  final Result? result;

  AuthModel({
    this.status,
    this.msg,
    this.token,
    this.result,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    status: json["status"],
    msg: json["msg"],
    token: json["token"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "token": token,
    "result": result?.toJson(),
  };
}

class Result {
  final int? id;
  final String? name;
  final String? phone;
  final String? photo;
  final String? state;
  final String? city;
  final String? role;
  final DateTime? createdAt;

  Result({
    this.id,
    this.name,
    this.phone,
    this.photo,
    this.state,
    this.city,
    this.role,
    this.createdAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    photo: json["photo"],
    state: json["state"],
    city: json["city"],
    role: json["role"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "photo": photo,
    "state": state,
    "city": city,
    "role": role,
    "created_at": createdAt?.toIso8601String(),
  };
}
