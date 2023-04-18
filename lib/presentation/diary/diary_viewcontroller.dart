import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coindiary_flutter/model/model.dart';
import 'package:coindiary_flutter/presentation/diary/custom/diary_list_cell.dart';
import 'package:coindiary_flutter/presentation/diary/diary_edit_viewcontroller.dart';
import 'package:coindiary_flutter/presentation/diary/diary_write_viewcontroller.dart';
import 'package:coindiary_flutter/presentation/util/protocol/calculation.dart';
import 'package:coindiary_flutter/presentation/util/protocol/string_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiaryViewController extends StatefulWidget {


  DiaryViewController({Key? key}) : super(key: key);

  @override
  State<DiaryViewController> createState() => _DiaryViewControllerState();
}

class _DiaryViewControllerState extends State<DiaryViewController> {
  final List<String> menuList = ["날짜", "시작금액", "종료금액", "수익률", "메모"];
  List<DiaryModel> dataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("fdfdsfds :: ${Calculation.yieldCalculation("100", "50")}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            renderMenuList(),
            SizedBox(height: 10,),
            Expanded(
              child: Stack(
                children: [
              FutureBuilder<List<DiaryModel>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('에러있'),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  //로딩
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                    itemBuilder:(context, index) {
                    return GestureDetector(
                      onTap: () async {
                        final result = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) => DiaryEditViewController(modelData: snapshot.data![index]),
                            )
                        );
                        print(result);
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (_) => DiaryEditViewController(data: snapshot.data![index]),
                        //   ),
                        // );
                      },
                        child: DiaryListCell(data: snapshot.data![index])
                    );
                    });
              },
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
    double width = MediaQuery.of(context).size.width / 5;
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        children:
        menuList.map((e) => Container(width: width, child: Text(e, textAlign: TextAlign.center))).toList(),
      ),
    );
  }

  Future<List<DiaryModel>> fetchData() async {
    String uuids = await StringUtils.getDevideUUID();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot snapshot = await firestore.collection(uuids).orderBy('today', descending: true).get();

    List<DiaryModel> list = snapshot.docs.map((e) =>
        DiaryModel.fromFirestore(doc: e)
    ).toList();
    setState(() {
      dataList = list;
    });
    return dataList;
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
