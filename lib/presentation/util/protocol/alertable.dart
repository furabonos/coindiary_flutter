import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../diary/diary_write_viewcontroller.dart';

class Alertable {
  static showAlert(BuildContext context, String title) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: Text('${title}칸을 입력해주세요.'),
        actions: <CupertinoDialogAction>[
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

  static showDataSuccess(BuildContext context, AlertAction action) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: Text('저장되었습니다.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              action;
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  static showDataFailure(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: Text('저장에 실패하였습니다.\n잠시후 다시 시도해주세요.'),
        actions: <CupertinoDialogAction>[
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