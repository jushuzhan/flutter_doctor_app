import 'dart:convert';
import 'dart:core';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';
import 'package:flutter_doctor_app/common/net/NetWorkWithoutToken.dart';
import 'package:flutter_doctor_app/common/view/LoadingDialog.dart';
import 'package:flutter_doctor_app/models/GetEnum.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'common/Prefs.dart';
import 'common/constants/constants.dart';
import 'models/BaseBean.dart';
import 'models/EnumBean.dart';
import 'models/GetUserInfoRequest.dart';
import 'models/GetUserInfoResponse.dart';
import 'models/RequestTokenRequest.dart';
import 'models/RequestTokenResponse.dart';
import 'models/Result.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class LoginPage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _LoginPageState createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _uNameController = TextEditingController();
  final TextEditingController _uPasswordController = TextEditingController();
  final FocusNode _uNameFocusNode = FocusNode();
  final FocusNode _uPassFocusNode = FocusNode();

  String passwordAssertName = "assets/images/passwordinvisible.png"; //右边默认不显示密码
  bool showPassword = false; //密码框最右边默认不显示密码
  int loginTextColor = 0xFF999999; //登录字体颜色
  int loginBackgroundColor = 0xFFE6E6E6; //登录按钮背景颜色
  bool _isDisable = true; //登录按钮是否可用，默认是不可用
  late final LoadingDialog loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=LoadingDialog(buildContext: context);
    _uNameController.addListener(() {
      print(_uNameController.text);
      setLoginState();
    });
    _uPasswordController.addListener(() {
      print(_uPasswordController.text);
      setLoginState();
    });
  }

  void setLoginState() {
    if (_uNameController.text.length == 11 &&
        _uPasswordController.text.length >= 6) {
      setState(() {
        _isDisable = false; //登录按钮可用
        loginTextColor = 0xFFFFFFFF;
        loginBackgroundColor = 0xFF009999;
      });
    } else {
      setState(() {
        _isDisable = true; //登录按钮不可用
        loginTextColor = 0xFF999999;
        loginBackgroundColor = 0xFFE6E6E6;
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
        extendBodyBehindAppBar: false, //不允许沉浸式状态栏
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light, //文字白色
          elevation: 0.0, //阴影设置为0，默认为4
          titleSpacing: 15.0, //标题距离左边大小
          // title: Text('欢迎登录\n来吧建康专家端',style: TextStyle(
          //   color: Colors.white,
          //   fontSize: 24
          // ),),
          // actions: [ Container(width: 160, child: Image.asset('images/logo.png', ),margin: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0.0),),],

          // leading: IconButton(icon: Image.asset('images/nav_icon_back.png'), onPressed: (){
          //   Navigator.of(context).pop();
          // }),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              //上半部分
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                // 获取屏幕尺寸,宽度充满全屏,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.18,
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
                          '欢迎登录\n来吧建康专家端',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
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
                margin:
                EdgeInsets.only(top: 96, left: 15, right: 15, bottom: 107),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 40, 24, 0),
                      child: Container(
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            Text(
                              '手\u3000机',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              height: 16,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          width: 1, color: Color(0xFFEEEEEE)))),
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
                                  hintText: "请输入您的手机号码",
                                  hintStyle: TextStyle(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8), //TextField内容实现上下居中
                                ),
                                controller: _uNameController,
                                inputFormatters: [
                                  FilteringTextInputFormatter(RegExp("[0-9]"),
                                      allow: true), //只能输入数字
                                  LengthLimitingTextInputFormatter(11),
                                ],
                                //限制长度11位
                                focusNode: _uNameFocusNode,
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Color(0xFFEEEEEE)))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 24, 24, 40),
                      child: Container(
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            Text(
                              '密\u3000码',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              height: 16,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          width: 1, color: Color(0xFFEEEEEE)))),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "请输入您的登录密码",
                                  hintStyle: TextStyle(
                                      color: Color(0xFFCCCCCC), fontSize: 14),
                                  border: InputBorder.none,
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8),
                                ),
                                obscureText: !showPassword,
                                controller: _uPasswordController,
                                inputFormatters: [
                                  FilteringTextInputFormatter(
                                      RegExp("[a-zA-Z]|[0-9]"),
                                      allow: true),
                                  //只能输入字母或数字],
                                  LengthLimitingTextInputFormatter(20),
                                ],
                                focusNode: _uPassFocusNode,
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
                      padding: EdgeInsets.fromLTRB(43, 40, 43, 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: ElevatedButton(
                                onPressed: _isDisable ? null : onLoginClick,
                                child: Text(
                                  '登录',
                                  style: TextStyle(
                                    color: Color(loginTextColor),
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
                                      Color(loginBackgroundColor)),
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
                      padding: EdgeInsets.fromLTRB(43, 16, 43, 40),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  print("微信登录");
                                  weChatLogin();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                        'assets/images/weixin_icon.png',
                                        width: 24,
                                      ),
                                      margin: EdgeInsets.only(right: 4),
                                    ),
                                    Text(
                                      '微信登录',
                                      style: TextStyle(
                                        color: Color(0xFF009999),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                style: ButtonStyle(
                                  //圆角
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                    ),
                                  ),
                                  //边框
                                  side: MaterialStateProperty.all(BorderSide(
                                    color: Color(0xFF009999),
                                    width: 1,
                                  )),
                                  elevation: MaterialStateProperty.all(0),
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFFFFFFFF)),
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
                      padding: EdgeInsets.only(bottom: 24),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      print("注册账号");
                                      //TODO 注册账号 跳转至注册界面
                                      Navigator.pushNamed(
                                          context, 'register'); //跳转至首页
                                    },
                                    child: Text(
                                      '注册账号',
                                      style: TextStyle(
                                        color: Color(0xFF999999),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 16,
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                width: 1,
                                                color: Color(0xFFEEEEEE)))),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print("忘记密码");
                                      Navigator.pushNamed(
                                          context, 'forget_password'); //跳转至忘记密码
                                    },
                                    child: Text(
                                      '忘记密码',
                                      style: TextStyle(
                                          color: Color(0xFF999999),
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void onLoginClick() async {
    print("登录");
    setState(() {
      // 当所有编辑框都失去焦点时键盘就会收起
      FocusScope.of(context).unfocus();
    });
    var e = await getEnum();
    print(e);
    RequestTokenRequest requestTokenRequest=RequestTokenRequest(clientId: CLIENT_ID,
        jiguangId: JIGUANGID,
        phone: _uNameController.text,
        password: _uPasswordController.text,
        deviceUUID: JIGUANGID,
        loginType: LOGIN_TYPE,
        userRole: USER_ROLE);
        var result=await requestToken(requestTokenRequest);
  }
  //微信登录
  void weChatLogin() async{
    var installed=await fluwx.isWeChatInstalled;
    if(!installed){
      Fluttertoast.showToast(msg: "您还未安装微信客户端");
      return;
    }
    var authCode=await fluwx.sendWeChatAuth(scope: 'snsapi_userinfo',state: 'wechat_sdk_demo_test');
    if(authCode){

      fluwx.weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
        if (res is fluwx.WeChatAuthResponse) {
          int? errCode = res.errCode;
          print('微信登录返回值：ErrCode :$errCode  code:${res.code}');
          if (errCode == 0) {
            String? code = res.code;
            //把微信登录返回的code传给后台，剩下的事就交给后台处理
            GetUserInfoRequest request=GetUserInfoRequest(code: code,userRole:USER_ROLE ,loginType: LOGIN_TYPE);
            getUserInfo(request);
            Fluttertoast.showToast(msg: "用户同意授权成功");
          } else if (errCode == -4) {
            Fluttertoast.showToast(msg: "用户拒绝授权");
          } else if (errCode == -2) {
            Fluttertoast.showToast(msg: "用户取消授权");
          }
        }
      });
    }

  }

  Future <bool> getEnum() async {
    if (Prefs.getDoctorType() != null && Prefs.getDoctorType()!.length != 0) {
      return true;
    }
    loading.showLoading();
    try {
      GetEnum enums = await NetWorkWithoutToken(context).getEnum();
      var json = jsonEncode(enums);
      print(json);
      if (enums.result!.isNotEmpty) {
        List<EnumBean> doctorTypes = getEnumBeans("DoctorType", enums.result!);

        List<EnumBean> technicianTypes = getEnumBeans(
            "TechnicianType", enums.result!);

        String doctorType = jsonEncode(
            doctorTypes.map((e) => e.toJson()).toList());
        String technicianType = jsonEncode(
            technicianTypes.map((e) => e.toJson()).toList());
        Prefs.saveDoctorType(doctorType);
        Prefs.saveTechnicianType(technicianType);
        print('doctor:$doctorType');
        print('technician:$technicianType');
      }
    } on DioError catch (e) {
      //Fluttertoast.showToast(msg: e.toString());
    } finally {
      loading.dismissLoading();
      //隐藏loading框
    }
    return true;
  }

  Future <void> getUserInfo(GetUserInfoRequest getUserInfoRequest)async{
    GetUserInfoResponse response=await NetWorkWithoutToken(context).wechatLogin(getUserInfoRequest);
    var json = jsonEncode(response);
    print(json);
    if(response!=null){
      String? unionid=response.unionid;
      String?userId=response.userId;
      String?openid=response.openid;
      String?nickname=response.nickname;
      int?sex=response.sex;
      if(unionid!=null){
        //保存至sp
      }
      if(response.phoneBinded){
        //如果绑定了手机号 去查看是否设置了密码
        if(response.setPassword){
          //如果需要设置密码则跳转至设置密码界面
          //set_password
        }else{
          //不需要设置密码则请求token 请求token的时候需要极光id
        }
      }else{
        //如果没有绑定手机号跳转至绑定手机号的界面，把必要信息带过去
       // bind_phone
      }
    }


  }
  Future <void> requestToken(RequestTokenRequest requestTokenRequest)async{
   RequestTokenResponse tokenResponse=await NetWorkWithoutToken(context).requestToken(requestTokenRequest);
    var json = jsonEncode(tokenResponse);
    print(json);
    if(tokenResponse!=null){
      bool? success=tokenResponse.success;
      if(success!=null&&!success){
        Fluttertoast.showToast(msg: tokenResponse.msg!);
        return;
      }
      bool setPassword=tokenResponse.setPassword!;
      String userId=tokenResponse.userId!;
      String accessToken=tokenResponse.accessToken!;
      int expiresIn=tokenResponse.expiresIn!;
      String phone=requestTokenRequest.phone!;
      if(setPassword){
        //携带参数userid和phone跳转至设置密码界面
        Navigator.pushNamed(context, 'set_password',arguments:{"userId":"$userId","phone":"$phone"} );
      }else{
        //不需要设置密码
        LoginPrefs(context).login(accessToken, expiresIn, userId);
        Navigator.of(context).pop(); //登录页消失
        Navigator.pushNamed(context, 'home'); //跳转至首页
      }
    }else{
      Fluttertoast.showToast(msg: "服务器错误，请稍候再试");
    }


  }



List<EnumBean> getEnumBeans(String type, List<Result> enumsResult) {
  List<EnumBean> enumBeanList = [];
  for (Result resultBean in enumsResult) {
    if (type == resultBean.enmuType) {
      if (resultBean.enumX!.isNotEmpty) {
        resultBean.enumX!.forEach((element) {
          enumBeanList.add(element);
        });
      }
      break;
    }
  }

  return enumBeanList;
}

}
