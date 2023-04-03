import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiaryViewController extends StatelessWidget {

  final List<String> menuList = ["날짜", "시작금액", "종료금액", "수익률", "메모"];

  DiaryViewController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            RenderMenuList(),
            SizedBox(height: 20,),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: Colors.red,
                  ),
                  RenderMenuBtn(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget RenderMenuList() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
        menuList.map((e) => Text(e)).toList(),
      ),
    );
  }

  Widget RenderMenuBtn(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 10,
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          _showAlertDialog(context);
        },
        child: Icon(Icons.menu),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.blueAccent,
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        insetAnimationCurve: Curves.bounceOut,
        insetAnimationDuration: const Duration(milliseconds: 300),
        content: const Text('메뉴를 선택해 주세요.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              print('no click');
            },
            child: const Text('일지 작성'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _showDeleteAlert(context);
            },
            child: const Text('기록 초기화'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAlert(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: const Text('기록을 초기화 하시겠습니까?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              print('no click');
            },
            child: const Text('확인'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            onPressed: () {
              Navigator.pop(context);
              print('yes click');
            },
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }
}
