
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:farmer_brand/Model/ProductByIdModel.dart';
import 'package:farmer_brand/Model/ProductModel.dart';
import 'package:farmer_brand/Repository/ProductRepository.dart';
import 'package:farmer_brand/Services/LocalStorage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
part 'ProductEvent.dart';
part 'ProductState.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepo repository;
  ProductBloc(this.repository) : super(ProductState.initial()) {
    on<FetchProduct>(_getAllProduct);
    on<AddQuantity>(_addQtyProduct);

  }
  _addQtyProduct(AddQuantity event,Emitter<ProductState> emit) async{

    String url = '${dotenv.env['BASE_URL']}${dotenv.env["ADD_QTY"]}';
    String? uid=await LocalStorage().getUID();
    Map<String, dynamic> body = {"uid":uid.toString(),"pid":event.pid.toString(),"qty": event.qty.toString()};
    log("Add Quantity $body");
    final result=await repository.addQtyProduct(url: url, body: body,header: {
      "Content-Type":"application/json"
    });

    result.fold((l)=>log("Error ${l.msg}"), (r)=> add(FetchProduct(page: '1')));
  }
  _getAllProduct(FetchProduct event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));
    String url = '${dotenv.env['BASE_URL']}${dotenv.env["ALL_PRODUCT"]}';
    Map<String, dynamic> body = {"page": event.page};
    final result = await repository.fetchProduct(url: url, body: body);

    result.fold(
      (l) => emit(state.copyWith(status: l.status, msg: l.msg)),
      (r) => emit(state.copyWith(status: r.status, msg: r.msg, product: r.result)),
    );
  }

}
