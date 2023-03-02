import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePhonePage extends StatefulWidget {
  @override
  _ChangePhonePageState createState() {
    return _ChangePhonePageState();
  }
}

class _ChangePhonePageState extends State<ChangePhonePage> {
  final TextEditingController _uPhoneController = TextEditingController();
  final TextEditingController _uVerificationCodeController =
      TextEditingController();
  final FocusNode _uPhoneFocusNode = FocusNode();
  final FocusNode _uVerificationCodeFocusNode = FocusNode();

  int verificationTextColor = 0xFF999999; //验证并更换字体颜色
  int verificationBackgroundColor = 0xFFE6E6E6; //验证并更换按钮背景颜色
  bool _isDisable = true; //验证并更换按钮是否可用，默认是不可用

  Timer? _timer; //延迟初始化
  int _countdownTime = 0;
  bool _isVerificationCodeDisable = false; //获取验证码按钮是否可用，默认是可用的
  String verificationCodeData = "获取验证码";
  BoxDecoration? verificationCodeDecoration;
  final BoxDecoration defaultVerificationCodeDecoration = BoxDecoration(
    border: Border.all(color: Color(0x66009999), width: 1.0),
    // color: Color(0xFFCCCCCC),//验证码背景色
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );
  final BoxDecoration decoration = BoxDecoration(
    color: Color(0xFFCCCCCC), //验证码背景色
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );

  bool _checkboxSelected = false; //维护复选框状态

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verificationCodeDecoration = defaultVerificationCodeDecoration;
    _uPhoneController.addListener(() {
      setVerificationState();
    });
    _uVerificationCodeController.addListener(() {
      setVerificationState();
    });
  }

  void setVerificationState() {
    if (_uPhoneController.text.length == 11 &&
        _uVerificationCodeController.text.length == 6 &&
        _checkboxSelected) {
      setState(() {
        _isDisable = false; //注册按钮可用
        verificationTextColor = 0xFFFFFFFF;
        verificationBackgroundColor = 0xFF009999;
      });
    } else {
      setState(() {
        _isDisable = true; //注册按钮不可用
        verificationTextColor = 0xFF999999;
        verificationBackgroundColor = 0xFFE6E6E6;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFFFFFFF),
        titleSpacing: 15.0,
        //标题距离左边大小
        title: Text(
          "换绑手机",
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
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        //状态栏字体为黑色
        elevation: 0.0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        // 获取屏幕尺寸,宽度充满全屏,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            //上半部分
            Container(
              width: MediaQuery.of(context).size.width, // 获取屏幕尺寸,宽度充满全屏,
              padding: EdgeInsets.only(top: 24),
              child: Text(
                '请输入新的手机号码',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF666666),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 8),
              child: Text(
                '更换手机号码后，下次登录可使用新的手机号码登录。',
                style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 4, bottom: 40),
              child: Text(
                '当前手机号码：18600002306',
                style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
            ),
            Container(
              height: 50,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Text(
                    '+86',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 18,
                        padding: EdgeInsets.only(left: 53),
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 1, color: Color(0xFFD8D8D8)))),
                      ),
                      Expanded(
                        child: TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF333333),
                          ),
                          decoration: InputDecoration(
                            hintText: "请输入新的手机号码",
                            hintStyle: TextStyle(
                              color: Color(0xFFCCCCCC),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(left: 7), //TextField内容实现上下居中
                          ),
                          controller: _uPhoneController,
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp("[0-9]"),
                                allow: true), //只能输入数字
                            LengthLimitingTextInputFormatter(11),
                          ],
                          //限制长度11位
                          focusNode: _uPhoneFocusNode,
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xFFEEEEEE)))),
            ),
            Container(
              height: 50,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Text(
                    '验证码',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 18,
                        padding: EdgeInsets.only(left: 53),
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 1, color: Color(0xFFD8D8D8)))),
                      ),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "请输入接收到的验证码",
                            hintStyle: TextStyle(
                                color: Color(0xFFCCCCCC), fontSize: 16),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 7),
                          ),
                          controller: _uVerificationCodeController,
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp("[0-9]"),
                                allow: true),
                            //只能输入字母或数字],
                            LengthLimitingTextInputFormatter(6),
                          ],
                          focusNode: _uVerificationCodeFocusNode,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF333333),
                          ),
                        ),
                        flex: 1,
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            if (!_isVerificationCodeDisable) {
                              onVerificationCodeClick();
                            }
                          },
                          child: Container(
                            width: 64,
                            height: 24,
                            alignment: Alignment.center,
                            child: Text(
                              verificationCodeData,
                              style: TextStyle(
                                fontSize: 11,
                                color: _countdownTime == 0
                                    ? Color(0xFF009999)
                                    : Color(0xFFFFFFFF),
                              ),
                            ),
                            decoration: verificationCodeDecoration,
                          ),
                        ),
                      )
                    ],
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
            Padding(
              padding: EdgeInsets.fromLTRB(43, 40, 43, 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: ElevatedButton(
                        onPressed: _isDisable ? null : onVerificationClick,
                        child: Text(
                          '验证并更换',
                          style: TextStyle(
                            color: Color(verificationTextColor),
                            fontSize: 16,
                          ),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all(
                              Color(verificationBackgroundColor)),
                        ),
                      ),
                      height: 50,
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(43, 16, 0, 0),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            //改变复选框的选中状态
                            _checkboxSelected = !_checkboxSelected;
                            setVerificationState();
                          });
                        },
                        child: Image(
                          image: AssetImage(_checkboxSelected
                              ? 'assets/images/agreement_checkbox_check.png'
                              : 'assets/images/agreement_checkbox_uncheck.png'),
                        ),
                      ),
                    ),
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
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                  context, 'privacy_policy'); //跳转至隐私政策
                            },
                        ),
                      ])),
                      flex: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void onVerificationCodeClick() {
    if (_uPhoneController.text.length != 11) {
      Fluttertoast.showToast(msg: "请输入正确长度的手机号");
      return;
    }
    FocusScope.of(context).unfocus();
    if (_countdownTime == 0) {
      //TODO HTTP请求发送验证码
      setState(() {
        _countdownTime = 119;
        verificationCodeDecoration = decoration;
        _isVerificationCodeDisable = true; //获取验证码按钮不可用
        verificationCodeData = '$_countdownTime' + "s";
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
            if (_countdownTime == 0) {
              _isVerificationCodeDisable = false; //获取验证码按钮可用
              verificationCodeData = "重新获取";
              verificationCodeDecoration = defaultVerificationCodeDecoration;
              _timer!.cancel();
              return;
            }
            verificationCodeData = '$_countdownTime' + "s";
          })
        };
    if (_timer == null) {
      _timer = Timer.periodic(oneSec, callback);
    }
  }

  void onVerificationClick() async {
    print("验证并更换");
    setState(() {
      // 当所有编辑框都失去焦点时键盘就会收起
      _uPhoneFocusNode.unfocus();
      _uVerificationCodeFocusNode.unfocus();
    });
    if (_uPhoneController.text.length != 11) {
      Fluttertoast.showToast(msg: "请输入正确长度的手机号");
      return;
    }
    if (_uVerificationCodeController.text.length != 6) {
      Fluttertoast.showToast(msg: "请输入正确长度的验证码");
      return;
    }
    //TODO 调接口验证更换 清空缓存 弹窗提示 退出登录 此界面消失
    var result = await showLoginDialog();
    print('result$result');
  }

  Future showLoginDialog() async {
    var result = await showDialog(
        barrierDismissible: false, //点击空白是否退出 不退出
        context: context,
        builder: (context) {
          return AlertDialog(
            titlePadding: EdgeInsets.only(top: 31),
            elevation: 10,
            backgroundColor: Colors.white,
            //背景颜色

            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            //设置形状

            title: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: const Text(
                '温馨提示',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '手机号修改成功，请使用新的手机号重新登录。',
                ),
              ],
            ),
            contentTextStyle:
                const TextStyle(fontSize: 14, color: Color(0xFF999999)),
            contentPadding: EdgeInsets.only(left: 22, right: 22, top: 10, bottom: 30),
            //文本内容的text样式
            actions: [
              Divider(
                color: Color(0xFFd4d4d4),
                height: 1,
              ),
              Row(
                children: <Widget>[
                  Expanded(child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: ()  {
                        LoginPrefs(context).clearLogin();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                              "login", ModalRoute.withName("login"));
                      },
                      child: Text(
                        '去登录',
                        style: TextStyle(fontSize: 16, color: Color(0xFF009999)),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                        ),
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                        MaterialStateProperty.all(Color(0xFFFFFFFF)),
                      ),
                    ),
                  ),flex: 1,)
                ],
              )

            ],
          );
        });

    print('result$result');
    return result;
  }
}
