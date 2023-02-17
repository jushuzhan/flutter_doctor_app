import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';

import 'common/view/ExitBottomDialog.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  late Padding horizontalLine; //延迟初始化 不为空
  late GestureDetector modifyPasswordDetector; //修改密码
  late GestureDetector changeBindPhoneDetector; //换绑手机
  
  late Padding privacyPadding; //隐私政策
  late Padding aboutPadding; //关于我们
  var onModifyPasswordClick;
  var onChangeBindPhoneClick;
  var onPrivacyClick;
  var onAboutClick;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initView();
  }

  void initView() {
    horizontalLine = getHorizontalLine();
    onModifyPasswordClick = () => {
          Navigator.pushNamed(context, 'modify_password'),//跳转至修改密码
        };
    onChangeBindPhoneClick = () => {
          //Navigator.pushNamed(context, 'personal'),//跳转至首页
          //TODO 之后跳转至换绑手机界面
          //Navigator.of(context).pop(),
        };
    onPrivacyClick = () => {
          Navigator.pushNamed(context, 'privacy_policy'),//跳转至隐私政策

        };
    onAboutClick = () => {
      //Navigator.pushNamed(context, 'personal'),//跳转至首页
      //TODO 之后跳转至关于我们界面
      //Navigator.of(context).pop(),
    };
    modifyPasswordDetector = getDetector('修改密码', onModifyPasswordClick);
    changeBindPhoneDetector = getDetector('换绑手机', onChangeBindPhoneClick);
    privacyPadding=getPadding('隐私条款', onPrivacyClick);
    aboutPadding = getPadding('关于我们', onAboutClick);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFFFFFFFF),
          titleSpacing: 15.0, //标题距离左边大小
          title: Text(
            "设置",
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
          bottom: PreferredSize(child: Divider(
            color: Color(0xFFEEEEEE),
            height: 1,
          ),
           preferredSize:Size.fromHeight(1) ,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark, //状态栏字体为黑色
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            Column(
              children: [
                modifyPasswordDetector,
                horizontalLine,
                changeBindPhoneDetector,
                privacyPadding,
                aboutPadding,
              ],
            ),
          ],
        ));
  }

  //容器封装 @param textData 内容 @param onClick 点击事件
  GestureDetector getDetector(String textData, void Function() onClick) {
    return GestureDetector(
      child: Container(
        color: Color(0xFFFFFFFF),
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  textData,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
              flex: 1,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 15),
              child: Image.asset(
                'assets/images/button_icon_continue.png',
                height: 16,
              ),
            )
          ],
        ),
      ),
      onTap: () {
        onClick();
      },
    );
  }

  //水平线封装
  Padding getHorizontalLine() {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              width: 1,
              color: Color(0xFFEEEEEE),
            ))),
          )),
        ],
      ),
    );
  }

  //容器封装 @param textData 内容 @param onClick 点击事件
  Padding getPadding(String textData, void Function() onClick) {
    return Padding(padding: EdgeInsets.only(top: 16),child: GestureDetector(
      child: Container(
        color: Color(0xFFFFFFFF),
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  textData,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
              flex: 1,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 15),
              child: Image.asset(
                'assets/images/button_icon_continue.png',
                height: 16,
              ),
            )
          ],
        ),
      ),
      onTap: () {
        onClick();
      },
    ),);
  }



}
