import 'dart:developer';

import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/material.dart';

import '../../features/notification/views/test_notification.dart';
import '../../main.dart';

/*
  🚚 How to Migrate firebase_messaging Plugin
  
  FirebaseMessaging.onMessageOpenedApp 
  -> AwesomeNotifications.getInitialNotificationAction()
  FirebaseMessaging.onMessage 
  -> static Future<void> onActionReceivedMethod(ReceivedAction receivedAction)
  FirebaseMessaging.onBackgroundMessage -> 
    static Future<void> mySilentDataHandle(FcmSilentData silentData)
  FirebaseMessaging.requestPermission -> 
    AwesomeNotifications().requestPermissionToSendNotifications()
*/

class FirebaseNotificationService {
  /// ************************************
  /// INITIALIZE FIREBASE NOTIFICATIONS
  /// ************************************

  static Future<void> initializeFirebaseNotifications() async {
    await AwesomeNotificationsFcm().initialize(
      // Use this method to detect when a new fcm token is received
      onFcmTokenHandle: myFcmTokenHandle,
      // Use this method to detect when a new native token is received
      onNativeTokenHandle: myNativeTokenHandle,
      // Use this method to execute on background when a silent data arrives
      onFcmSilentDataHandle: mySilentDataHandle,
      licenseKeys: null,
    );
  }

  static Future<void> myFcmTokenHandle(String token) async {
    log("FCM TOKEN: $token");
  }

  static Future<void> myNativeTokenHandle(String token) async {
    log("NATIVE TOKEN: $token");
  }

  // Initializes the plugin, setting the [onFcmTokenHandle] and [onFcmSilentDataHandle]
  // listeners to capture Firebase Messaging events and the [licenseKeys] necessary
  // to validate the release use of this plugin.
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    log("Silent data received: ${silentData.toString()}");

    // Navigate to the test notification screen
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => TestNotification(
          goBack: () {},
        ),
      ),
    );
  }

  /// ***********************
  /// REQUEST FCM TOKEN
  /// ***********************

  static Future<String> requestFirebaseToken() async {
    bool isFirebaseAvailable = await AwesomeNotificationsFcm().isFirebaseAvailable;
    if (isFirebaseAvailable) {
      return await AwesomeNotificationsFcm().requestFirebaseAppToken();
    } else {
      log('Firebase is not available on this project');
    }

    return '';
  }

  static Future<void> deleteToken() async {
    await AwesomeNotificationsFcm().deleteToken();
  }
}
