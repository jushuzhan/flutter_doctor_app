import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';
import 'package:flutter_doctor_app/common/net/NetWorkWithToken.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'models/common_input_response_entity.dart';
import 'models/make_conclusion_input_request_entity.dart';

class FillInConclusionPage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _FillInConclusionPageState createState() {
    // TODO: implement createState
    return _FillInConclusionPageState();
  }
}

class _FillInConclusionPageState extends State<FillInConclusionPage> {
  final TextEditingController _conclusionController =
      TextEditingController();

  final FocusNode _conclusionFocusNode = FocusNode();


  late  Map<String, dynamic>  arguments;
  late  int id;
  late  String patientName;
  late  String conclusion;

  bool _isFill = true; //默认是填写结论


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print("arguments==$arguments");
    id=arguments["id"];
    print("id==$id");
    patientName=arguments["patientName"];
    conclusion=arguments["conclusion"];
    print("patientName==$patientName");
    print("conclusion==$conclusion");
    _conclusionController.text=conclusion;
    conclusion.isEmpty?_isFill=true:_isFill=false;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFFFFFFFF),
          titleSpacing: 15.0, //标题距离左边大小
          title: Text(
            _isFill?"写结论给$patientName":"查看$patientName的结论",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 18, color: Color(0XFF333333)),
          ),
          leading: IconButton(
              icon: Image.asset(
                'assets/images/nav_icon_back_gray.png',
                width: 24,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          bottom: PreferredSize(
            child: Divider(
              color: Color(0xFFEEEEEE),
              height: 1,
            ),
            preferredSize: Size.fromHeight(1),
          ),
          actions: [
            GestureDetector(
              onTap: _isFill?onCompleteClick:null,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  _isFill?'完成':"",
                  style: TextStyle(fontSize: 16, color: Color(0xFF009999)),
                ),
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
              ),
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          //状态栏字体为黑色
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: '开始给申请人写下您的结论吧',
                          hintStyle: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 14),
                          border: InputBorder.none,
                          contentPadding:
                          EdgeInsets.all(0)
                        // contentPadding: EdgeInsets.symmetric(
                        //     horizontal: 8),
                      ),
                      controller:
                      _conclusionController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            300),
                      ],
                      focusNode: _conclusionFocusNode,
                      autofocus: _isFill?true:false,
                      enabled: _isFill?true:false,
                      maxLines: 10,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                color: Colors.white,
              ),
              flex: 1,
            ),
          ],
        ));
  }
//TODO 调接口完成填写结论
  void onCompleteClick() async {
    print("完成");
    setState(() async{
      // 当所有编辑框都失去焦点时键盘就会收起
      FocusScope.of(context).unfocus();
      if (_conclusionController.text.length==0) {
        Fluttertoast.showToast(msg: "请填写结论");
        return;
      }
      MakeConclusionInputRequestEntity makeConclusionInputRequestEntity=MakeConclusionInputRequestEntity();
      makeConclusionInputRequestEntity.id=id;
      makeConclusionInputRequestEntity.conclusion=_conclusionController.text.toString();
      CommonInputResponseEntity commonInputResponseEntity= await NetWorkWithToken(context).makeConclusion(makeConclusionInputRequestEntity);
      if(commonInputResponseEntity.msg!=null){
        Fluttertoast.showToast(msg: commonInputResponseEntity.msg!);
      }
      if(commonInputResponseEntity.successed!=null&&commonInputResponseEntity.successed==true){
        Navigator.of(context).pop('refreshData'); //填写结论完成
      }

    });



  }

}
