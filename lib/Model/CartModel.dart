// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  final bool? status;
  final String? msg;
  final List<Result>? result;

  CartModel({
    this.status,
    this.msg,
    this.result,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
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
  final String? productTitle;
  final String? productDesc;
  final String? productPhoto;
  final int? productPrice;
  final int? productQty;
  final int? productStock;
  final String? productWeight;
  final int? fid;
  final DateTime? createdAt;

  Result({
    this.pid,
    this.productTitle,
    this.productDesc,
    this.productPhoto,
    this.productPrice,
    this.productQty,
    this.productStock,
    this.productWeight,
    this.fid,
    this.createdAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    pid: json["pid"],
    productTitle: json["product_title"],
    productDesc: json["product_desc"],
    productPhoto: json["product_photo"],
    productPrice: json["product_price"],
    productQty: json["product_qty"],
    productStock: json["product_stock"],
    productWeight: json["product_weight"],
    fid: json["fid"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "pid": pid,
    "product_title": productTitle,
    "product_desc": productDesc,
    "product_photo": productPhoto,
    "product_price": productPrice,
    "product_qty": productQty,
    "product_stock": productStock,
    "product_weight": productWeight,
    "fid": fid,
    "created_at": createdAt?.toIso8601String(),
  };
}
