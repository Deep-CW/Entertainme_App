import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constant/app_colors.dart';
import 'app_loader.dart';

Widget appNetworkImage(
    {required String url,
    required Color loaderColor,
    required double errorIconSize,
    int? maxHeightDiskCache,
    int? maxWidthDiskCache,
    required Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder,
    double? height,
    double? width}) {
  return CachedNetworkImage(
    imageUrl: url,
    imageBuilder: imageBuilder,
    placeholder: (context, url) => appLoader(
        loaderColor: loaderColor,
        height: height,
        width: width,
        giveOpacity: false),
    maxHeightDiskCache: maxHeightDiskCache,
    maxWidthDiskCache: maxWidthDiskCache,
    errorWidget: (context, url, error) => Center(
      child: Icon(
        Icons.error,
        size: errorIconSize,
        color: AppColors.red,
      ),
    ),
  );
}
