import 'package:equatable/equatable.dart';
import 'package:farmer_brand/Model/ProductModel.dart';
import 'package:farmer_brand/Repository/ProductRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
part 'ProductEvent.dart';
part 'ProductState.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepo repository;
  ProductBloc(this.repository) : super(ProductState.initial()) {
    on<FetchProduct>(_getAllProduct);
  }
  _getAllProduct(FetchProduct event, Emitter<ProductState> emit) async {
    String url = '${dotenv.env['BASE_URL']}${dotenv.env["ALL_PRODUCT"]}';
    Map<String, dynamic> body = {"page": event.page};
    final result = await repository.fetchProduct(url: url, body: body);
    result.fold(
      (l) => emit(state.copyWith(status: l.status, msg: l.msg)),
      (r) => emit(state.copyWith(status: r.status, msg: r.msg, product: r.result)),
    );
  }
}
