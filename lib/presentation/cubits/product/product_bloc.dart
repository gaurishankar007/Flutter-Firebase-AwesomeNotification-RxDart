import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  loadProduct() => emit(ProductLoadedState(
        name: "Product",
        price: "Rs. 1500",
        description:
            "What is a product description? A product description is the marketing copy that explains what a product is and why it's worth purchasing. The purpose of a product description is to supply customers with important information about the features and key benefits of the product so they're compelled to buy.",
      ));
}
