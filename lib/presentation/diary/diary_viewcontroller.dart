import 'package:coindiary_flutter/presentation/diary/diary_write_viewcontroller.dart';
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
            renderMenuList(),
            SizedBox(height: 20,),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: Colors.red,
                  ),
                  renderMenuBtn(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderMenuList() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
        menuList.map((e) => Text(e)).toList(),
      ),
    );
  }

  Widget renderMenuBtn(BuildContext context) {
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
      builder: (BuildContext context) => CupertinoActionSheet(
        message: const Text('메뉴를 선택해 주세요.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DiaryWriteViewController(),
                ),
              );
            },
            child: const Text('일지 작성'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _showDeleteAlert(context);
            },
            child: const Text('기록 초기화'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('취소'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('취소'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
