import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/constant.dart';
import '../../cubits/product/product_bloc.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final formKey = GlobalKey<FormState>();
  int activeIndex = 0;
  int tabIndex = 0;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color surface = Theme.of(context).colorScheme.surface;
    Color onSurface = Theme.of(context).colorScheme.onSurface;

    return BlocProvider(
      create: (context) => ProductCubit()..loadProduct(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Product Detail"),
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            BlocProvider.of<ProductCubit>(context).loadProduct();

            if (state is ProductLoadedState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: sWidth(context) * .04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: surface,
                              borderRadius:
                                  BorderRadius.circular(bBorderRadius),
                              boxShadow: [
                                BoxShadow(
                                  color: onSurface.withOpacity(.05),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.name,
                                  style: kLTextStyle,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  state.price,
                                  style: kTextStyle,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.deliveryHint,
                                  style: disabledTextStyle,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.priceHint,
                                  style: disabledTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => setState(() {
                                            if (quantity == 1) return;
                                            quantity--;
                                          }),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: secondary,
                                            padding: EdgeInsets.all(3),
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            minimumSize: Size.zero,
                                            shape: CircleBorder(),
                                          ),
                                          child: Icon(
                                            Icons.remove,
                                            size: 18,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Text(
                                            quantity.toString(),
                                            style: TextStyle(
                                              color: onSurface,
                                              fontSize: h6["size"],
                                              fontWeight: subtitle2["weight"],
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => setState(() {
                                            quantity++;
                                          }),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: secondary,
                                            padding: EdgeInsets.all(3),
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            minimumSize: Size.zero,
                                            shape: CircleBorder(),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.shopping_cart_rounded,
                                        color: primary,
                                        size: iconSize,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => setState(() {
                                  tabIndex = 0;
                                }),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: tabIndex == 0
                                        ? secondary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                        cBorderRadius * 2),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.description,
                                    style: TextStyle(
                                      color:
                                          tabIndex == 0 ? surface : onSurface,
                                      fontSize: subtitle1["size"],
                                      fontWeight: subtitle2["weight"],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() {
                                  tabIndex = 1;
                                }),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: tabIndex == 1
                                        ? secondary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                        cBorderRadius * 2),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.review,
                                    style: TextStyle(
                                      color:
                                          tabIndex == 1 ? surface : onSurface,
                                      fontSize: subtitle1["size"],
                                      fontWeight: subtitle2["weight"],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() {
                                  tabIndex = 2;
                                }),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: tabIndex == 2
                                        ? secondary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                        cBorderRadius * 2),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .additionalInfo,
                                    style: TextStyle(
                                      color:
                                          tabIndex == 2 ? surface : onSurface,
                                      fontSize: subtitle1["size"],
                                      fontWeight: subtitle2["weight"],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (tabIndex == 0)
                            Container(
                              padding: EdgeInsets.all(10),
                              width: double.maxFinite,
                              height: 100,
                              decoration: BoxDecoration(
                                color: surface,
                                borderRadius:
                                    BorderRadius.circular(bBorderRadius),
                                boxShadow: [
                                  BoxShadow(
                                    color: onSurface.withOpacity(.05),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  state.description,
                                  style: TextStyle(
                                    color: onSurface,
                                    fontSize: subtitle1["size"],
                                    fontWeight: subtitle2["weight"],
                                  ),
                                ),
                              ),
                            ),
                          if (tabIndex == 1)
                            Container(
                              padding: EdgeInsets.all(10),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: surface,
                                borderRadius:
                                    BorderRadius.circular(bBorderRadius),
                                boxShadow: [
                                  BoxShadow(
                                    color: onSurface.withOpacity(.05),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Builder(builder: (context) {
                                return Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .name,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .name,
                                        ),
                                        onChanged: (value) {},
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .email,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .emailHint,
                                        ),
                                        onChanged: (value) {},
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .experience,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .experienceHint,
                                          alignLabelWithHint: true,
                                        ),
                                        onChanged: (value) {},
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (formKey.currentState!
                                              .validate()) {}
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                primary,
                                                primary.withOpacity(.7),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                cBorderRadius * 3),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.1),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .post,
                                              style: TextStyle(
                                                color: surface,
                                                fontSize: subtitle1["size"],
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          if (tabIndex == 2)
                            Container(
                              padding: EdgeInsets.all(10),
                              width: double.maxFinite,
                              height: 100,
                              decoration: BoxDecoration(
                                color: surface,
                                borderRadius:
                                    BorderRadius.circular(bBorderRadius),
                                boxShadow: [
                                  BoxShadow(
                                    color: onSurface.withOpacity(.05),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.additionalInfo,
                                  style: TextStyle(
                                    color: onSurface,
                                    fontSize: subtitle1["size"],
                                    fontWeight: subtitle2["weight"],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
