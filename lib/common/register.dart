

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _RegisterPageState createState() {
    // TODO: implement createState
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _uNickNameController =
      TextEditingController(); //昵称
  final TextEditingController _uPhoneController = TextEditingController(); //手机号
  final TextEditingController _uVerificationCodeController =
      TextEditingController(); //验证码
  final TextEditingController _uPasswordController =
      TextEditingController(); //密码
  final TextEditingController _uSurePasswordController =
      TextEditingController(); //确认密码
  final FocusNode _uNickNameFocusNode = FocusNode(); //昵称
  final FocusNode _uPhoneFocusNode = FocusNode(); //手机号
  final FocusNode _uVerificationCodeNode = FocusNode(); //验证码
  final FocusNode _uPasswordFocusNode = FocusNode(); //密码
  final FocusNode _uSurePasswordFocusNode = FocusNode(); //确认密码
  bool _checkboxSelected = false; //维护复选框状态

  String passwordAssertName = "images/passwordinvisible.png"; //右边默认不显示密码
  bool showPassword = false; //密码框最右边默认不显示密码
  String surePasswordAssertName = "images/passwordinvisible.png"; //右边默认不显示密码
  bool sureShowPassword = false; //密码框最右边默认不显示密码
  int registerTextColor = 0xFF999999; //注册字体颜色
  int registerBackgroundColor = 0xFFE6E6E6; //注册按钮背景颜色
  bool _isDisable = true; //注册按钮是否可用，默认是不可用

  late Timer _timer;//延迟初始化
  int _countdownTime=0;
  bool _isVerificationCodeDisable = false; //获取验证码按钮是否可用，默认是可用的
  String verificationCodeData="获取验证码";
   BoxDecoration? verificationCodeDecoration;
  final BoxDecoration defaultVerificationCodeDecoration=BoxDecoration(
  border: Border.all(
  color: Color(0xFF009999),
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
    //昵称是选填
    // _uNickNameController.addListener(() {
    //   print(_uNickNameController.text);
    // });
    _uPhoneController.addListener(() {
      print(_uPhoneController.text);
      setRegisterState();
    });
    _uVerificationCodeController.addListener(() {
      print(_uVerificationCodeController.text);
      setRegisterState();
    });
    _uPasswordController.addListener(() {
      print(_uPasswordController.text);
      setRegisterState();
    });
    _uSurePasswordController.addListener(() {
      print(_uSurePasswordController.text);
      setRegisterState();
    });
  }

  void setRegisterState() {
    if (_uPhoneController.text.length == 11 &&
        _uVerificationCodeController.text.length == 6 &&
        _uPasswordController.text.length >= 6 &&
        _uSurePasswordController.text.length >= 6 &&
        _checkboxSelected) {
      setState(() {
        _isDisable = false; //注册按钮可用
        registerTextColor = 0xFFFFFFFF;
        registerBackgroundColor = 0xFF009999;
      });
    } else {
      setState(() {
        _isDisable = true; //注册按钮不可用
        registerTextColor = 0xFF999999;
        registerBackgroundColor = 0xFFE6E6E6;
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
      extendBodyBehindAppBar: true, //沉浸式状态栏
      appBar: PreferredSize(
        child: AppBar(
          brightness: Brightness.dark, //文字白色
          elevation: 0.0, //阴影设置为0，默认为4
          titleSpacing: 15.0, //标题距离左边大小
          leading: IconButton(
              icon: Image.asset(
                'images/nav_icon_back.png',
                width: 24,
              ),
              padding: EdgeInsets.only(left: 15),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        preferredSize: Size.fromHeight(88),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width, // 获取屏幕尺寸,宽度充满全屏,
              height: 315,
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
                        '欢迎注册\n来吧建康专家端',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 30),
                    ),
                    flex: 1,
                  ),
                  Container(
                    child: Image.asset(
                      'images/logo.png',
                      width: 100,
                      alignment: Alignment.topRight,
                    ),
                    padding: EdgeInsets.fromLTRB(15, 10, 30, 0),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 15,
            right: 15,
            child: Container(
              height: MediaQuery.of(context).size.height - 22,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 200),
                      padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        borderOnForeground: true,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        '昵\u3000称',
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
                                          '(选填)',
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
                                          hintText: "请设置您的昵称（最大20个字符）",
                                          hintStyle: TextStyle(
                                              color: Color(0xFFCCCCCC),
                                              fontSize: 13),
                                          border: InputBorder.none,
                                        ),
                                        controller: _uNickNameController,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(20),
                                        ],
                                        focusNode: _uNickNameFocusNode,
                                        keyboardType: TextInputType.name,
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
                                                  "images/passwordinvisible.png";
                                            } else {
                                              passwordAssertName =
                                                  "images/passwordvisible.png";
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
                                                  "images/passwordinvisible.png";
                                            } else {
                                              surePasswordAssertName =
                                                  "images/passwordvisible.png";
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
                                            setRegisterState();
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
                                              //TODO 跳转至webview界面
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
                              padding: EdgeInsets.fromLTRB(43, 40, 43, 16),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: ElevatedButton(
                                        onPressed:
                                            _isDisable ? null : onRegisterClick,
                                        child: Text(
                                          '注册',
                                          style: TextStyle(
                                            color: Color(registerTextColor),
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
                                                  registerBackgroundColor)),
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
                    ),
                    flex: 1,
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.stretch,
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(_timer!=null){
      _timer.cancel();
    }
  }
  void onVerificationCodeClick(){
    if (_uPhoneController.text.length!= 11) {
      Fluttertoast.showToast(msg: "请输入正确长度的手机号");
      return;
    }
    // setState(() {
    //   if (_timer != null) {
    //     return;
    //   }
    //   // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
    //   verificationCodeData = '${_countdownTime--}s';
    //   verificationCodeDecoration=decoration;
    //   _isVerificationCodeDisable=true;//获取验证码按钮不可用
    //   _timer =
    //   new Timer.periodic(new Duration(seconds: 1), (timer) {
    //     setState(() {
    //       if (_countdownTime > 0) {
    //         verificationCodeData = '${_countdownTime--}s';
    //       } else {
    //         verificationCodeData = '重新获取';
    //         _isVerificationCodeDisable=false;//获取验证码按钮可用
    //         verificationCodeDecoration=defaultVerificationCodeDecoration;
    //         _countdownTime = 119;
    //         _timer.cancel();
    //       }
    //     });
    //   });
    // });
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
            _timer.cancel();
            return;
          }
          verificationCodeData='$_countdownTime'+"s";
      })
    };

    _timer = Timer.periodic(oneSec, callback);
  }

  void onRegisterClick() async {
    print("注册");
    setState(() {
      // 当所有编辑框都失去焦点时键盘就会收起
      _uNickNameFocusNode.unfocus();
      _uPhoneFocusNode.unfocus();
      _uVerificationCodeNode.unfocus();
      _uPasswordFocusNode.unfocus();
      _uSurePasswordFocusNode.unfocus();
      LoginPrefs.saveToken(_uPhoneController.text); //保存token (我这里保存的输入框中输入的值)
      Navigator.of(context).pop(); //注册页消失
    });
  }
}
