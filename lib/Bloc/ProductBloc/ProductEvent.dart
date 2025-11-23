part of 'ProductBloc.dart';

abstract class ProductEvent extends Equatable{}
class FetchProduct extends ProductEvent{
  final String page;
  FetchProduct({required this.page});
  @override
  // TODO: implement props
  List<Object?> get props => [page];
}
class AddQuantity extends ProductEvent{
  final int qty;
  final String pid;
  AddQuantity({required this.pid,required this.qty});
  @override
  // TODO: implement props
  List<Object?> get props => [qty,pid];

}

