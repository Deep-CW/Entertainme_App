import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../constant/app_colors.dart';
import '../../../../../constant/app_strings.dart';
import '../../../../../constant/app_urls.dart';
import '../../../../../services/api_service.dart';
import '../../../../../widgets/app_appbar.dart';
import '../../../../../widgets/app_network_image.dart';
import '../../../../../widgets/app_snackbar.dart';
import '../../../../../widgets/app_text.dart';
import 'category_controller.dart';
import 'category_show_screen.dart';

class CategorySeeAllScreen extends StatefulWidget {
  const CategorySeeAllScreen({super.key});

  @override
  State<CategorySeeAllScreen> createState() => _CategorySeeAllScreenState();
}

class _CategorySeeAllScreenState extends State<CategorySeeAllScreen> {
  CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: AppColors.white,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: appAppBar(
            title: AppStrings.categories,
            onTap: () {
              Get.back();
            }),
        body: SmartRefresher(
          enablePullDown: true,
          controller: categoryController.categoryRefreshController,
          onRefresh: () {
            if (APIService.internet) {
              categoryController.getCategory();
            } else {
              appSnackbar(
                error: true,
                content: AppStrings.no_internet,
              );
            }
            categoryController.categoryRefreshController.refreshCompleted();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            child: Obx(
              () => GridView.builder(
                itemCount: categoryController.categories.length,
                shrinkWrap: true,
                cacheExtent: 1000,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 14.w,
                    mainAxisSpacing: 14.h,
                    childAspectRatio: 0.9),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final category = categoryController.categories[index];
                  return InkWell(
                    onTap: () {
                      Get.delete<CategoryController>();
                      Get.to(() => CateShowScreen(), arguments: {
                        "categories": categoryController.categories,
                        "allBusiness": categoryController.allBusinesses,
                        "current_index": index,
                        "category_name": category.catName.toString(),
                        "category_id": category.catId.toString()
                      });
                    },
                    child: Container(
                      height: 90.h,
                      width: 125.w,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.25),
                              blurRadius: 4.r,
                            )
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          appNetworkImage(
                            url:
                                "${AppUrls.BASE_API}${category.catImg.toString()}",
                            loaderColor: AppColors.customerMain,
                            height: 20.h,
                            width: 20.w,
                            errorIconSize: 15.sp,
                            imageBuilder: (context, imageProvider) => Container(
                              width: 54.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                image: DecorationImage(
                                    fit: BoxFit.contain, image: imageProvider),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 90.w,
                            ),
                            child: appText(category.catName.toString(),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.lightBlack,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
