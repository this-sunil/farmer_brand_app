import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'ProductEvent.dart';
part 'ProductState.dart';
class ProductBloc extends Bloc<ProductEvent,ProductState>{
  ProductBloc():super(ProductState.initial()){
    on<FetchProduct>(_getAllProduct);
  }
  _getAllProduct(FetchProduct event,Emitter<ProductState> emit){

  }
}