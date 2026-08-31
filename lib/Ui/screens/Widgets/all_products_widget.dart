import 'package:eClassify/Ui/screens/Home/home_screen.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:eClassify/Utils/ui_utils.dart';
import 'package:eClassify/data/model/item/item_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../data/model/category_model.dart';
import '../../../../exports/main_export.dart';
import '../../../Utils/sliver_grid_delegate_with_fixed_cross_axis_count_and_fixed_height.dart';
import '../../../data/model/products.dart';
import '../Home/Widgets/home_sections_adapter.dart';
import '../widgets/Errors/no_data_found.dart';
import '../widgets/promoted_widget.dart';

class AllProductsWidgetHome extends StatefulWidget {
  const AllProductsWidgetHome({super.key});

  @override
  State<AllProductsWidgetHome> createState() => _AllProductsWidgetHomeState();
}

class _AllProductsWidgetHomeState extends State<AllProductsWidgetHome> {
  List<dynamic> productLists = [];

  @override
  void initState() {
    // TODO: implement initState
    getAllProductListData();
    super.initState();
  }

  Future getAllProductListData() async {
    await context
        .read<FetchItemFromCategoryCubit>()
        .fetchAllProducts()
        .then((value) {
      setState(() {
        productLists = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      child: productLists != null
          ? ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: productLists.length,
              itemBuilder: (BuildContext context, int listIndex) {
                print("listIndexlistIndex ${productLists[listIndex]}");
                var data = widgetListData(
                  datalist: productLists[listIndex]["items"],
                  catId: productLists[listIndex]["id"],
                  catIndex: listIndex,
                );
                return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 24, bottom: 5),
                            child: Text(
                              "${"lblall".translate(context)}\t${productLists[listIndex]["name"]}",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                                .color(context.color.textDefaultColor)
                                .size(context.font.normal)
                                .bold(weight: FontWeight.w600),
                          ),

                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            height: data.length == 0 ? 0 : 180,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return data[index];
                                }),
                          )
                          // for (var i = 0; i < data.length; i++) data[i]
                        ]));
              })
          : Container(),
    );

    //   BlocBuilder<FetchCategoryCubit, FetchCategoryState>(
    //   builder: (context, state) {
    //     if (state is FetchCategorySuccess) {
    //       if (state.categories.isNotEmpty) {
    //         return ListView.builder(
    //           physics: NeverScrollableScrollPhysics(),
    //           itemCount: productLists?.data.length,
    //             itemBuilder: (BuildContext context, int index) {
    //          return  Padding(
    //             padding: const EdgeInsets.only(top: 12),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text("data1"),
    //                 Container(
    //                   height: 200,
    //                     child: AllProductsListScreen()
    //                 )]
    //             ));
    //                   } );}else {
    //         return Padding(
    //           padding: const EdgeInsets.all(50.0),
    //           child: NoDataFound(
    //             onTap: () {},
    //           ),
    //         );
    //       }
    //     }
    //     return Container();
    //   },
    // );
  }

  List<Widget> widgetListData({
    required List<dynamic> datalist,
    required int catId,
    required int catIndex,
  }) {
    List<Widget> widgetList = [];
    for (var i = 0; i < datalist.length; i++) {
      var listData = getProductList1(
          itemsData: datalist[i] ?? [],
          catIndex: i,
          catId: catId,
          id: datalist[i]["id"] ?? 0);
      for (var j = 0; j < listData.length; j++) widgetList.add(listData[j]);
    }
    return widgetList;
  }

  // GridView.builder(
  // shrinkWrap: true,
  // scrollDirection: Axis.vertical,
  // padding: const EdgeInsets.symmetric(
  // horizontal: 15, vertical: 5),
  // gridDelegate:
  // SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
  // crossAxisCount: 2,
  // height: MediaQuery.of(context).size.height /
  // 5.0.rh(context),
  // mainAxisSpacing: 7,
  // crossAxisSpacing: 10),
  // itemCount: datalist.length,
  // itemBuilder: (context, index) {
  // var item = datalist;
  // print("itemitem $item");
  // return Column(
  // children: [
  // GestureDetector(
  // onTap: () {
  // Navigator.pushNamed(
  // context,
  // Routes.adDetailsScreen,
  // // arguments: {
  // //   'model': item,
  // // },
  // );
  // },
  // child: Container(
  // child: Text("${item[index].name}"),
  // ),
  //
  // // AllItemCard(
  // //   item: item,
  // // )
  // ),
  // ],
  // );
  // },
  // ),

  List<Widget> getProductList1(
      {required Map<dynamic, dynamic> itemsData,
      required int catId,
      required int catIndex,
      required int id}) {
    List<Widget> widgetListData = [];
    widgetListData.add(SizedBox(
        child: Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: AllItemCard(
        item: itemsData,
        catId: catId,
        catIndex: catIndex,
        id: id,
      ),
    )));
    return widgetListData;
  }

// }
}
