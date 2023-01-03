import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:http/http.dart' as http;

class HomeController extends GetxController
{
  RxList userData = [].obs;

  FlutterLocalNotificationsPlugin? flnp;

  void notification()async
  {
     flnp = FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidSetting = AndroidInitializationSettings("app_icon");
    DarwinInitializationSettings iosSetting = DarwinInitializationSettings();

    InitializationSettings flutterSetting = InitializationSettings(android: androidSetting,iOS: iosSetting);

    tz.initializeTimeZones();
    await flnp!.initialize(flutterSetting);

  }

  Future<Uint8List> imageNotification(String uri)async
  {
    var imgString = await http.get(Uri.parse(uri));
    return imgString.bodyBytes;
  }
}
