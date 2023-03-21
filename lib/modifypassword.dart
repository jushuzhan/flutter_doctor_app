import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'common/constants/constants.dart';
import 'common/net/NetWorkWithToken.dart';
import 'common/view/LoadingDialog.dart';
import 'models/common_input_response_entity.dart';
import 'models/doctor_extend_by_doctor_id_response_entity.dart';
import 'models/update_user_password_request_entity.dart';

class ModifyPasswordPage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _ModifyPasswordPageState createState() {
    // TODO: implement createState
    return _ModifyPasswordPageState();
  }
}

class _ModifyPasswordPageState extends State<ModifyPasswordPage> {
  final TextEditingController _originalPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _surePasswordController = TextEditingController();
  final FocusNode _originalFocusNode = FocusNode();
  final FocusNode _newFocusNode = FocusNode();
  final FocusNode _sureFocusNode = FocusNode();

  bool originalShowPassword = false; //密码框最右边默认不显示密码
  bool newShowPassword = false; //密码框最右边默认不显示密码
  bool sureShowPassword = false; //密码框最右边默认不显示密码
  int completeTextColor = 0xFF999999; //完成字体颜色
  int completeBackgroundColor = 0xFFE6E6E6; //完成按钮背景颜色
  bool _isDisable = true; //完成按钮是否可用，默认是不可用
  late final LoadingDialog loading;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=LoadingDialog(buildContext: context);
    _originalPasswordController.addListener(() {
      setCompleteState();
    });
    _newPasswordController.addListener(() {
      setCompleteState();
    });
    _surePasswordController.addListener(() {
      setCompleteState();
    });

  }

  void setCompleteState() {
    if (_originalPasswordController.text.length >= 6&&_newPasswordController.text.length >= 6&&_surePasswordController.text.length >= 6) {
      setState(() {
        _isDisable = false; //完成按钮可用
        completeTextColor = 0xFFFFFFFF;
        completeBackgroundColor = 0xFF009999;
      });
    } else {
      setState(() {
        _isDisable = true; //完成按钮不可用
        completeTextColor = 0xFF999999;
        completeBackgroundColor = 0xFFE6E6E6;
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
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFFFFFFFF),
          titleSpacing: 15.0, //标题距离左边大小
          title: Text(
            "修改密码",
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
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child:
              Column(
                children: <Widget>[
                  //上半部分
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 24, left: 15),
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '请设置新的密码',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 32),
                                  child: Text(
                                    '请输入6~20位英文字母、数字或符号。',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF999999),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  //下半部分
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          //原密码
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Container(
                              height: 50,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  Text(
                                    '原密码',
                                    style: TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 15,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                      hintText: '请输入原来的密码',
                                                      hintStyle: TextStyle(
                                                          color: Color(0xFFCCCCCC),
                                                          fontSize: 16),
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                      EdgeInsets.all(0)
                                                    // contentPadding: EdgeInsets.symmetric(
                                                    //     horizontal: 8),
                                                  ),
                                                  obscureText: !originalShowPassword,
                                                  controller:
                                                  _originalPasswordController,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter(
                                                        RegExp("[a-zA-Z]|[0-9]"),
                                                        allow: true),
                                                    //只能输入字母或数字],
                                                    LengthLimitingTextInputFormatter(
                                                        20),
                                                  ],
                                                  focusNode: _originalFocusNode,
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
                                                      originalShowPassword =
                                                      !originalShowPassword;
                                                    });
                                                  },
                                                  child: ImageIcon(
                                                    AssetImage(originalShowPassword
                                                        ? 'assets/images/passwordvisible.png'
                                                        : 'assets/images/passwordinvisible.png'),
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
                                          margin: EdgeInsets.only(left: 85),
                                        ),
                                        flex: 1,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          //新密码
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Container(
                              height: 50,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  Text(
                                    '新密码',
                                    style: TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 15,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                      hintText: '请输入新的密码',
                                                      hintStyle: TextStyle(
                                                          color: Color(0xFFCCCCCC),
                                                          fontSize: 16),
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                      EdgeInsets.all(0)
                                                    // contentPadding: EdgeInsets.symmetric(
                                                    //     horizontal: 8),
                                                  ),
                                                  obscureText: !newShowPassword,
                                                  controller: _newPasswordController,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter(
                                                        RegExp("[a-zA-Z]|[0-9]"),
                                                        allow: true),
                                                    //只能输入字母或数字],
                                                    LengthLimitingTextInputFormatter(
                                                        20),
                                                  ],
                                                  focusNode: _newFocusNode,
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
                                                      newShowPassword =
                                                      !newShowPassword;
                                                    });
                                                  },
                                                  child: ImageIcon(
                                                    AssetImage(newShowPassword
                                                        ? 'assets/images/passwordvisible.png'
                                                        : 'assets/images/passwordinvisible.png'),
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
                                          margin: EdgeInsets.only(left: 85),
                                        ),
                                        flex: 1,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          //确认密码
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Container(
                              height: 50,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  Text(
                                    '确认密码',
                                    style: TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 15,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                      hintText: '请再次输入新的密码',
                                                      hintStyle: TextStyle(
                                                          color: Color(0xFFCCCCCC),
                                                          fontSize: 16),
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                      EdgeInsets.all(0)
                                                    // contentPadding: EdgeInsets.symmetric(
                                                    //     horizontal: 8),
                                                  ),
                                                  obscureText: !sureShowPassword,
                                                  controller: _surePasswordController,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter(
                                                        RegExp("[a-zA-Z]|[0-9]"),
                                                        allow: true),
                                                    //只能输入字母或数字],
                                                    LengthLimitingTextInputFormatter(
                                                        20),
                                                  ],
                                                  focusNode: _sureFocusNode,
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
                                                    });
                                                  },
                                                  child: ImageIcon(
                                                    AssetImage(sureShowPassword
                                                        ? 'assets/images/passwordvisible.png'
                                                        : 'assets/images/passwordinvisible.png'),
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
                                          margin: EdgeInsets.only(left: 85),
                                        ),
                                        flex: 1,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          //完成按钮
                          Padding(
                            padding: EdgeInsets.fromLTRB(43, 40, 43, 16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: ElevatedButton(
                                      onPressed: _isDisable? null : onCompleteClick,
                                      child: Text(
                                        '完成',
                                        style: TextStyle(
                                          color: Color(completeTextColor),
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
                                        MaterialStateProperty.all(
                                            Color(completeBackgroundColor)),
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
                      color: Colors.white,
                    ),
                    flex: 1,
                  ),
                ],
              )
            ,
          ),
        ));
  }
  void onCompleteClick() async {
    print("完成");
    setState(() {
      // 当所有编辑框都失去焦点时键盘就会收起
      FocusScope.of(context).unfocus();

      if (_originalPasswordController.text.length==0) {
        Fluttertoast.showToast(msg: "请先输入旧密码");
        return;
      }
      if (_newPasswordController.text.length==0) {
        Fluttertoast.showToast(msg: "请先输入新密码");
        return;
      }
      if (_surePasswordController.text.length==0) {
        Fluttertoast.showToast(msg: "请先输入确认密码");
        return;
      }
      if (_newPasswordController.text.compareTo(_surePasswordController.text)!=0) {
        Fluttertoast.showToast(msg: "新密码与确认密码不一致");
        return;
      }
      if(!LoginPrefs(context).isLogin()){
        LoginPrefs(context).logout();
        Navigator.of(context).pushNamedAndRemoveUntil(
            "login", ModalRoute.withName("login"));
        return;

      }
      updateUserPassword(_originalPasswordController.text,_newPasswordController.text,_surePasswordController.text);

    });
  }
  updateUserPassword(String oldPassword,String newPassword,String confirmPassword)async{
    try{
      loading.showLoading();
      UpdateUserPasswordRequestEntity updateUserPasswordRequestEntity=new UpdateUserPasswordRequestEntity();
      updateUserPasswordRequestEntity.oldPassword=oldPassword;
      updateUserPasswordRequestEntity.newPassword=newPassword;
      updateUserPasswordRequestEntity.confirmPassword=confirmPassword;
      updateUserPasswordRequestEntity.userRole=USER_ROLE;
      CommonInputResponseEntity commonInputResponseEntity=await NetWorkWithToken(context).updateUserPassword(updateUserPasswordRequestEntity);
      if(commonInputResponseEntity!=null){
        if(commonInputResponseEntity.msg!=null&&commonInputResponseEntity.msg!.isNotEmpty){
          Fluttertoast.showToast(msg:commonInputResponseEntity.msg!);
        }
        if(commonInputResponseEntity.successed!=null&&commonInputResponseEntity.successed==true){
          Navigator.of(context).pop(); //密码修改成功，此页消失。
        }
      }
    }on DioError catch(e){
      print(e.message!);

    }finally{
      loading.dismissLoading();
    }


  }
}
