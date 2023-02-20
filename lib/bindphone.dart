

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BindPhonePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _BindPhonePageState createState() {
    // TODO: implement createState
    return _BindPhonePageState();
  }
}

class _BindPhonePageState extends State<BindPhonePage> {
  final TextEditingController _uPhoneController = TextEditingController(); //手机号
  final TextEditingController _uVerificationCodeController =
      TextEditingController(); //验证码

  final FocusNode _uPhoneFocusNode = FocusNode(); //手机号
  final FocusNode _uVerificationCodeNode = FocusNode(); //验证码
  bool _checkboxSelected = false; //维护复选框状态

  int nextStepTextColor = 0xFF999999; //注册字体颜色
  int nextStepBackgroundColor = 0xFFE6E6E6; //注册按钮背景颜色
  bool _isDisable = true; //下一步按钮是否可用，默认是不可用

  Timer? _timer;//延迟初始化
  int _countdownTime=0;
  bool _isVerificationCodeDisable = false; //获取验证码按钮是否可用，默认是可用的
  String verificationCodeData="获取验证码";
   BoxDecoration? verificationCodeDecoration;
  final BoxDecoration defaultVerificationCodeDecoration=BoxDecoration(
  border: Border.all(
  color: Color(0x66009999),
  width: 1.0),
  // color: Color(0xFFCCCCCC),//验证码背景色
  borderRadius: BorderRadius.all(
  Radius.circular(4)),
  );
  final  BoxDecoration decoration=BoxDecoration(
    color: Color(0xFFCCCCCC),//验证码背景色
    borderRadius: BorderRadius.all(
        Radius.circular(4)),
  );


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verificationCodeDecoration=defaultVerificationCodeDecoration;
    _uPhoneController.addListener(() {
      print(_uPhoneController.text);
      setNextStepState();
    });
    _uVerificationCodeController.addListener(() {
      print(_uVerificationCodeController.text);
      setNextStepState();
    });

  }

  void setNextStepState() {
    if (_uPhoneController.text.length == 11 &&
        _uVerificationCodeController.text.length == 6 &&
        _checkboxSelected) {
      setState(() {
        _isDisable = false; //注册按钮可用
        nextStepTextColor = 0xFFFFFFFF;
        nextStepBackgroundColor = 0xFF009999;
      });
    } else {
      setState(() {
        _isDisable = true; //注册按钮不可用
        nextStepTextColor = 0xFF999999;
        nextStepBackgroundColor = 0xFFE6E6E6;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      extendBodyBehindAppBar: false, //不沉浸式状态栏
      appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,//文字白色
          elevation: 0.0, //阴影设置为0，默认为4
          titleSpacing: 15.0, //标题距离左边大小
          leading: IconButton(
              icon: Image.asset(
                'assets/images/nav_icon_back.png',
                width: 24,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
      ),
      body:
      SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            //上半部分
            Container(
              width: MediaQuery.of(context).size.width, // 获取屏幕尺寸,宽度充满全屏,
              height: MediaQuery.of(context).size.height*0.18,
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                  color: Color(0xFF009999), //背景颜色
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  )),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        '\-\n绑定手机',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      padding: EdgeInsets.only(left: 15),
                    ),
                    flex: 1,
                  ),
                  Container(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 80,
                      alignment: Alignment.center,
                    ),
                    padding: EdgeInsets.only(right: 15),
                  )
                ],
              ),
            ),
            //下半部分
            Card(
              color: Colors.white,
              elevation: 2,
              borderOnForeground: true,
              margin: EdgeInsets.only(top: 96,left: 15,right: 15,bottom: 22),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              '手机号',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF666666),
                              ),
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              color: Color(0xFFF8F8F8),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 4),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                '(必填)',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF999999),
                                ),
                              ),
                              padding: EdgeInsets.only(left: 7),
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "请输入您的手机号码",
                                hintStyle: TextStyle(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 13),
                                border: InputBorder.none,
                              ),
                              controller: _uPhoneController,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp("[0-9]"),
                                    allow: true),
                                //只能输入字母或数字],
                                LengthLimitingTextInputFormatter(11),
                              ],
                              focusNode: _uPhoneFocusNode,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333333),
                              ),
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: Color(0xFFEEEEEE),
                              ))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              '验证码',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF666666),
                              ),
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              color: Color(0xFFF8F8F8),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 4),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                '(必填)',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF999999),
                                ),
                              ),
                              padding: EdgeInsets.only(left: 7),
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "请输入接收到的验证码",
                                hintStyle: TextStyle(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 13),
                                border: InputBorder.none,
                              ),
                              controller:
                              _uVerificationCodeController,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp("[0-9]"),
                                    allow: true),
                                //只能输入字母或数字],
                                LengthLimitingTextInputFormatter(6),
                              ],
                              focusNode: _uVerificationCodeNode,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333333),
                              ),
                            ),
                            flex: 1,
                          ),
                          Container(
                            child: GestureDetector(
                              onTap:(){
                                if(!_isVerificationCodeDisable){
                                  onVerificationCodeClick();
                                }
                              },
                              child: Container     (
                                width: 64,
                                height: 24,
                                alignment: Alignment.center,
                                child: Text(verificationCodeData,style: TextStyle(
                                  fontSize: 11,
                                  color:
                                  _countdownTime ==0
                                      ? Color(0xFF009999)
                                      : Color(0xFFFFFFFF),
                                ),),
                                decoration: verificationCodeDecoration,
                              ),
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: Color(0xFFEEEEEE),
                              ))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                              value: _checkboxSelected,
                              activeColor: Color(0xFF009999),
                              onChanged: (value) {
                                setState(() {
                                  _checkboxSelected = value!;
                                  setNextStepState();
                                });
                              }),
                          Expanded(
                            child: Text.rich(TextSpan(children: [
                              TextSpan(
                                text: "我已阅读并同意",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF999999),
                                ),
                              ),
                              TextSpan(
                                text: "《官方服务协议和隐私说明》",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF009999),
                                  decoration:
                                  TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, 'privacy_policy');//跳转至隐私政策
                                  },
                              ),
                            ])),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(43, 40, 43, 19),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: ElevatedButton(
                              onPressed:
                              _isDisable ? null : onNextStepClick,
                              child: Text(
                                '下一步',
                                style: TextStyle(
                                  color: Color(nextStepTextColor),
                                  fontSize: 16,
                                ),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25)),
                                  ),
                                ),
                                elevation:
                                MaterialStateProperty.all(0),
                                backgroundColor:
                                MaterialStateProperty.all(Color(
                                    nextStepBackgroundColor)),
                              ),
                            ),
                            height: 50,
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )

    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(_timer!=null){
      _timer!.cancel();
    }
  }
  void onVerificationCodeClick(){
    if (_uPhoneController.text.length!= 11) {
      Fluttertoast.showToast(msg: "请输入正确长度的手机号");
      return;
    }
    _uPhoneFocusNode.unfocus();
    if(_countdownTime==0){
      //TODO HTTP请求发送验证码
      setState(() {
        _countdownTime=119;
        verificationCodeDecoration=decoration;
        _isVerificationCodeDisable=true;//获取验证码按钮不可用
        verificationCodeData='$_countdownTime'+"s";
      });
      //开始倒计时
      startCountdownTimer();

    }
  }
  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
      setState(() {
        _countdownTime = _countdownTime - 1;
          if(_countdownTime==0){
            _isVerificationCodeDisable=false;//获取验证码按钮可用
            verificationCodeData="重新获取";
            verificationCodeDecoration=defaultVerificationCodeDecoration;
            _timer!.cancel();
            return;
          }
          verificationCodeData='$_countdownTime'+"s";
      })
    };
    if(_timer==null){
      _timer = Timer.periodic(oneSec, callback);
    }


  }

  void onNextStepClick() async {
    print("下一步");
    setState(() {
      // 当所有编辑框都失去焦点时键盘就会收起
      _uPhoneFocusNode.unfocus();
      _uVerificationCodeNode.unfocus();


      if (_uPhoneController.text.length==0) {
        Fluttertoast.showToast(msg: "请先输入手机号");
        return;
      }
      if (_uPhoneController.text.length != 11) {
        Fluttertoast.showToast(msg: "请输入正确长度的手机号");
        return;
      }
      if (_uVerificationCodeController.text.length==0) {
        Fluttertoast.showToast(msg: "请先输入验证码");
        return;
      }
      if (_uVerificationCodeController.text.length != 6) {
        Fluttertoast.showToast(msg: "请输入正确长度的验证码");
        return;
      }

      //TODO 调接口绑定手机 绑定成功 判断是否需要设置密码，如果需要设置密码，则跳转至设置密码界面，不需要设置密码则直接登录获取token,如果需要设置密码，则跳转至设置密码界面，如果不需要则跳转至首页
      //LoginPrefs.saveToken(_uPhoneController.text); //保存token (我这里保存的输入框中输入的值)
      Navigator.pushNamed(context, 'set_password');//跳转至设置界面
    });
  }
}
