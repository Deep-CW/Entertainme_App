// ignore_for_file: deprecated_member_use, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constant/app_colors.dart';
import '../constant/app_constants.dart';
import '../widgets/app_choice_dialog.dart';
import '../widgets/app_snackbar.dart';

class ImageService {
  static micPermission() async {
    bool isGranted = await Permission.microphone.isGranted;

    if (isGranted) {
      return true;
    } else {
      var permission = await Permission.microphone.request();

      if (permission == PermissionStatus.granted) {
        return true;
      } else if (permission == PermissionStatus.denied) {
        permission = await Permission.microphone.request();
        return false;
      } else if (permission == PermissionStatus.permanentlyDenied) {
        appSnackbar(error: true, content: 'Please allow permission');
        await openAppSettings();
        return false;
      } else {
        appSnackbar(error: true, content: 'Please allow permission');
        await openAppSettings();
        return false;
      }
    }
  }

  static getPermission() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      AppConstants.Android_Version = androidInfo.version.release;
    }

    bool isAuth = await checkPermission();
    return isAuth;
  }

  //pick image
  static pickImage({required Color color}) async {
    // bool isAuth = await getPermission();
    // if (isAuth) {
    var pickedImage = await showChoiceDialog(color: color);
    return pickedImage;
    // }
  }

  //pick crop image
  static pickCropImage({required Color color}) async {
    bool isAuth = await getPermission();

    if (isAuth) {
      var pickedImage = await showChoiceDialog(color: color);

      if (pickedImage != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          cropStyle: CropStyle.rectangle,
          sourcePath: pickedImage,
          aspectRatioPresets: [
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: AppColors.businessMain,
                toolbarWidgetColor: AppColors.white,
                initAspectRatio: CropAspectRatioPreset.ratio5x3,
                lockAspectRatio: false),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
            ),
          ],
        );

        return croppedFile!.path;
      } else {
        return null;
      }
    }
  }

  //permission for image
  static checkPermission() async {
    var permission;

    if (Platform.isAndroid) {
      permission = int.parse(AppConstants.Android_Version) < 13
          ? await Permission.storage.request()
          : await Permission.photos.request();
    } else {
      permission = await Permission.storage.request();
    }

    if (permission == PermissionStatus.granted ||
        permission == PermissionStatus.limited) {
      return true;
    } else if (permission == PermissionStatus.denied) {
      appSnackbar(error: true, content: 'Please allow permission');
      Get.back();

      return false;
    } else if (permission == PermissionStatus.permanentlyDenied) {
      appSnackbar(error: true, content: 'Please allow permission');
      Get.back();
      await openAppSettings();
      return false;
    } else {
      appSnackbar(error: true, content: 'Please allow permission');
      Get.back();
      return false;
    }
  }

  static checkCameraPermission() async {
    var permission = await Permission.camera.request();

    if (permission == PermissionStatus.granted) {
      return true;
    } else if (permission == PermissionStatus.denied) {
      permission = await Permission.camera.request();
      return false;
    } else if (permission == PermissionStatus.permanentlyDenied) {
      appSnackbar(error: true, content: 'Please allow permission');
      Get.back();
      await openAppSettings();
      return false;
    }
    return false;
  }

  //open gallery
  static openGallery() async {
    bool isAuth = await getPermission();

    if (isAuth) {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      Get.back();

      if (pickedFile != null) {
        return pickedFile.path;
      } else {
        return null;
      }
    }
  }

  //open camera
  static openCamera() async {
    bool isAuth = await checkCameraPermission();

    if (isAuth) {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );

      Get.back();

      if (pickedFile != null) {
        return pickedFile.path;
      } else {
        return null;
      }
    }
  }
}
