// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  final bool? status;
  final String? msg;
  final int? currentPage;
  final int? totalPages;
  final bool? prevPage;
  final bool? nextPage;
  final List<Result>? result;

  ProductModel({
    this.status,
    this.msg,
    this.currentPage,
    this.totalPages,
    this.prevPage,
    this.nextPage,
    this.result,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    status: json["status"],
    msg: json["msg"],
    currentPage: json["currentPage"],
    totalPages: json["totalPages"],
    prevPage: json["prevPage"],
    nextPage: json["nextPage"],
    result: json["result"] == null
        ? []
        : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "currentPage": currentPage,
    "totalPages": totalPages,
    "prevPage": prevPage,
    "nextPage": nextPage,
    "result": result == null
        ? []
        : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class Result {
  final int? fid;
  final String? name;
  final String? city;
  final String? pin;
  final String? photo;
  final List<Product>? products;

  Result({this.fid, this.name, this.city, this.pin, this.photo, this.products});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    fid: json["fid"],
    name: json["name"],
    city: json["city"],
    pin: json["pin"],
    photo: json["photo"],
    products: json["products"] == null
        ? []
        : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "fid": fid,
    "name": name,
    "city": city,
    "pin": pin,
    "photo": photo,
    "products": products == null
        ? []
        : List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}

class Product {
  final int? pid;
  final int? productQty;
  final String? productDesc;
  final String? productPhoto;
  final int? productPrice;
  final int? productStock;
  final String? productTitle;
  final String? productWeight;

  Product({
    this.pid,
    this.productQty = 0,
    this.productDesc,
    this.productPhoto,
    this.productPrice,
    this.productStock,
    this.productTitle,
    this.productWeight,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    pid: json["pid"],
    productQty: json["product_qty"],
    productDesc: json["product_desc"],
    productPhoto: json["product_photo"],
    productPrice: json["product_price"],
    productStock: json["product_stock"],
    productTitle: json["product_title"],
    productWeight: json["product_weight"],
  );

  Product copyWith({
    int? pid,
    int? productQty,
    String? productDesc,
    String? productPhoto,
    int? productPrice,
    int? productStock,
    String? productTitle,
    String? productWeight,
  }) {
    return Product(
      pid: pid ?? this.pid,
      productQty: productQty ?? this.productQty,
      productDesc: productDesc ?? this.productDesc,
      productPhoto: productPhoto ?? this.productPhoto,
      productPrice: productPrice ?? this.productPrice,
      productStock: productStock ?? this.productStock,
      productTitle: productTitle ?? this.productTitle,
      productWeight: productWeight ?? this.productWeight,
    );
  }

  Map<String, dynamic> toJson() => {
    "pid": pid,
    "product_qty": productQty,
    "product_desc": productDesc,
    "product_photo": productPhoto,
    "product_price": productPrice,
    "product_stock": productStock,
    "product_title": productTitle,
    "product_weight": productWeight,
  };
}
