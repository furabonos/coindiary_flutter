import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../util/protocol/alertable.dart';
import '../util/protocol/string_utils.dart';

class DiaryEditViewController extends StatefulWidget {
  final DiaryModel modelData;
  const DiaryEditViewController({required this.modelData, Key? key}) : super(key: key);

  @override
  State<DiaryEditViewController> createState() => _DiaryEditViewControllerState();
}

class _DiaryEditViewControllerState extends State<DiaryEditViewController> {

  final _todayTextFieldController = TextEditingController();
  final _startTextFieldController = TextEditingController();
  final _endTextFieldController = TextEditingController();
  final _memoTextFieldController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _todayTextFieldController.text = "${widget.modelData.today}";
    _startTextFieldController.text = "${widget.modelData.start}";
    _endTextFieldController.text = "${widget.modelData.end}";
    _memoTextFieldController.text = "${widget.modelData.memo}";

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async{
          return false;
        },
        child: SafeArea(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    renderDateView(),
                    SizedBox(height: 20),
                    renderStartView(),
                    SizedBox(height: 20),
                    renderEndView(),
                    SizedBox(height: 20),
                    renderMemoView(),
                    SizedBox(height: 100),
                    renderButtonRow(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void clickConfirm(BuildContext context) {
    final start = _startTextFieldController.text;
    final end = _endTextFieldController.text;
    final memo = _memoTextFieldController.text;

    if (start == "") {
      Alertable.showAlert(context, "시작금액");
      return;
    }

    if (end == "") {
      Alertable.showAlert(context, "종료금액");
      return;
    }
    _showIndicator(context);
    saveData(start, end, memo, context);
  }

  void _showIndicator(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void showSuccessAlert(BuildContext context) {
    showCupertinoModalPopup<void>(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: Text('저장되었습니다.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: false,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void saveData(String start, String end, String? memo, BuildContext context) async{
    String uuids = await StringUtils.getDevideUUID();
    try {
      await FirebaseFirestore.instance.collection(uuids)
          .doc(_memoTextFieldController.text)
          .set({
        "start": start,
        "end": end,
        "today": _memoTextFieldController.text,
        "memo": memo
      });
      showSuccessAlert(context);
    } catch (e) {
      Alertable.showDataFailure(context);
      print('FireStore에 데이터를 추가하는중 오류발생 :: ${e}');
    }
  }

  void clickCancel(BuildContext context) {
    Navigator.pop(context);
  }

  Widget renderButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(onPressed: () {}, child: Icon(Icons.image)),
        ElevatedButton(onPressed: () { clickCancel(context); }, child: Text("취소")),
        ElevatedButton(onPressed: () { clickConfirm(context); }, child: Text("수정")),
      ],
    );
  }

  Widget renderMemoView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '메모',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(height: 10,),
        Container(
          child: TextField(
            controller: _memoTextFieldController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )
            ),
          ),
        )
      ],
    );
  }

  Widget renderEndView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '종료시드',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(height: 10,),
        Container(
          child: TextField(
            controller: _endTextFieldController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                hintText: "종료금액을 입력해주세요.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )
            ),
          ),
        )
      ],
    );
  }

  Widget renderStartView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '시작시드',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(height: 10,),
        Container(
          child: TextField(
            keyboardType: TextInputType.number,
            controller: _startTextFieldController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                hintText: "시작금액을 입력해주세요.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )
            ),
          ),
        )
      ],
    );
  }

  Widget renderDateView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '기록일',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(height: 10,),
        Container(
          child: TextField(
            keyboardType: TextInputType.number,
            controller: _todayTextFieldController,
            enabled: false,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )
            ),
          ),
        )
      ],
    );
  }
}
