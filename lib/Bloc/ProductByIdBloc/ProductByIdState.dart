part of "ProductByIdBloc.dart";

enum ProductByIdStatus{initial,loading,completed,error}
class ProductByIdState extends Equatable{
  final ProductByIdStatus? status;
  final String? msg;
  final ProductByIdModel? product;

  const ProductByIdState({this.status, this.msg,this.product});

  factory ProductByIdState.initial()=>ProductByIdState(status: ProductByIdStatus.initial);

  ProductByIdState copyWith({ProductByIdStatus? status,String? msg,ProductByIdModel? product}){
    return ProductByIdState(status: status??status,msg: msg??msg,product: product??product);
  }
  @override
  // TODO: implement props
  List<Object?> get props => [status,msg,product];
}