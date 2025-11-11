part of "ProductBloc.dart";
enum ProductStatus{initial,loading,completed,error}
class ProductState extends Equatable{
  final ProductStatus? status;
  final String? msg;
  final dynamic result;
  const ProductState({this.status, this.msg,this.result});

  factory ProductState.initial()=>ProductState();

  ProductState copyWith({ProductStatus? status,String? msg,dynamic result}){
    return ProductState(status: status??status,msg: msg??msg,result: result??result);
  }
  @override
  // TODO: implement props
  List<Object?> get props => [status,msg,result];
}