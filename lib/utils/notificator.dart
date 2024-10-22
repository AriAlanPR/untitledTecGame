// import 'dart:async';

// import 'package:untitled_tec_game/utils/animations.dart';
// import 'package:untitled_tec_game/utils/untitled_tec_game_api.dart';
// import 'package:untitled_tec_game/views/asignaciones.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:untitled_tec_game/utils/loghandler.dart';

// //NOTE: Notification of untitled_tec_game app service

// class Notificator {
//   static final Notificator _instance =
//       Notificator._internal();
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   StreamSubscription<RemoteMessage>? _onMessageSubscription;
//   StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;


//   //NOTE: singleton constructor handle
//   factory Notificator() {
//     return _instance;
//   }
//   Notificator._internal();

//   //NOTE: Notification functions

//   /// Requests permission to receive notifications from Firebase Messaging.
//   Future<void> requestPermission() async {
//     try {
//       final settings = await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         provisional: false,
//       );

//       //start notification handlers if permission is granted
//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         myPrint("User granted permission");
//       } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//         myPrint("User granted provisional permission");
//       } else {
//         myPrint("User denied permission");
//       }
      
//       await setNotificationHandler();
//     } catch (e, stack) {
//       basicErrorHandle(e, stack);
//     }
//   }

//   /// Handles opening a URL based on the provided notification payload.
//   ///
//   /// Parameters:
//   /// - `title`: The title of the notification.
//   /// - `description`: The description of the notification.
//   /// - `payload`: The payload of the notification, containing the URL.
//   Future<void> _openUrlHandler(String title, String description, Map<String, dynamic> payload) async {
//     await Firebase.initializeApp();
//     myPrint("Got a fancy cool background/terminated notification: $title \n $description \n $payload");
//     //TODO - Improve this counter logic
//     PersistentData.increaseCounter(countKey: 'notification_count');
//     //no longer required since is better to redirect to "asignaciones"
//     // API.openUrl(payload['url']);
//   }

//   /// Adds the notification handler for FirebaseMessaging.
//   ///
//   /// This function handles foreground messages,
//   /// messages when the app is opened from a terminated state, and background
//   /// messages.
//   Future<void> setNotificationHandler() async {
//     if(_onMessageSubscription != null || _onMessageOpenedAppSubscription != null) {
//       return;
//     }

//     //subscribe to new notifications listeners
//     // Handle foreground messages
//     _onMessageSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       // Handle the foreground notification
//       final title = message.notification!.title!;
//       final description = message.notification!.body!;
//       final payload = message.data;

//       myPrint("Got a fancy cool foreground notification: $title \n $description \n $payload");
//       NotificationService().trigger(title: title, body: description, payload: payload);
//     });

//     // Handle messages when the app is opened from a terminated state
//     _onMessageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       // Handle the notification when the app is opened
//       _openUrlHandler(message.notification!.title!, message.notification!.body!, message.data);
//     });

//     // Handle background messages
//     FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
//       // Handle the notification when the app is in the background
//       _openUrlHandler(message.notification!.title!, message.notification!.body!, message.data);
//     });
//   }

//   /// Retrieves the device token from Firebase Messaging.
//   ///
//   /// Returns:
//   ///   A `Future<String?>` representing the device token. If an error occurs, it
//   ///   returns `null`.
//   Future<String?> getDeviceToken() async {
//     try {
//       return await _firebaseMessaging.getToken();
//     } catch (e, stack) {
//       basicErrorHandle(e, stack);
//       return null;
//     }
//   }

//   /// Unsubscribes the token from receiving notifications.
//   ///
//   /// Returns:
//   ///   A `Future<bool>` indicating whether the unsubscription was successful
//   ///   or not.
//   Future<bool> unsubscribeToken() async {
//     try {
//       //remove notification listener methods
//       // await _onMessageSubscription?.cancel();
//       // await _onMessageOpenedAppSubscription?.cancel();
//       //remove firebase subscribed token
//       await _firebaseMessaging.deleteToken();
//       return true;
//     } catch (e, stack) {
//       basicErrorHandle(e, stack);
//       return false;
//     }
//   }

//   /// Checks if the device has an APN token for Firebase Cloud Messaging.
//   ///
//   /// Returns:
//   ///   A `Future<bool>` representing whether Firebase has an APN token configured. If an
//   ///   error occurs, it returns `false`.
//   Future<bool> hasAPNToken() async {
//     try {
//       final apnsToken = await FirebaseMessaging.instance.getAPNSToken();

//       return apnsToken != null;
//     } catch (e, stack) {
//       basicErrorHandle(e, stack);
//       return false;
//     }
//   }

//    // In this example, suppose that all messages contain a data field with the key 'url'.
//    // 
//    // This evaluates on home page load whether the app has been opened through a push notification
//    // and opens the url related to the notification if it exists.
//   Future<void> setupInteractedMessage() async {
//     // Get any messages which caused the application to open from
//     // a terminated state.
//     RemoteMessage? message =
//         await FirebaseMessaging.instance.getInitialMessage();

//     // If the message also contains a data property with a "type" of "chat",
//     // navigate to a chat screen
//     if (message != null) {
//       myPrint("Got a message after opening foreground from background: ${message.data.toString()}");
//       _openUrlHandler(message.notification!.title!, message.notification!.body!, message.data);
//     }

//     // // Also handle any interaction when the app is in the background via a
//     // // Stream listener
//     // FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
//   }
// }

// //NOTE - Notification service

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//   int _notificationIdCounter = 0;

//   //NOTE: singleton constructor handle
//   factory NotificationService() {
//     return _instance;
//   }
//   NotificationService._internal();

//     /// Initializes the notification service.
//     /// 
//     /// Returns a [Future] that completes when the initialization is done.
//     ///
//     /// Throws an exception if there is an error during initialization.
//   Future<void> initialize() async {
//     try {
//       AndroidInitializationSettings initializationSettingsAndroid =
//           const AndroidInitializationSettings('@mipmap/ic_launcher');

//       var initializationSettingsIOS = DarwinInitializationSettings(
//           requestAlertPermission: true,
//           requestBadgePermission: true,
//           requestSoundPermission: true,
//           onDidReceiveLocalNotification:
//               (int id, String? title, String? body, String? payload) async {
//             // This will be called whenever a notification is delivered on the
//             // main 10 seconds interval            
//             myPrint("iOS log:: NotificationService: Received a local Notification:: Got a fancy cool background/terminated notification: $title \n $body \n $payload");
//           });

//       var initializationSettings = InitializationSettings(
//           android: initializationSettingsAndroid,
//           iOS: initializationSettingsIOS);

//       //onDidReceiveNotificationResponse receives a function that will be executed after clicking the notification either on ios and android
//       await notificationsPlugin.initialize(initializationSettings,
//           onDidReceiveNotificationResponse:
//               (NotificationResponse notificationResponse) async {
//         // Handle local notification taps here
//         final payload = API.fromJson(notificationResponse.payload);
//         myPrint("Mobile log:: NotificationService: Received a notification response: $payload");
        
//         //validate saved user tokens
//         final userTokens = await API.getTokenData();
//         final invalidNavigateValues = [null, "", "TRIAL"];
//         if(!(invalidNavigateValues.contains(userTokens['access_token']) || invalidNavigateValues.contains(userTokens['token_id']))) {
//           //go to main page
//           navigatorKey.currentState?.pushNamedAndRemoveUntil(
//             '/,
//             (route) => false,
//           );
//         }
//       },);
//     } catch (e, s) {
//       basicErrorHandle(e, s);
//     }
//   }

//   // Returns the initialization settings for the notification details for both Android and iOS platforms.
//   notificationDetails() {
//     const String groupKey = 'com.delbravotech.untitled_tec_game.NOTIFICATIONS';
    
//     return const NotificationDetails(
//         android: AndroidNotificationDetails('channelId', 'channelName',
//             channelDescription: 'groupedChannelDescription',
//             importance: Importance.max,
//             priority: Priority.high,
//             groupKey: groupKey,
//         ),
//         iOS: DarwinNotificationDetails(
//           threadIdentifier: 'untitled_tec_GameAppWrapper',
//         ));
//   }

  
//   /// Triggers a notification with the given title, body, and payload.
//   ///
//   /// The `title` and `body` parameters are optional and specify the title and body of the notification, respectively.
//   /// The `payload` parameter is a map that contains additional data to be sent with the notification.
//   ///
//   /// Returns a `Future` that completes when the notification is shown.
//   ///
//   /// Example usage:
//   /// ```dart
//   /// await trigger(
//   ///   title: 'New message',
//   ///   body: 'You have a new message!',
//   ///   payload: {'messageId': 123},
//   /// );
//   /// ```
//   Future trigger(
//       {String? title, String? body, Map<String, dynamic>? payload}) async {
//     return notificationsPlugin.show(
//         _notificationIdCounter++, title, body, await notificationDetails(), payload: API.json(payload));
//   }
// }