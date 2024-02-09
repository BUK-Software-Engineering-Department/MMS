import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mms/old/main.dart';

class FirebaseAPI {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();

    // ignore: avoid_print
    print('Token: $token');

    initPushNotifications();
  }

  void handleMessages(RemoteMessage? message) {
    if (message == null) return;

    navigationKey.currentState!.pushNamed(
      '/notification',
      arguments: message,
    );
  }

  Future<void> initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessages);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);
  }
}
