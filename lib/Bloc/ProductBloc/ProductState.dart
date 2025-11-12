part of "ProductBloc.dart";
enum ProductStatus{initial,loading,completed,error}
class ProductState extends Equatable{
  final ProductStatus? status;
  final String? msg;
  final ProductModel? product;
  const ProductState({this.status, this.msg,this.product});

  factory ProductState.initial()=>ProductState();

  ProductState copyWith({ProductStatus? status,String? msg,ProductModel? product}){
    return ProductState(status: status??status,msg: msg??msg,product: product??product);
  }
  @override
  // TODO: implement props
  List<Object?> get props => [status,msg,product];
}