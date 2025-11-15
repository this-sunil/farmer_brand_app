part of 'ProductByIdBloc.dart';

abstract class ProductByIdEvent extends Equatable{}

class ProductById extends ProductByIdEvent{
  final String id;
  ProductById({required this.id});
  @override
  // TODO: implement props
  List<Object?> get props => [id];
}