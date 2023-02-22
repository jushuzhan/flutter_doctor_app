

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SetPasswordPage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _SetPasswordPageState createState() {
    // TODO: implement createState
    return _SetPasswordPageState();
  }
}

class _SetPasswordPageState extends State<SetPasswordPage> {


  final TextEditingController _uPasswordController =
      TextEditingController(); //密码
  final TextEditingController _uSurePasswordController =
      TextEditingController(); //确认密码

  final FocusNode _uPasswordFocusNode = FocusNode(); //密码
  final FocusNode _uSurePasswordFocusNode = FocusNode(); //确认密码


  String passwordAssertName = "assets/images/passwordinvisible.png"; //右边默认不显示密码
  bool showPassword = false; //密码框最右边默认不显示密码
  String surePasswordAssertName = "assets/images/passwordinvisible.png"; //右边默认不显示密码
  bool sureShowPassword = false; //密码框最右边默认不显示密码
  int sureTextColor = 0xFF999999; //注册字体颜色
  int sureBackgroundColor = 0xFFE6E6E6; //注册按钮背景颜色
  bool _isDisable = true; //确认按钮是否可用，默认是不可用



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _uPasswordController.addListener(() {
      print(_uPasswordController.text);
      setSureState();
    });
    _uSurePasswordController.addListener(() {
      print(_uSurePasswordController.text);
      setSureState();
    });
  }

  void setSureState() {
    if (
        _uPasswordController.text.length >= 6 &&
        _uSurePasswordController.text.length >= 6
        ) {
      setState(() {
        _isDisable = false; //注册按钮可用
        sureTextColor = 0xFFFFFFFF;
        sureBackgroundColor = 0xFF009999;
      });
    } else {
      setState(() {
        _isDisable = true; //注册按钮不可用
        sureTextColor = 0xFF999999;
        sureBackgroundColor = 0xFFE6E6E6;
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
                        '\-\n设置密码',
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
                              '密\u3000码',
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
                                hintText: "请输入6~20位英文字母、数字或符号",
                                hintStyle: TextStyle(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 13),
                                border: InputBorder.none,
                              ),
                              controller: _uPasswordController,
                              inputFormatters: [
                                //我这里设置为不允许输入汉字],
                                LengthLimitingTextInputFormatter(20),
                              ],
                              obscureText: !showPassword,
                              focusNode: _uPasswordFocusNode,
                              keyboardType: TextInputType.text,
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
                                setState(() {
                                  showPassword = !showPassword;
                                  if (!showPassword) {
                                    passwordAssertName =
                                    "assets/images/passwordinvisible.png";
                                  } else {
                                    passwordAssertName =
                                    "assets/images/passwordvisible.png";
                                  }
                                });
                              },
                              child: ImageIcon(
                                AssetImage(
                                  passwordAssertName,
                                ),
                                size: 20,
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
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              '确认密码',
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
                                hintText: "请再次输入您的密码",
                                hintStyle: TextStyle(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 13),
                                border: InputBorder.none,
                              ),
                              controller: _uSurePasswordController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20),
                              ],
                              obscureText: !sureShowPassword,
                              focusNode: _uSurePasswordFocusNode,
                              keyboardType: TextInputType.text,
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
                                setState(() {
                                  sureShowPassword =
                                  !sureShowPassword;
                                  if (!sureShowPassword) {
                                    surePasswordAssertName =
                                    "assets/images/passwordinvisible.png";
                                  } else {
                                    surePasswordAssertName =
                                    "assets/images/passwordvisible.png";
                                  }
                                });
                              },
                              child: ImageIcon(
                                AssetImage(
                                  surePasswordAssertName,
                                ),
                                size: 20,
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
                    padding: EdgeInsets.fromLTRB(43, 40, 43, 19),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: ElevatedButton(
                              onPressed:
                              _isDisable ? null : onSureClick,
                              child: Text(
                                '确认',
                                style: TextStyle(
                                  color: Color(sureTextColor),
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
                                    sureBackgroundColor)),
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



  void onSureClick() async {
    print("确认");
    setState(() {
      // 当所有编辑框都失去焦点时键盘就会收起
      FocusScope.of(context).unfocus();

      if (_uPasswordController.text.length==0) {
        Fluttertoast.showToast(msg: "请先输入密码");
        return;
      }
      if (_uPasswordController.text.length < 6 || _uPasswordController.text.length > 20) {;
        Fluttertoast.showToast(msg: "请输入正确长度的密码");
        return;
      }
      if (_uSurePasswordController.text.length < 6 || _uSurePasswordController.text.length > 20) {
        Fluttertoast.showToast(msg: "请输入正确长度的确认密码");
        return;
      }
      if (_uPasswordController.text.compareTo(_uSurePasswordController.text)!=0) {
        Fluttertoast.showToast(msg: "两次输入密码不一致");
        return;
      }

      //TODO 调接口设置密码 设置密码成功之后调获取token接口，token获取成功直接跳转至首页
      //LoginPrefs.saveToken(_uPhoneController.text); //保存token (我这里保存的输入框中输入的值)
      Navigator.of(context).pushNamedAndRemoveUntil(
          "home", ModalRoute.withName("home"));
    });
  }
}
