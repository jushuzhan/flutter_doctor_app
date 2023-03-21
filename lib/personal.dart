import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';

import 'common/Prefs.dart';
import 'common/constants/constants.dart';
import 'common/net/NetWorkWithToken.dart';
import 'common/net/NetWorkWithoutToken.dart';
import 'common/view/ExitBottomDialog.dart';
import 'models/BaseBean.dart';
import 'models/EnumBean.dart';
import 'models/common_input_response_entity.dart';
import 'models/doctor_extend_by_doctor_id_response_entity.dart';
import 'models/logout_this_device_request_entity.dart';
import 'models/user_info_settings_get_by_user_id_request_entity.dart';
import 'models/user_info_settings_get_by_user_id_response_entity.dart';
import 'package:dio/dio.dart';

import 'models/user_info_settings_set_by_user_id_request_entity.dart';
import 'common/event/event.dart';
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

  bool isEdited = false; //默认是未编辑状态

  bool isAudit = false; //默认是未审核状态

  ImageProvider backgroundImage=AssetImage('assets/images/info_image_portrait.png');
  String name='';//姓名
  String  auditStatus='';//审核状态
  String doctorType='';
  String technicianType='';
  String hospital='';
  String description='';
  bool isExpanded=false;//个人简介是否展开
  var result;//从编辑信息返回数据是否需要刷新
  var alertDialog;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDoctorExtendInfo();
    initView();
  }

  void initView() {
    setState(() {
      horizontalLine = getHorizontalLine();
      onOrderListClick = () => {
        skipPage('order_list'),//跳转至订单列表界面
      };
      onEditInfoClick = () => {
        if(auditStatus=='审核通过'){
          alertDialog= _alertDialog(),
      }else{
        skipEditInfo(),//跳转至编辑信息
      }

      };
      onSetClick = () => {
        skipPage('setting'),//跳转至设置
      };
      orderListDetector = getDetector('订单列表', onOrderListClick);
      editInfoDetector = getDetector('编辑信息', onEditInfoClick);
      setDetector = getDetector('设置', onSetClick);
    });

  }
  void skipPage(String routName){
    Navigator.pushNamed(context, routName);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
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
                Navigator.of(context).pop(result!=null
                    ?'refreshData':null);
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
                      constraints: BoxConstraints(
                          minHeight:MediaQuery.of(context).size.height / 5
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top:18,bottom:6),
                            child: CircleAvatar(
                              backgroundImage:  backgroundImage,
                              radius: 28,//圆形半径
                            ),
                          ),

                          // Padding(
                          //   padding: EdgeInsets.only(top: 18, bottom: 6),
                          //   child: Container(
                          //     alignment: Alignment.center,
                          //     child: Image.asset(
                          //       'assets/images/info_image_portrait.png',
                          //       width: 56,
                          //     ),
                          //   ),
                          // ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,//水平居中
                                    children:_buildMiddleColumn(),
                                  ),
                                ),
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
        )), onWillPop: onWillPop);
  }
  //返回拦截
    Future<bool> onWillPop() async{
    if(result!=null){
      //问诊申请界面需要刷新数据
      eventBus.fire(MyEventRefresh(true));
    }
    return true;
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
    userInfoSettingsSetByUserId();
  }
  List<Widget> _buildMiddleColumn() {
    List<Widget> widgets = [];
    if(isEdited){
      //已编辑
      widgets.add(Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,//水平居中
          children: <Widget>[
            Text(
              name,
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
                    auditStatus,
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
      ),);
      widgets.add(Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 4),child:Text(
              hospital,
              style: TextStyle(fontSize: 12, color: Color(0xCCFFFFFF)),
            ),),
            Padding(padding: EdgeInsets.only(top: 4),child:Row(
              mainAxisAlignment: MainAxisAlignment.center,//水平居中
              children: <Widget>[
                Text(
                  doctorType,
                  style: TextStyle(fontSize: 12, color: Color(0xCCFFFFFF)),
                ),
                Text(
                  technicianType,
                  style: TextStyle(fontSize: 12, color: Color(0xCCFFFFFF)),
                ),
              ],
            ),)
,
          ],
        ),
      ),);
      widgets.add(Padding(
      padding: EdgeInsets.only(top: 16, left: 15, right: 15),
      child: GestureDetector(
        onTap: (){
          print('点击了');
          setState(() {
            if(description.length>216){
              isExpanded=!isExpanded;
              print(isExpanded);
            }

          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: Text(
                  description,
                  textAlign: description.length>216?TextAlign.justify:TextAlign.center,
                  maxLines: isExpanded?null:4,
                  overflow: isExpanded?null:TextOverflow.clip,//裁剪
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0x99FFFFFF),
                  ),
                ),flex: 1,),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Column(
              children: _buildBottomColumn(),
            ),
          ],
        ),
      ),
    ),);
    }else{
      //未编辑
      widgets.add(Text(
        '您还未认证个人信息',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFFFFFFF),
        ),
      ),);
      widgets.add(Text(
        '点击下面\“编辑信息\”开始填写',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFFFFFFF),
        ),
      ),);


    }
    return widgets;
  }
  List<Widget> _buildBottomColumn() {
    List<Widget> widgets = [];
    if(description.length>216){
      widgets.add(Padding(padding: EdgeInsets.only(top: 9),child: Text(
        isExpanded?'收起':'展开',
        style: TextStyle(
          fontSize: 10,
          color: Colors.white,
        ),
      ),));
      widgets.add(Image(image: AssetImage(
        isExpanded?'assets/images/zhankai.png':'assets/images/shouqi.png',
      ),width: 24,height: 12,),);
    }

    return widgets;
  }
  Container verticalLine() {
    return Container(
      height: 24,
      width: 1,
      color: Color(0xFFE6E6E6),
    );
  }

  _alertDialog() async {
    var alertDialogs = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("您的信息已通过审核",textAlign: TextAlign.center,style: TextStyle(
                fontSize: 18,color: Color(0xFF333333),fontWeight: FontWeight.bold
            ),),
            content:Text("如果修改，需要再次审核才能接诊。",textAlign: TextAlign.center,style: TextStyle(
                fontSize: 14,color: Color(0xFF999999)
            ),),
            actions: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Divider(
                    height: 1.0,
                    color: Color(0xFFE6E6E6),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center, //垂直居中
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: Text(
                              '取消',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        flex: 1,
                      ),
                      verticalLine(),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: Text(
                              '去修改',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF009999),
                              ),
                            ),
                          ),
                          onTap: () {
                            skipEditInfo();
                          },
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ],
              )

            ],
          );
        },barrierDismissible: false);
    return alertDialogs;
  }
  void skipEditInfo() async{
    if(alertDialog!=null){
      Navigator.pop(context);
    }
    result=await Navigator.pushNamed(context, 'edit_info'); //跳转至编辑信息
    if(result!=null){
      //重新调取接口
      getDoctorExtendInfo();
    }
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
  void getDoctorExtendInfo(){
    getInfoData();
  }

  Future<UserInfoSettingsGetByUserIdResponseEntity> userInfoSettingsGetByUserId(){
    UserInfoSettingsGetByUserIdRequestEntity userIdRequestEntity=UserInfoSettingsGetByUserIdRequestEntity();
    userIdRequestEntity.userId=int.parse(LoginPrefs(context).getUserId()!);
    userIdRequestEntity.userRole=USER_ROLE;
    return NetWorkWithToken(context).userInfoSettingsGetByUserId(userIdRequestEntity);
  }
  getInfoData() async{
    if(!LoginPrefs(context).isLogin()){
      LoginPrefs(context).logout();
      Navigator.of(context).pushNamedAndRemoveUntil(
          "login", ModalRoute.withName("login"));
      return;

    }
    var response=await Future.wait([NetWorkWithToken(context).getDoctorExtendByDoctorId(LoginPrefs(context).getUserId()), userInfoSettingsGetByUserId()]);
    if(response!=null){
      if(response.length==2){
        DoctorExtendByDoctorIdResponseEntity doctorInfo=response[0] as DoctorExtendByDoctorIdResponseEntity;
        UserInfoSettingsGetByUserIdResponseEntity userInfo=response[1] as UserInfoSettingsGetByUserIdResponseEntity;
        setState(() {
          isEdited=true;
          print('isEdited==$isEdited');
          if(doctorInfo!=null){
            print('${doctorInfo.headimgurl}');
            print('${doctorInfo.name}');
            if(doctorInfo.headimgurl!=null){
              backgroundImage=NetworkImage(doctorInfo.headimgurl!);
            }

            name=doctorInfo.name!;


            if(doctorInfo.auditStatus!=null){//已审核
              if(doctorInfo.auditStatus==2){
                isAudit=true;
              }else{
                isAudit=false;
              }


             switch(doctorInfo.auditStatus){
               case 1:
                 auditStatus='等待审核';
                 break;
               case 2:
                 auditStatus='审核通过';
                 break;
               case 3:
                 auditStatus='审核未过';
                 break;
             }
            }
            if(doctorInfo.doctorType!=null){
              for (var i = 0; i < getDoctorType().length; i++) {
               if(getDoctorType()[i].key==doctorInfo.doctorType.toString()){
                 doctorType=getDoctorType()[i].value!;
                 break;
               }
              }

            }
            if(doctorInfo.technicianType!=null){
              for (var i = 0; i < getTechnicianType().length; i++) {
                if(getTechnicianType()[i].key==doctorInfo.technicianType.toString()){
                  if(doctorType.isNotEmpty){
                    technicianType='/'+getTechnicianType()[i].value!;
                  }else{
                    technicianType=getTechnicianType()[i].value!;
                  }

                  break;
                }
              }

            }
            hospital=doctorInfo.hospital!;
            description=doctorInfo.description!;
            //description='个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介';

          }
          if(userInfo!=null){
            if(userInfo.jiguangPush!=null){
              disableNotify=userInfo.jiguangPush!;
            }

            print('${userInfo.jiguangPush}');
          }
        });

      }
    }
  }
  userInfoSettingsSetByUserId() async{
    if(!LoginPrefs(context).isLogin()){
      LoginPrefs(context).logout();
      Navigator.of(context).pushNamedAndRemoveUntil(
          "login", ModalRoute.withName("login"));
      return;

    }
    UserInfoSettingsSetByUserIdRequestEntity userIdRequestEntity=UserInfoSettingsSetByUserIdRequestEntity();
    userIdRequestEntity.jiguangPush=disableNotify;
    userIdRequestEntity.userRole=USER_ROLE;
    userIdRequestEntity.userId=int.parse(LoginPrefs(context).getUserId()!);
    CommonInputResponseEntity commonInputResponseEntity=await NetWorkWithToken(context).userInfoSettingsSetByUserId(userIdRequestEntity);
    if(commonInputResponseEntity!=null){

    }

  }
  List<EnumBean> getDoctorType() {
    var listDynamic = jsonDecode(Prefs.getDoctorType()!);
    return (listDynamic as List<dynamic>)
        .map((e) => EnumBean.fromJson((e as Map<String, dynamic>)))
        .toList();
  }
  List<EnumBean> getTechnicianType() {
    var listDynamic = jsonDecode(Prefs.getTechnicianType()!);
    return (listDynamic as List<dynamic>)
        .map((e) => EnumBean.fromJson((e as Map<String, dynamic>)))
        .toList();
  }
}
