import 'package:equatable/equatable.dart';
import 'package:farmer_brand/Model/ProductByIdModel.dart';
import 'package:farmer_brand/Repository/ProductRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../Services/LocalStorage.dart';
part 'ProductByIdEvent.dart';
part 'ProductByIdState.dart';

class ProductByIdBloc extends Bloc<ProductByIdEvent, ProductByIdState> {
  final ProductRepo repository;
  ProductByIdBloc(this.repository) : super(ProductByIdState.initial()) {
    on<ProductById>(_getProductById);
  }

  _getProductById(ProductById event,Emitter<ProductByIdState> emit) async{
    emit(state.copyWith(status: ProductByIdStatus.loading));
    String url = '${dotenv.env['BASE_URL']}${dotenv.env["PRODUCT_BY_ID"]}';
    String? uid=await LocalStorage().getUID();
    Map<String, dynamic> body = {"fid": event.id,"uid":uid};
    final result = await repository.productById(url: url, body: body);
    Future.delayed(Duration(seconds: 1));
    result.fold(
          (l) => emit(state.copyWith(status: l.status, msg: l.msg)),
          (r) => emit(state.copyWith(status: r.status, msg: r.msg, product: r.result)),
    );

  }
}
