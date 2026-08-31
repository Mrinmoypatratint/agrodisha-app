import 'dart:async';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:eClassify/Utils/ui_utils.dart';
import 'package:eClassify/exports/main_export.dart';
import 'package:flutter/material.dart';
import '../../../../Utils/AppIcon.dart';
import '../../../../Utils/sliver_grid_delegate_with_fixed_cross_axis_count_and_fixed_height.dart';
import '../../../../data/model/item/item_model.dart';
import '../../../../data/model/item_filter_model.dart';
import '../../Widgets/AnimatedRoutes/blur_page_route.dart';
import '../../Widgets/Errors/no_data_found.dart';
import '../../Widgets/shimmerLoadingContainer.dart';
import '../../main_activity.dart';
import 'home_sections_adapter.dart';

class ProductsListScreen extends StatefulWidget {
  final String categoryId, categoryName;
  final List<String> categoryIds;

  const ProductsListScreen(
      {super.key,
        required this.categoryId,
        required this.categoryName,
        required this.categoryIds});

  @override
  ProductsListScreenState createState() => ProductsListScreenState();

  static Route route(RouteSettings routeSettings) {
    Map? arguments = routeSettings.arguments as Map?;
    return BlurredRouter(
      builder: (_) => ProductsListScreen(
        categoryId: arguments?['catID'] as String,
        categoryName: arguments?['catName'],
        categoryIds: arguments?['categoryIds'],
      ),
    );
  }
}

class ProductsListScreenState extends State<ProductsListScreen> {
  late ScrollController controller;
  bool isFocused = false;
  bool isList = true;
  String previousSearchQuery = "";
  String? sortBy;
  ItemFilterModel? filter;

  @override
  void initState() {
    super.initState();
    print("from product page ${widget.categoryId} ${widget.categoryName}");
    controller = ScrollController()..addListener(_loadMore);
    context.read<FetchItemFromCategoryCubit>().fetchItemFromCategory(
        categoryId: int.parse(
          widget.categoryId,
        ),
        search: "");

    Future.delayed(Duration.zero, () {
      selectedcategoryId = widget.categoryId;
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.removeListener(_loadMore);
    controller.dispose();
    super.dispose();
  }

  void _loadMore() async {
    if (controller.isEndReached()) {
      if (context.read<FetchItemFromCategoryCubit>().hasMoreData()) {
        context.read<FetchItemFromCategoryCubit>().fetchItemFromCategoryMore(
            catId: int.parse(
              widget.categoryId,
            ),
            sortBy: sortBy, search: '');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return bodyWidget();
  }


  Widget bodyWidget() {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      body: Column(
        children: [
          Expanded(child: fetchItems()),
        ],
      ),
    );
  }

  Widget fetchItems() {
    return BlocBuilder<FetchItemFromCategoryCubit, FetchItemFromCategoryState>(
        builder: (context, state) {
          if (state is FetchItemFromCategoryInProgress) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              itemCount: 10,
              itemBuilder: (context, index) {
                return buildItemsShimmer(context);
              },
            );
          }

          if (state is FetchItemFromCategoryFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          if (state is FetchItemFromCategorySuccess) {
            if (state.itemModel.isEmpty) {
              return Center(
                child: NoDataFound(
                  onTap: () {
                    context
                        .read<FetchItemFromCategoryCubit>()
                        .fetchItemFromCategory(
                        categoryId: int.parse(
                          widget.categoryId,
                        ),
                        search: "");
                  },
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 5),
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                        crossAxisCount: 2,
                        height: MediaQuery.of(context).size.height /
                            5.0.rh(context),
                        mainAxisSpacing: 7,
                        crossAxisSpacing: 10),
                    itemCount: state.itemModel.length,
                    itemBuilder: (context, index) {
                      ItemModel item = state.itemModel[index];
                      return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.adDetailsScreen,
                              arguments: {
                                'model': item,
                              },
                            );
                          },
                          child: ItemCard(
                            item: item,
                          ));
                    },
                  ),
                ),
                if (state.isLoadingMore) UiUtils.progress()
              ],
            );
          }
          return Container();
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
