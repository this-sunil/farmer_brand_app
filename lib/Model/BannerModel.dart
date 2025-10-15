// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

BannerModel bannerModelFromJson(String str) => BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  final bool? status;
  final String? msg;
  final List<Result>? result;

  BannerModel({
    this.status,
    this.msg,
    this.result,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
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
  final int? id;
  final String? title;
  final String? subtitle;
  final String? photo;
  final DateTime? createdat;

  Result({
    this.id,
    this.title,
    this.subtitle,
    this.photo,
    this.createdat,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    title: json["title"],
    subtitle: json["subtitle"],
    photo: json["photo"],
    createdat: json["createdat"] == null ? null : DateTime.parse(json["createdat"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "subtitle": subtitle,
    "photo": photo,
    "createdat": createdat?.toIso8601String(),
  };
}
