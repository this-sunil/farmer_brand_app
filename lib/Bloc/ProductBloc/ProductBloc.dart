import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:farmer_brand/Model/ProductModel.dart';
import 'package:farmer_brand/Repository/ProductRepository.dart';
import 'package:farmer_brand/Services/LocalStorage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

part 'ProductEvent.dart';
part 'ProductState.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepo repository;
  ProductBloc(this.repository) : super(ProductState.initial()) {
    on<FetchProduct>(_getAllProduct);
    on<AddQuantity>(_addQtyProduct);
  }

  ProductModel? model;
  _addQtyProduct(AddQuantity event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));
    String url = '${dotenv.env['BASE_URL']}${dotenv.env["ADD_QTY"]}';
    String? uid = await LocalStorage().getUID();
    Map<String, dynamic> body = {
      "uid": uid.toString(),
      "pid": event.pid.toString(),
      "qty": event.qty.toString(),
    };
    log("Add Quantity $body");
    // final updateResult = updateProductQty(
    //     model ?? ProductModel(),
    //     double.parse(event.pid).toInt(),
    //     event.qty
    // );
    final result=await repository.addQtyProduct(url: url, body: body);
    result.fold((l)=>emit(state.copyWith(status: l.status,msg: l.msg)), (r){
      log("Add Bloc qty=>${event.qty}");

    });
    // emit(state.copyWith(
    //     status: ProductStatus.completed,
    //     product: updateResult,
    //     msg: 'Added Qty')
    // );





  }

  ProductModel updateProductQty(ProductModel model, int pid, int newQty) {
    return ProductModel(
      status: model.status,
      msg: model.msg,
      currentPage: model.currentPage,
      totalPages: model.totalPages,
      prevPage: model.prevPage,
      nextPage: model.nextPage,
      result: model.result?.map((res) {
        return Result(
          fid: res.fid,
          name: res.name,
          city: res.city,
          pin: res.pin,
          photo: res.photo,
          products: res.products?.map((prod) {
            if (prod.pid == pid) {
              return prod.copyWith(productQty: newQty);
            }
            return prod;
          }).toList(),
        );
      }).toList(),
    );
  }

  _getAllProduct(FetchProduct event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));
    String url = '${dotenv.env['BASE_URL']}${dotenv.env["ALL_PRODUCT"]}';
    String? uid = await LocalStorage().getUID();
    Map<String, dynamic> body = {"page": event.page, "uid": uid};
    final result = await repository.fetchProduct(url: url, body: body);

    result.fold((l) => emit(state.copyWith(status: l.status, msg: l.msg)), (r) {
      model = r.result;
      emit(state.copyWith(status: r.status, msg: r.msg, product: model));
    });
  }
}
