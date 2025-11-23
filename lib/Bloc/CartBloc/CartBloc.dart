import 'package:equatable/equatable.dart';
import 'package:farmer_brand/Model/CartModel.dart';
import 'package:farmer_brand/Repository/CartRepository.dart';
import 'package:farmer_brand/Services/LocalStorage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


part 'CartEvent.dart';
part 'CartState.dart';

class CartBloc extends Bloc<CartEvent,CartState>{
  final CartRepository repository;
  CartBloc(this.repository):super(CartState.initial()){
    on<FetchCartEvent>(_fetchCart);
  }

  _fetchCart(FetchCartEvent event,Emitter<CartState> emit) async{
    emit(state.copyWith(status: CartStatus.loading));
    String? uid=await LocalStorage().getUID();
    String url="${dotenv.env['BASE_URL']}${dotenv.env["CART"]}";
    final result=await repository.fetchCart(url: url, body: {"uid":uid});
    result.fold((l)=>emit(state.copyWith(status: l.status,msg: l.msg)), (r)=>
      emit(state.copyWith(status: r.status,msg: r.msg,cartModel: r.result))
    );
  }
}