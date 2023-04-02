import 'package:coindiary_flutter/presentation/base/tabs_info.dart';
import 'package:coindiary_flutter/presentation/chart/chart_viewcontroller.dart';
import 'package:coindiary_flutter/presentation/diary/diary_viewcontroller.dart';
import 'package:flutter/material.dart';

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
