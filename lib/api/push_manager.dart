import 'package:firebase_messaging/firebase_messaging.dart';

class PushManager {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print(message.notification);
  }
}