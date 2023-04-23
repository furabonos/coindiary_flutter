import 'package:coindiary_flutter/presentation/diary/viewmodel/diary_write_viewmodel.dart';
import 'package:coindiary_flutter/presentation/util/protocol/alertable.dart';
import 'package:coindiary_flutter/presentation/util/protocol/string_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

typedef AlertAction = void Function(BuildContext);

class DiaryWriteViewController extends StatefulWidget {

  DiaryWriteViewController({Key? key}) : super(key: key);

  @override
  State<DiaryWriteViewController> createState() => _DiaryWriteViewControllerState();
}

class _DiaryWriteViewControllerState extends State<DiaryWriteViewController> {

  TextEditingController _todayTextFieldController = TextEditingController(text: DateFormat('yyMMdd').format(DateTime.now()));
  final _startTextFieldController = TextEditingController();
  final _endTextFieldController = TextEditingController();
  final _memoTextFieldController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    [_startTextFieldController, _endTextFieldController, _memoTextFieldController].map((e) => e.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<DiaryWriteViewModel>();
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
                    renderButtonRow(viewModel),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> clickConfirm(BuildContext context, DiaryWriteViewModel viewModel) async {
    final start = _startTextFieldController.text;
    final end = _endTextFieldController.text;
    final memo = _memoTextFieldController.text;
    final today = _todayTextFieldController.text;

    if (start == "") {
      Alertable.showAlert(context, "시작금액");
      return;
    }

    if (end == "") {
      Alertable.showAlert(context, "종료금액");
      return;
    }
    _showIndicator(context);
    // saveData(start, end, memo, context);
    // final aa = await viewModel.saveData(start, end, memo, today, context);
    if (await viewModel.saveData(start, end, memo, today, context)) {
      showSuccessAlert(context);
    }else {
      Alertable.showDataFailure(context);
    }
  }

  void saveData(String start, String end, String? memo, BuildContext context) async{
    String uuids = await StringUtils.getDevideUUID();
    try {
      await FirebaseFirestore.instance.collection(uuids)
          .doc(_todayTextFieldController.text)
          .set({
        "start": start,
        "end": end,
        "today": _todayTextFieldController.text,
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

  Widget renderButtonRow(DiaryWriteViewModel viewmodel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(onPressed: () {}, child: Icon(Icons.image)),
        ElevatedButton(onPressed: () { clickCancel(context); }, child: Text("취소")),
        ElevatedButton(onPressed: () { clickConfirm(context, viewmodel); }, child: Text("확인")),
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
}
