part of 'CartBloc.dart';
enum CartStatus {initial,loading,completed,error}
class CartState extends Equatable{
  final CartStatus? status;
  final String? msg;
  final CartModel? cartModel;
  const CartState({this.status,this.msg,this.cartModel});

  factory CartState.initial(){
    return CartState(status: CartStatus.initial);
  }

  CartState copyWith({CartStatus? status,String? msg,CartModel? cartModel}){
    return CartState(status: status??status,msg: msg??msg,cartModel: cartModel??cartModel);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status,msg,cartModel];
}