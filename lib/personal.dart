import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';

import 'common/constants/constants.dart';
import 'common/net/NetWorkWithoutToken.dart';
import 'common/view/ExitBottomDialog.dart';
import 'models/BaseBean.dart';
import 'models/logout_this_device_request_entity.dart';

class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() {
    return _PersonalPageState();
  }
}

class _PersonalPageState extends State<PersonalPage> {
  late Padding horizontalLine; //延迟初始化 不为空
  late GestureDetector orderListDetector; //订单列表
  late GestureDetector editInfoDetector; //编辑信息
  late GestureDetector setDetector; //设置
  var onOrderListClick;
  var onEditInfoClick;
  var onSetClick;
  bool disableNotify = false; //通知默认开启

  late Container personalInfo; //个人信息

  bool isEdited = false; //默认是未编辑状态

  bool isAudit = false; //默认是未审核状态

  //var onExitLoginClick;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initView();
  }

  void initView() {
    isEdited
        ? personalInfo = editedContainer()
        : personalInfo = notEditedContainer();
    horizontalLine = getHorizontalLine();
    onOrderListClick = () => {
      skipPage('order_list'),//跳转至订单列表界面
        };
    onEditInfoClick = () => {
      skipPage('edit_info'),//跳转至编辑信息
        };
    onSetClick = () => {
      skipPage('setting'),//跳转至设置
        };
    orderListDetector = getDetector('订单列表', onOrderListClick);
    editInfoDetector = getDetector('编辑信息', onEditInfoClick);
    setDetector = getDetector('设置', onSetClick);
    // onExitLoginClick=()=>{
    //
    // };
  }
  void skipPage(String routName){
    Navigator.pushNamed(context, routName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: 15.0, //标题距离左边大小
          title: Text(
            "个人中心",
            style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)),
          ),
          leading: IconButton(
              icon: Image.asset(
                'assets/images/nav_icon_back.png',
                width: 24,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          actions: [
            GestureDetector(
              onTap: () {
                exitPersonal();
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '退出',
                  style: TextStyle(fontSize: 12, color: Color(0xFFFFFFFF)),
                ),
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0.0),
              ),
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.light,
          //状态栏字体为白色
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            //上半部分
            Column(
              children: [
                //上半部分
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 5,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 18, bottom: 6),
                            child: Container(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/info_image_portrait.png',
                                width: 56,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Stack(
                              children: <Widget>[
                                //未编辑状态下的显示
                                personalInfo,
                              ],
                            ),
                          ),
                        ],
                      ),
                      color: Color(0xFF009999),
                    )
                  ],
                ),
                //下半部分 就是一张图片
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          'assets/images/porfile_image_decorate.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      flex: 1,
                    )
                  ],
                )
              ],
            ),
            //下半部分
            Column(
              children: [
                orderListDetector,
                horizontalLine,
                editInfoDetector,
                horizontalLine,
                setDetector,
                horizontalLine,
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Container(
                    height: 50,
                    color: Color(0xFFFFFFFF),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              '消息通知',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                          flex: 1,
                        ),
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(right: 15),
                            child: Image.asset(
                              disableNotify
                                  ? 'assets/images/icon_toggle_button_off.png'
                                  : 'assets/images/icon_toggle_button_on.png',
                              height: 48,
                            ),
                          ),
                          onTap: () {
                            changeNotifyClick();
                          },
                        ),
                      ],
                    ),
                  ),
                )
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

  //TODO 点击切换图片 调用接口是否接收通知
  void changeNotifyClick() {
    setState(() {
      disableNotify = !disableNotify;
    });
  }

  //未编辑状态的显示
  Container notEditedContainer() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,//水平居中
        children: <Widget>[
          Text(
            '您还未认证个人信息',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFFFFFFF),
            ),
          ),
          Text(
            '点击下面\“编辑信息\”开始填写',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ],
      ),
    );
  }

//已编辑状态的显示
  Container editedContainer() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,//水平居中
              children: <Widget>[
                Text(
                  '张医生',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Container(
                      width: 48,
                      height: 16,
                      alignment: Alignment.center,
                      child: Text(
                        isAudit ? '已审核' : '未审核',
                        style: TextStyle(
                          fontSize: 10,
                          color:
                              isAudit ? Color(0x99FFFFFF) : Color(0xFF999999),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        color: isAudit ? Color(0xFF1aa3a3) : Color(0xFFCCCCCC),
                      ),
                    ))
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,//水平居中
              children: <Widget>[
                Text(
                  '天津市第一中心医院/',
                  style: TextStyle(fontSize: 12, color: Color(0xCCFFFFFF)),
                ),
                Text(
                  '医学教授',
                  style: TextStyle(fontSize: 12, color: Color(0xCCFFFFFF)),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16, left: 15, right: 15),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '简介内容简介内容简介内容简介内容简介内容简介内容简介内容简介内容简介内容简介内容简介内容简介内容简介内容简介内容简介内容简介内容简介内容简介内容简介内容简介内容',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0x99FFFFFF),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  //退出 TODO 需要调接口退出
  void exitPersonal(){
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
        return ExitBottomDialog(callBack: (){
          onExitLoginClick();
        });
    }
    );
  }
  //点击退出登录 TODO 需要调接口
  void onExitLoginClick() async{
    print("退出");
    LogoutThisDeviceRequestEntity logoutThisDeviceRequestEntity=LogoutThisDeviceRequestEntity();
    logoutThisDeviceRequestEntity.userId=LoginPrefs(context).getUserId()!;
    logoutThisDeviceRequestEntity.loginType=LOGIN_TYPE;
    logoutThisDeviceRequestEntity.clientId=CLIENT_ID;
    logoutThisDeviceRequestEntity.deviceUUID=JIGUANGID;
    Future<BaseBean> baseBean=NetWorkWithoutToken(context).logoutThisDevice(logoutThisDeviceRequestEntity);
    baseBean.then((value) {
      print(value.success);
      LoginPrefs(context).logout();
      Navigator.of(context).pushNamedAndRemoveUntil(
          "login", ModalRoute.withName("login"));
    });
  }
}
