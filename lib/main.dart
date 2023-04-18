import 'dart:io';

import 'package:coindiary_flutter/presentation/base/main_tabbar_view.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  getDeviceUniqueId();
  runApp(
    MaterialApp(
      home: MainTabbarView(),
    )
  );
}

Future<String> getDeviceUniqueId() async {
  var deviceIdentifier = 'unknown';
  var deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    var androidInfo = await deviceInfo.androidInfo;
    deviceIdentifier = androidInfo.id!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('UUID', deviceIdentifier);
  } else if (Platform.isIOS) {
    var iosInfo = await deviceInfo.iosInfo;
    deviceIdentifier = iosInfo.identifierForVendor!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('UUID', deviceIdentifier);
  } else if (Platform.isLinux) {
    var linuxInfo = await deviceInfo.linuxInfo;
    deviceIdentifier = linuxInfo.machineId!;
  } else if (kIsWeb) {
    var webInfo = await deviceInfo.webBrowserInfo;
    deviceIdentifier = webInfo.vendor! +
        webInfo.userAgent! +
        webInfo.hardwareConcurrency.toString();
  }
  return deviceIdentifier;
}
