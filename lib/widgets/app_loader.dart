// ignore_for_file: must_be_immutable, camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../constant/app_colors.dart';

Widget appLoader(
    {required Color loaderColor,
    double? height,
    double? width,
    bool onWillPop = true,
    bool giveOpacity = true}) {
  return WillPopScope(
    onWillPop: () async => onWillPop,
    child: Scaffold(
      body: InkWell(
        child: Container(
          alignment: Alignment.center,
          color: giveOpacity
              ? AppColors.black.withOpacity(0.5)
              : AppColors.transparent,
          child: SizedBox(
            height: height ?? 60.h,
            width: width ?? 60.w,
            child: LoadingIndicator(
              indicatorType: Indicator.ballScaleMultiple,
              colors: [loaderColor],
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    ),
  );
}

class listeningLoader extends StatefulWidget {
  Function() onTap;

  listeningLoader({super.key, required this.onTap});

  @override
  _listeningLoaderState createState() => _listeningLoaderState();
}

class _listeningLoaderState extends State<listeningLoader>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _animation!,
        child: Container(
          width: 150.0,
          height: 150.0,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.customerMain,
          ),
          child: Container(
            width: 150.0,
            height: 150.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.customerMain,
            ),
            child: Icon(
              Icons.mic,
              size: 50.sp,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
