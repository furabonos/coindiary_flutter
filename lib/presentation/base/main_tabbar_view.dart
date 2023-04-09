import 'dart:io';

import 'package:coindiary_flutter/presentation/base/tabs_info.dart';
import 'package:coindiary_flutter/presentation/chart/chart_viewcontroller.dart';
import 'package:coindiary_flutter/presentation/diary/diary_viewcontroller.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainTabbarView extends StatefulWidget {
  const MainTabbarView({Key? key}) : super(key: key);

  @override
  State<MainTabbarView> createState() => _MainTabbarViewState();
}

class _MainTabbarViewState extends State<MainTabbarView> with TickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: TABS.length, vsync: this);
    controller.addListener(() {
      setState(() {

      });
    });
    getDeviceUniqueId();
  }

  Future<String> getDeviceUniqueId() async {
    var deviceIdentifier = 'unknown';
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      deviceIdentifier = androidInfo.id!;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: [
          DiaryViewController(),
          ChartViewController(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: controller.index,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          controller.animateTo(index);
        },
        items: TABS.map((e) =>
            BottomNavigationBarItem(icon: Icon(e.icon), label: e.label),
        ).toList(),
      ),
    );
  }
}
