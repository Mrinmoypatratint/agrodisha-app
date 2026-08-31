import 'dart:async';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:eClassify/Utils/ui_utils.dart';
import 'package:eClassify/exports/main_export.dart';
import 'package:flutter/material.dart';
import '../../../../Utils/sliver_grid_delegate_with_fixed_cross_axis_count_and_fixed_height.dart';
import '../../../../data/model/item/item_model.dart';
import '../../../../data/model/item_filter_model.dart';
import '../../../data/model/products.dart';
import '../Home/Widgets/home_sections_adapter.dart';
import '../widgets/AnimatedRoutes/blur_page_route.dart';
import '../widgets/Errors/no_data_found.dart';
import '../widgets/shimmerLoadingContainer.dart';

class AllProductsListScreen extends StatefulWidget {
  List productList;

  AllProductsListScreen({required this.productList});

  @override
  AllProductsListScreenState createState() => AllProductsListScreenState();
}

class AllProductsListScreenState extends State<AllProductsListScreen> {
  bool isFocused = false;
  // late AllProductLists productLists;



  @override
  void initState() {
    super.initState();
    // getAllProductListData();
  }

  // Future getAllProductListData()async{
  //   await context.read<FetchItemFromCategoryCubit>().fetchAllProducts().then((value){
  //    setState(() {
  //      productLists = value!;
  //    });
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return bodyWidget();
  }


  Widget bodyWidget() {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      body: Expanded(child: fetchItems()),
    );
  }

  Widget fetchItems() {
    return BlocBuilder<FetchItemFromCategoryCubit, FetchItemFromCategoryState>(
        builder: (context, state) {
          // if (state is FetchItemFromCategoryInProgress) {
          //   return ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          //     itemCount: 10,
          //     itemBuilder: (context, index) {
          //       return buildItemsShimmer(context);
          //     },
          //   );
          // }
          //
          // if (state is FetchItemFromCategoryFailure) {
          //   return Center(
          //     child: Text(state.errorMessage),
          //   );
          // }
          // if (state is FetchItemFromCategorySuccess) {
          //   if (state.itemModel.isEmpty) {
          //     return Center(
          //       child: NoDataFound(
          //         onTap: () {
          //           context
          //               .read<FetchItemFromCategoryCubit>()
          //               .fetchAllProducts();},
          //       ),
            //   );
            // }
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 5),
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                        crossAxisCount: 2,
                        height: MediaQuery.of(context).size.height /
                            5.0.rh(context),
                        mainAxisSpacing: 7,
                        crossAxisSpacing: 10),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      // var item = productLists.data[index].subcategory;
                      return Container();

                      //   Column(
                      //   children: [
                      //     GestureDetector(
                      //         onTap: () {
                      //           Navigator.pushNamed(
                      //             context,
                      //             Routes.adDetailsScreen,
                      //             arguments: {
                      //               'model': item,
                      //             },
                      //           );
                      //         },
                      //         child: AllItemCard(
                      //           item: item,
                      //         )),
                      //   ],
                      // );
                    },
                  ),
                ),
                // if (state.isLoadingMore) UiUtils.progress()
              ],
            );
          // }
          // return Container();
        });
  }

  Widget buildItemsShimmer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120.rh(context),
        decoration: BoxDecoration(
            border: Border.all(width: 1.5, color: context.color.borderColor),
            color: context.color.secondaryColor,
            borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            CustomShimmer(
              height: 120.rh(context),
              width: 100.rw(context),
            ),
            SizedBox(
              width: 10.rw(context),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomShimmer(
                  width: 100.rw(context),
                  height: 10,
                  borderRadius: 7,
                ),
                CustomShimmer(
                  width: 150.rw(context),
                  height: 10,
                  borderRadius: 7,
                ),
                CustomShimmer(
                  width: 120.rw(context),
                  height: 10,
                  borderRadius: 7,
                ),
                CustomShimmer(
                  width: 80.rw(context),
                  height: 10,
                  borderRadius: 7,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}