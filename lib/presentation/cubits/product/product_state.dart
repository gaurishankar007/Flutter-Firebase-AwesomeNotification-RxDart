part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoadedState extends ProductState {
  final String name;
  final String price;
  final String description;
  const ProductLoadedState({
    required this.name,
    required this.price,
    required this.description,
  });

  @override
  List<Object> get props => [
        name,
        price,
        description,
      ];
}
