// // import 'dart:io';
// //
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:get/get.dart';
// //
// // import '../widgets/app_snackbar.dart';
// //
// // class NotificationServices {
// //
// //   static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //   FlutterLocalNotificationsPlugin();
// //
// //   static NotificationDetails? platformChannelSpecifics;
// //   static var channelId = DateTime.now().millisecond.toString(); //"EntertainMe_ChannelID";
// //   static var channelName = //"noti_push_app_1";
// //   DateTime.now().millisecond.toString(); //"EntertainMe_ChannelNAME";
// //
// //   static bool _isNotificationRegistered = false;
// //
// //   static notificationPermission(BuildContext context) async {
// //     FirebaseMessaging _messaging = FirebaseMessaging.instance;
// //     NotificationSettings settings = await _messaging.requestPermission(
// //       alert: true,
// //       badge: true,
// //       provisional: false,
// //       sound: true,
// //     );
// //     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
// //       print("User granted NOTIFICATION permission");
// //     } else {
// //       print("User declined or has not accepted NOTIFICATION permission");
// //     }
// //    // registerNotification(context);
// //   }
// //
// //
// //
// //   static registerNotification(BuildContext context) async {
// //     print("GET BOOLLLLLLL $_isNotificationRegistered");
// //     if (_isNotificationRegistered) {
// //       getNotificationDetails();
// //
// //       const AndroidInitializationSettings initializationSettingsAndroid =
// //       AndroidInitializationSettings('@mipmap/ic_launcher');
// //       // final IOSInitializationSettings initializationSettingsIOS =
// //       // IOSInitializationSettings(
// //       //     requestAlertPermission: true, requestSoundPermission: true);
// //
// //       final InitializationSettings initializationSettings = InitializationSettings(
// //         android: initializationSettingsAndroid,
// //         // iOS: initializationSettingsIOS,
// //       );
// //       await flutterLocalNotificationsPlugin.initialize(initializationSettings,
// //           onDidReceiveNotificationResponse: (v) {
// //             if (v.payload != null) {
// //               print("PAYLOAD :::::::");
// //               // Get.toNamed(Routes.MENU_REQUEST);
// //             }
// //             // },
// //             // onSelectNotification: (String? payload) async {
// //             //   if (payload != null) {
// //             //     Get.toNamed(Routes.MENU_REQUEST);
// //             //   }
// //           });
// //
// //       FirebaseMessaging.onBackgroundMessage(messageHandler);
// //       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //         var title = "EntertainMe";
// //         var body = "";
// //         if (message.notification != null) {
// //           title = message.notification!.title ?? "EntertainMe";
// //           body = message.notification!.body ?? "";
// //         } else {
// //           title = message.data["title"] ?? "EntertainMe";
// //           body = message.data["body"] ?? "";
// //         }
// //         print("GET MESSGAE FORM SNAKC BAR :::: ${message.data}  ::: ${message
// //             .notification!.title}");
// //         // RequestInboxController _requestInboxController = Get.put(RequestInboxController());
// //         // _requestInboxController.handleSocket(
// //         //     data["storeResponse"], data["reqId"]);
// //         // getNotificationDetails();
// //         if (!Get.isSnackbarOpen) {
// //           appSnackbar(content: body);
// //           // successSnackBar(
// //           //     title: title,
// //           //     message: body,
// //           //     onClick: () {
// //           //       Map<String, dynamic> data = message.data;
// //           //       Get.toNamed(Routes.MENU_REQUEST,
// //           //           arguments: {"req_id": data["req_id"]});
// //           //     });
// //           // final assetsAudioPlayer = eos.AssetsAudioPlayer();
// //           // assetsAudioPlayer.open(
// //           //   eos.Audio("assets/notification_sound.mp3"),
// //           // );
// //
// //           //  assetsAudioPlayer.play();
// //           // _playNotificationSound();
// //         }
// //
// //         //"${message.data}".showLog("NOTIFICATION");
// //         print("NOTIFICATION${message.notification}");
// //       });
// //       FirebaseMessaging.onMessageOpenedApp.listen((message) {
// //         print("NOTIFICATION On OPEN APP");
// //         //   Get.toNamed(Routes.MENU_REQUEST);
// //         // final assetsAudioPlayer = eos.AssetsAudioPlayer();
// //         // assetsAudioPlayer.open(
// //         //   /eos.Audio("assets/notification_sound.mp3"),
// //         // );
// //         //
// //         // assetsAudioPlayer.play();
// //       });
// //
// //     }else{
// //       print("CANCEL THE NOTIFICATIONNN");
// //     }
// //
// //   }
// //
// //
// //   @pragma('vm:entry-point')
// // static  Future<void> messageHandler(RemoteMessage message) async {
// //     getNotificationDetails();
// //     // final assetsAudioPlayer = eos.AssetsAudioPlayer();
// //     // assetsAudioPlayer.open(
// //     //   eos.Audio("assets/notification_sound.mp3"),
// //     // );
// //
// //     // assetsAudioPlayer.play();
// //     var notificationId = DateTime.now().millisecond;
// //     var title = "EntertainMe";
// //     var body = "";
// //     var sound = "notification_sound.mp3";
// //     if (message.notification != null) {
// //       title = message.notification!.title ?? "EntertainMe";
// //       body = message.notification!.body ?? "";
// //       sound = message.notification!.android!.sound ?? sound;
// //     } else {
// //       title = message.data["title"] ?? "EntertainMe";
// //       body = message.data["body"] ?? "";
// //       sound = message.notification!.android!.sound ?? sound;
// //     }
// //
// //     flutterLocalNotificationsPlugin.show(
// //       notificationId,
// //       title,
// //       body,
// //       platformChannelSpecifics,
// //     );
// //     flutterLocalNotificationsPlugin.show(
// //       int.parse(channelId),
// //       title,
// //       body,
// //       platformChannelSpecifics,
// //     );
// //     //_playNotificationSound();
// //     // final prefs = await SharedPreferences.getInstance();
// //     // prefs.setBool(IS_REQUEST_NOTIFICATION, true);
// //     // Map<String, dynamic> data = message.data;
// //     // prefs.setString(NOTIFICATION_DATA, jsonEncode(data));
// //
// //     print("BG_NOTIFICATION ${message.notification}"); //.showLog("BG_NOTIFICATION");
// //   }
// //
// //
// //
// //   static getNotificationDetails() {
// //     if (platformChannelSpecifics == null) {
// //       print("THIS getNotificationDetails CALLED $channelId");
// //       AndroidNotificationDetails androidPlatformChannelSpecifics =
// //       AndroidNotificationDetails(
// //         channelId,
// //         channelName,
// //         channelDescription:
// //         "This notification channel will show important messages $channelId.",
// //         importance: Importance.max,
// //         priority: Priority.high,
// //         playSound: true,
// //         icon: "@mipmap/ic_launcher",
// //         sound: RawResourceAndroidNotificationSound('notification_sound'),
// //       );
// //       // IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(
// //       //     presentAlert: true,
// //       //     presentSound: true,
// //       //     sound: 'notification_sound.mp3');
// //       if (Platform.isAndroid) {
// //         platformChannelSpecifics =
// //             NotificationDetails(android: androidPlatformChannelSpecifics);
// //         print("ANDROID=> ${androidPlatformChannelSpecifics.playSound}");
// //         print("ANDROID 1=> ${androidPlatformChannelSpecifics.sound}");
// //       } else {
// //         // platformChannelSpecifics =
// //         //     NotificationDetails(iOS: iOSPlatformChannelSpecifics);
// //       }
// //     }
// //   }
// //
// //
// //  static Future<void> _cancelNotification() async {
// //     print("NOTIFICATION IS CANCEL");
// //     print("GET 8989898 $_isNotificationRegistered");
// //     _isNotificationRegistered=false;
// //     await flutterLocalNotificationsPlugin.cancelAll();
// //
// //
// //
// //   }
// //
// //  static  toggleNotification(bool isEnabled, BuildContext context) {
// //     print("ISENABLED::: ${isEnabled}");
// //     _isNotificationRegistered = isEnabled;
// //     if (isEnabled) {
// //       registerNotification(context);
// //     } else {
// //       _cancelNotification();
// //     }
// //   }
// // }

// //-------------------------------------------------------------------------------------------------------------------------------------

// import 'dart:async';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';

// import '../constant/app_constants.dart';
// import '../main.dart';
// import '../widgets/app_snackbar.dart';

// class NotificationServices {
//   static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static NotificationDetails? platformChannelSpecifics;
//   static var channelId = DateTime.now().millisecond.toString();
//   static var channelName = DateTime.now().millisecond.toString();
//   static StreamSubscription<RemoteMessage>? _messageSubscription;

//   static notificationPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       badge: true,
//       provisional: false,
//       sound: true,
//     );
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print("User granted NOTIFICATION permission");
//     } else {
//       print("User declined or has not accepted NOTIFICATION permission");
//     }
//     print(
//         "SHOW NOTIFICATIONNNNNNN::::: ${box.read(AppConstants.SHOW_NOTIFICATION)}");
//     if (box.read(AppConstants.SHOW_NOTIFICATION)) {
//       registerNotification();
//     }
//   }

//   static registerNotification() async {
//     //
//     // await flutterLocalNotificationsPlugin
//     //     .resolvePlatformSpecificImplementation<
//     //         AndroidFlutterLocalNotificationsPlugin>()
//     //     ?.createNotificationChannel(
//     //       AndroidNotificationChannel(
//     //         channelId,
//     //         channelName,
//     //         importance: Importance.max,
//     //       ),
//     //     );
//     getNotificationDetails();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//             requestAlertPermission: true, requestSoundPermission: true);

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsIOS);
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (v) {
//         if (v.payload != null) {
//           print("PAYLOAD :::::::");
//         }
//       },
//     );

//     FirebaseMessaging.onBackgroundMessage(messageHandler);

//     _messageSubscription =
//         FirebaseMessaging.onMessage.listen(_onMessageListener);
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       print("NOTIFICATION On OPEN APP");
//     });
//   }

//   static void _onMessageListener(RemoteMessage message) async {
//     var title = "EntertainMe";
//     var body = "";
//     if (message.notification != null) {
//       title = message.notification!.title ?? "EntertainMe";
//       body = message.notification!.body ?? "";
//     } else {
//       title = message.data["title"] ?? "EntertainMe";
//       body = message.data["body"] ?? "";
//     }
//     print(
//         "GET MESSAGE FROM SNACKBAR :::: ${message.data}  ::: ${message.notification!.title}");
//     if (!Get.isSnackbarOpen) {
//       appSnackbar(content: body);
//     }
//     print("NOTIFICATION${message.notification}");
//   }

//   @pragma('vm:entry-point')
//   static Future<void> messageHandler(RemoteMessage message) async {
//     //final box = GetStorage();

//     // bool showNotification = box.read(AppConstants.SHOW_NOTIFICATION) ?? false;
//     // print("SHOW_NOTIFICATION value: ");
//     // print(
//     //     "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH ${box.read(AppConstants.SHOW_NOTIFICATION) ?? false}");
//     // // if (showNotification) {
//     // print(
//     //     "99999999999999999999999999999999999999999999999999 ${box.read(AppConstants.SHOW_NOTIFICATION) ?? false}");
//     // const AndroidInitializationSettings initializationSettingsAndroid =
//     //     AndroidInitializationSettings('@mipmap/ic_launcher');
//     //
//     // final InitializationSettings initializationSettings =
//     //     InitializationSettings(
//     //   android: initializationSettingsAndroid,
//     // );
//     // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//     //     onDidReceiveNotificationResponse: (v) {
//     //   if (v.payload != null) {
//     //     print("PAYLOAD :::::::");
//     //   }
//     // }, onDidReceiveBackgroundNotificationResponse: (v) {
//     //   print("PAYLOAD ::::::: $v");
//     // });
//     // print(
//     //     "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH ${box.read(AppConstants.SHOW_NOTIFICATION) ?? false}");
//     // getNotificationDetails();
//     var notificationId = DateTime.now().millisecond;
//     var title = "EntertainMe";
//     var body = "";
//     var sound = "notification_sound.mp3";
//     if (message.notification != null) {
//       title = message.notification!.title ?? "EntertainMe";
//       body = message.notification!.body ?? "";
//       sound = message.notification!.android!.sound ?? sound;
//     } else {
//       title = message.data["title"] ?? "EntertainMe";
//       body = message.data["body"] ?? "";
//       sound = message.notification!.android!.sound ?? sound;
//     }

//     flutterLocalNotificationsPlugin.show(
//       notificationId,
//       title,
//       body,
//       platformChannelSpecifics,
//     );
//     flutterLocalNotificationsPlugin.show(
//       int.parse(channelId),
//       title,
//       body,
//       platformChannelSpecifics,
//     );
//     print("BG_NOTIFICATION ${message.notification}");
//     //}
//   }

//   static getNotificationDetails() {
//     if (platformChannelSpecifics == null) {
//       print("THIS getNotificationDetails CALLED $channelId");
//       AndroidNotificationDetails androidPlatformChannelSpecifics =
//           AndroidNotificationDetails(
//         channelId,
//         channelName,
//         channelDescription:
//             "This notification channel will show important messages $channelId.",
//         importance: Importance.max,
//         priority: Priority.high,
//         playSound: true,
//         icon: "@mipmap/ic_launcher",
//         sound: RawResourceAndroidNotificationSound('notification_sound'),
//       );
//       DarwinNotificationDetails iOSPlatformChannelSpecifics =
//           DarwinNotificationDetails(
//               presentAlert: true,
//               presentSound: true,
//               sound: 'notification_sound.mp3');
//       if (Platform.isAndroid) {
//         platformChannelSpecifics =
//             NotificationDetails(android: androidPlatformChannelSpecifics);
//         print("ANDROID=> ${androidPlatformChannelSpecifics.playSound}");
//         print("ANDROID 1=> ${androidPlatformChannelSpecifics.sound}");
//       } else {
//         platformChannelSpecifics =
//             NotificationDetails(iOS: iOSPlatformChannelSpecifics);
//       }
//     }
//   }

//   static Future<void> _cancelNotification() async {
//     print("NOTIFICATION IS CANCELLED");
//     box.write(AppConstants.SHOW_NOTIFICATION, false);
//     await FirebaseMessaging.instance.deleteToken();
//     await flutterLocalNotificationsPlugin.cancelAll();
//     box.remove(AppConstants.FCM_TOKEN);
//     _messageSubscription?.cancel();
//     _messageSubscription = null;
//   }

//   static toggleNotification(bool isEnabled, BuildContext context) async {
//     print(
//         "9898989898989898989898989898989898989898989898989898 ${box.read(AppConstants.SHOW_NOTIFICATION)}");
//     print("ISENABLED::: $isEnabled ${box.read(AppConstants.FCM_TOKEN)}");
//     if (isEnabled) {
//       if (box.read(AppConstants.FCM_TOKEN) == null) {
//         await FirebaseMessaging.instance.getToken().then((value) {
//           String? token = value;
//           box.write(AppConstants.FCM_TOKEN, token);
//           print("TOKEN :: $token");
//         });
//       }
//       registerNotification();
//     } else {
//       _cancelNotification();
//     }
//   }
// }

// //
// // import 'dart:async';
// // import 'package:entertainme/widgets/app_snackbar.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get_storage/get_storage.dart';
// //
// // import '../constant/app_constants.dart';
// //
// // class NotificationServices {
// //   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// //   static NotificationDetails? platformChannelSpecifics;
// //   static var channelId = DateTime.now().millisecond.toString();
// //    static var channelName = DateTime.now().millisecond.toString();
// //   static StreamSubscription<RemoteMessage>? _messageSubscription;
// //   static StreamSubscription<RemoteMessage>? _messageOpenedAppSubscription;
// //   static bool _isInitialized = false;
// //   static bool _isEnabled = true;
// //
// //   static notificationPermission(BuildContext context) async {
// //     FirebaseMessaging _messaging = FirebaseMessaging.instance;
// //     NotificationSettings settings = await _messaging.requestPermission(
// //       alert: true,
// //       badge: true,
// //       provisional: false,
// //       sound: true,
// //     );
// //     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
// //       print("User granted NOTIFICATION permission");
// //     } else {
// //       print("User declined or has not accepted NOTIFICATION permission");
// //     }
// //   }
// //
// //   static Future<void> initialize(BuildContext context) async {
// //     if (_isInitialized) return;
// //
// //     getNotificationDetails();
// //
// //     const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
// //
// //     final InitializationSettings initializationSettings = InitializationSettings(
// //       android: initializationSettingsAndroid,
// //     );
// //     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
// //         onDidReceiveNotificationResponse: (response) {
// //           if (response.payload != null) {
// //             print("PAYLOAD ::::::: ${response.payload}");
// //           }
// //         });
// //
// //     _isInitialized = true;
// //   }
// //
// //   static void getNotificationDetails() {
// //     if (platformChannelSpecifics == null) {
// //       final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
// //         channelId,
// //         channelName,
// //         channelDescription: "This channel is used for important notifications.",
// //         importance: Importance.max,
// //         priority: Priority.high,
// //         playSound: true,
// //         icon: "@mipmap/ic_launcher",
// //         sound: RawResourceAndroidNotificationSound('notification_sound'),
// //       );
// //
// //       platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
// //     }
// //   }
// //
// //   static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //     final box = GetStorage();
// //     bool showNotification = box.read(AppConstants.SHOW_NOTIFICATION) ?? false;
// //
// //     print("SHOW_NOTIFICATION value: $showNotification");
// //
// //     if (showNotification) {
// //       getNotificationDetails();
// //
// //       final RemoteNotification? notification = message.notification;
// //       final AndroidNotification? android = notification?.android;
// //       if (notification != null && android != null) {
// //         flutterLocalNotificationsPlugin.show(
// //           notification.hashCode,
// //           notification.title,
// //           notification.body,
// //           platformChannelSpecifics,
// //         );
// //       }
// //     }
// //   }
// //
// //   static Future<void> registerNotification(BuildContext context) async {
// //     await initialize(context);
// //
// //     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
// //
// //     _messageSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //       final RemoteNotification? notification = message.notification;
// //       final AndroidNotification? android = notification?.android;
// //       if (notification != null && android != null) {
// //         appSnackbar(content: message.notification!.title.toString());
// //         flutterLocalNotificationsPlugin.show(
// //           notification.hashCode,
// //           notification.title,
// //           notification.body,
// //           platformChannelSpecifics,
// //         );
// //       }
// //     });
// //
// //     _messageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
// //       print("NOTIFICATION On OPEN APP: ${message.notification?.title}");
// //     });
// //   }
// //
// //   static Future<void> _cancelNotification() async {
// //     await flutterLocalNotificationsPlugin.cancelAll();
// //     _messageSubscription?.cancel();
// //     _messageOpenedAppSubscription?.cancel();
// //     _messageSubscription = null;
// //     _messageOpenedAppSubscription = null;
// //     _isInitialized = false;
// //   }
// //
// //   static Future<void> toggleNotification(bool isEnabled, BuildContext context) async {
// //     final box = GetStorage();
// //     _isEnabled = isEnabled;
// //     box.write(AppConstants.SHOW_NOTIFICATION, _isEnabled);
// //
// //     if (isEnabled) {
// //       await registerNotification(context);
// //     } else {
// //       await _cancelNotification();
// //     }
// //   }
// // }

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/app_snackbar.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static notificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else {
      print("User declined or has not accepted permission");
      appSnackbar(error: true, content: 'Please allow permission');
      await openAppSettings();
    }

    notificationsSetting();
  }

  static notificationsSetting() async {
    await init();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('getInitialMessage');
        //code for navigation
        // Get.to(() => DashboardScreen());
        // Get.find<DashboardController>().tabController?.animateTo(4);
      }
    });
    FirebaseMessaging.onMessage.listen((message) {
      //when app in foreground
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
      }
      // NotificationService.showNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('onMessageOpenedApp');
      //code for navigatio
      // Get.to(() => DashboardScreen());
      // Get.find<DashboardController>().tabController?.animateTo(4);
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(message) async {
    print('_firebaseMessagingBackgroundHandler');
    // you can do any stuffs that should work when notification comes in background

    // Be aware that this task should not take too much time, unless it would be skipped in OS
    // GetStorage storage = GetStorage();
    // var ct = await message.messageType;
    // print('ct ${ct.toString()}');

    // if (message.notification?.body != null) {
    // print('object');
    // int badge = (box.read(badgeCount) ?? 0) + 1;
    // box.write(badgeCount, badge);
    // }
  }

  static Future init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(
      settings,
      // onDidReceiveBackgroundNotificationResponse: (details) {
      //   print('onDidReceiveBackgroundNotificationResponse');
      // },
      // onDidReceiveNotificationResponse: (payload) async {
      //   print('onDidReceiveNotificationResponse');
      //code for navigation
      // Get.to(() => DashboardScreen());
      // Get.find<DashboardController>().tabController?.animateTo(4);
      // },
    );
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'EntertainMe',
        'EntertainMe',
        importance: Importance.max,
      ),
    );
  }

  // static Future showNotification(RemoteMessage message) async {
  //   final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  //   return _notifications.show(
  //     id,
  //     message.notification!.title,
  //     message.notification!.body,
  //     await _notificationDetails(),
  //   );
  // }
}
