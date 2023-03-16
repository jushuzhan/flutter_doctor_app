import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';
import 'package:flutter_doctor_app/common/Prefs.dart';
import 'package:flutter_doctor_app/common/net/NetWorkWithToken.dart';
import 'package:flutter_doctor_app/common/view/NetworkImageSSL.dart';
import 'package:flutter_doctor_app/models/EnumBean.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:image_picker/image_picker.dart';

import 'common/format/InputFormat.dart';
import 'common/net/NetWorkWithoutToken.dart';
import 'common/util/IdCardUtil.dart';
import 'common/util/OssUtil.dart';
import 'models/create_or_update_doctor_extend_input_request_entity.dart';
import 'models/get_user_info_for_edit_response_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/sts_upload_response_request_entity.dart';
import 'models/sts_upload_response_response_entity.dart';
import 'models/update_user_info_response_entity.dart';
class EditInfoPage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _EditInfoPageState createState() {
    // TODO: implement createState
    return _EditInfoPageState();
  }
}

// const String INIT_DATETIME = '2021-08-31';
class _EditInfoPageState extends State<EditInfoPage> {
  int saveTextColor = 0xFF999999; //保存字体颜色
  int saveBackgroundColor = 0xFFE6E6E6; //保存按钮背景颜色
  bool _isDisable = true; //保存按钮是否可用，默认是不可用

  String auditStatusText = '';//审核状态
  int auditStatusTextColor = 0xFFF5A631;//审核未通过/等待审核的字体颜色
  int auditStatusBackgroundColor = 0x1AF5A631;//审核未通过/等待审核的字体颜色

  final TextEditingController _uNameController = TextEditingController(); //姓名
  final TextEditingController _uIdCardController =
      TextEditingController(); //身份证
  final TextEditingController _uHospitalController =
      TextEditingController(); //医院
  final TextEditingController _uDescriptionController =
      TextEditingController(); //个人简介
  final TextEditingController _uPriceController = TextEditingController(); //价格
  final FocusNode _uNameFocusNode = FocusNode(); //姓名
  final FocusNode _uIdCardFocusNode = FocusNode(); //身份证
  final FocusNode _uHospitalFocusNode = FocusNode(); //医院
  final FocusNode _uDescriptionFocusNode = FocusNode(); //个人简介
  final FocusNode _uPriceFocusNode = FocusNode(); //价格
  late GestureDetector nameSuffixIcon;
  late GestureDetector idCardSuffixIcon;
  late GestureDetector hospitalSuffixIcon;
  late GestureDetector descriptionSuffixIcon;
  late GestureDetector priceSuffixIcon;

  bool nameSuffixIconIsVisible = false; //默认不显示
  bool idCardSuffixIconIsVisible = false; //默认不显示
  bool hospitalSuffixIconIsVisible = false; //默认不显示
  bool descriptionSuffixIconIsVisible = false; //默认不显示
  bool priceSuffixIconIsVisible = false; //默认不显示

  final defaultNoDataTextStyle = TextStyle(
      //无数据时的TextStyle
      color: Color(0xFFCCCCCC),
      fontSize: 12);
  final dataTextStyle = TextStyle(
      //有数据时的TextStyle
      color: Color(0xFF333333),
      fontSize: 16);
  String uBirthDate = ""; //出生日期

  String uDoctorTypeText = ""; //职称

  String uTechnicianTypeText = ""; //技师资格

  DateTime? _dateTime;

  late List<String> headList = [];
  late List<EnumBean> doctorTypeList;
  late List<EnumBean> technicianTypeList;

  String? _radioGroup = "";
  var _permissionStatus;
  bool _permissionDenied=true;//默认权限拒绝

  int?id;
  int?doctorId;
  String? phoneNumber;
  int? auditStatus;

  void _handleRadioValueChanged(String? value) {
    unFocus();
    setState(() {
      _radioGroup = value;
    });
  }

  XFile? _headFile; //头像
  ImageProvider _headFileImageProvider =
      AssetImage('assets/images/info_image_portrait.png');

  bool isUploadHeadImage=true;//是否需要上传头像 默认是需要上传的
  List<XFile> _certificationImageFileList = []; //专家认证

  bool isUploadCertificationImage=true;//是否需要上传专家认证 默认是需要上传的
  String _headImageUrl='';//上传给后台的url
  String _certificationImageUrl='';//上传给后台的url
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    headList.add("现在拍照");
    headList.add("相册选择");
    headList.add("取消");
    doctorTypeList = getDoctorType();
    doctorTypeList.add(EnumBean(key: "", value: "取消"));
    technicianTypeList = getTechnicianType();
    technicianTypeList.add(EnumBean(key: "", value: "取消"));
    getUserInfo();
    initView();
  }

  getUserInfo() {
    getUserInfoForEdit();
  }

  void initView() {
    if ("" != uBirthDate) {
      _dateTime = DateTime.parse(uBirthDate);
    }
    _uNameController.addListener(() {
      setState(() {
        if (_uNameController.text.length != 0) {
          //删除按钮显示
          nameSuffixIconIsVisible = true;
        } else {
          //删除按钮不显示
          nameSuffixIconIsVisible = false;
        }
        setSaveState();
      });
    });
    _uIdCardController.addListener(() {
      setState(() {
        if (_uIdCardController.text.length != 0) {
          //删除按钮显示
          idCardSuffixIconIsVisible = true;
        } else {
          //删除按钮不显示
          idCardSuffixIconIsVisible = false;
        }
        setSaveState();
      });
    });
    _uHospitalController.addListener(() {
      setState(() {
        if (_uHospitalController.text.length != 0) {
          //删除按钮显示
          hospitalSuffixIconIsVisible = true;
        } else {
          hospitalSuffixIconIsVisible = false;
        }
      });
    });
    _uDescriptionController.addListener(() {
      setState(() {
        if (_uDescriptionController.text.length != 0) {
          //删除按钮显示
          descriptionSuffixIconIsVisible = true;
        } else {
          descriptionSuffixIconIsVisible = false;
        }
      });
    });
    _uPriceController.addListener(() {
      setState(() {
        if (_uPriceController.text.length != 0) {
          //删除按钮显示
          priceSuffixIconIsVisible = true;
        } else {
          priceSuffixIconIsVisible = false;
        }
      });
    });
    nameSuffixIcon = deleteSuffixIcon(_uNameController);
    idCardSuffixIcon = deleteSuffixIcon(_uIdCardController);
    hospitalSuffixIcon = deleteSuffixIcon(_uHospitalController);
    descriptionSuffixIcon = deleteSuffixIcon(_uDescriptionController);
    priceSuffixIcon = deleteSuffixIcon(_uPriceController);
  }

  void setSaveState() {
    if (_uNameController.text.length !=0&&_uIdCardController.text.length!=0) {
      setState(() {
        _isDisable = false; //保存按钮可用
        saveTextColor = 0xFFFFFFFF;
        saveBackgroundColor = 0xFF009999;
      });
    } else {
      setState(() {
        _isDisable = true; //保存按钮不可用
        saveTextColor = 0xFF999999;
        saveBackgroundColor = 0xFFE6E6E6;
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
        titleSpacing: 15.0,
        //标题距离左边大小
        title: Text(
          "编辑信息",
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
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            //内容部分 左右各间距15
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            //审核状态
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 32),
                                    height: 32,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '审核状态：$auditStatusText',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(auditStatusTextColor)),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                        color:
                                            Color(auditStatusBackgroundColor)),
                                  )
                                ],
                              ),
                            ),
                            //头像
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: SizedBox(
                                height: 96,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        '头像',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        unFocus();
                                        _showHeadBottomSheet().then((index) {
                                          switch (index) {
                                            case 0:
                                              gotoCamera();
                                              break;
                                            case 1:
                                              gotoGallery();
                                              break;
                                          }
                                        });
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          CircleAvatar(
                                            backgroundImage:
                                                _headFileImageProvider,
                                            radius: 28, //圆形半径
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(left: 8),
                                            child: Image.asset(
                                              'assets/images/button_icon_continue.png',
                                              height: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //分割线
                            Divider(
                              height: 1,
                              color: Color(0xFFeeeeee),
                            ),
                            //姓名
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              height: 50,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    //纵轴居中即垂直居中
                                    children: <Widget>[
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '姓名 ',
                                              style: TextStyle(
                                                  color: Color(0xFF666666)),
                                            ),
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                  color: Color(0xFFE65D4E)),
                                            ),
                                          ],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 105),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: "请输入您的姓名",
                                                hintStyle: TextStyle(
                                                    color: Color(0xFFCCCCCC),
                                                    fontSize: 12),
                                                border: InputBorder.none,
                                                contentPadding:
                                                EdgeInsets.all(0),
                                                suffix: nameSuffixIconIsVisible
                                                    ? nameSuffixIcon
                                                    : null,
                                              ),
                                              controller: _uNameController,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    64),
                                              ],
                                              focusNode: _uNameFocusNode,
                                              keyboardType: TextInputType.name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF333333),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Color(
                                                            0xFFEEEEEE)))),
                                          ),
                                          flex: 1,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            //身份证
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              height: 50,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    //纵轴居中即垂直居中
                                    children: <Widget>[
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '身份证  ',
                                              style: TextStyle(
                                                  color: Color(0xFF666666)),
                                            ),
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                  color: Color(0xFFE65D4E)),
                                            ),
                                          ],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 105),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: "请输入您的身份证号码",
                                                hintStyle: TextStyle(
                                                    color: Color(0xFFCCCCCC),
                                                    fontSize: 12),
                                                border: InputBorder.none,
                                                contentPadding:
                                                EdgeInsets.all(0),
                                                suffix:
                                                    idCardSuffixIconIsVisible
                                                        ? idCardSuffixIcon
                                                        : null,
                                              ),
                                              controller: _uIdCardController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter(
                                                    RegExp("[0-9]|X|x"),
                                                    allow: true),
                                                //只能输入字母或数字],
                                                LengthLimitingTextInputFormatter(
                                                    18),
                                              ],
                                              focusNode: _uIdCardFocusNode,
                                              keyboardType: TextInputType.name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF333333),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Color(
                                                            0xFFEEEEEE)))),
                                          ),
                                          flex: 1,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            //性别
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 8),
                              height: 50,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    //纵轴居中即垂直居中
                                    children: <Widget>[
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '性别  ',
                                              style: TextStyle(
                                                  color: Color(0xFF666666)),
                                            ),
                                          ],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 105),
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Color(0xFFEEEEEE)))),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Spacer(
                                            flex: 3,
                                          ),
                                          Flexible(
                                            child: RadioListTile(
                                              title: Text(
                                                "男",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: "男" == _radioGroup
                                                        ? Color(0xFF333333)
                                                        : Color(0xFF999999)),
                                              ),
                                              value: "男",
                                              onChanged:
                                                  _handleRadioValueChanged,
                                              groupValue: _radioGroup,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .platform,
                                            ),
                                          ),
                                          Flexible(
                                              child: RadioListTile(
                                            title: Text("女",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: "女" == _radioGroup
                                                        ? Color(0xFF333333)
                                                        : Color(0xFF999999))),
                                            value: "女",
                                            groupValue: _radioGroup,
                                            onChanged: _handleRadioValueChanged,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .platform,
                                          )),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            //出生日期
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              height: 50,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    //纵轴居中即垂直居中
                                    children: <Widget>[
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '出生日期',
                                              style: TextStyle(
                                                  color: Color(0xFF666666)),
                                            ),
                                          ],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 105),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      unFocus();
                                                      showDatePicker();
                                                    },
                                                    child: Text(
                                                      "" == uBirthDate
                                                          ? "请选择您的出生日期"
                                                          : uBirthDate,
                                                      style: "" == uBirthDate
                                                          ? defaultNoDataTextStyle
                                                          : dataTextStyle,
                                                    ),
                                                  ),
                                                  flex: 1,
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  padding:
                                                      EdgeInsets.only(left: 8),
                                                  child: Image.asset(
                                                    'assets/images/button_icon_continue.png',
                                                    height: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Color(
                                                            0xFFEEEEEE)))),
                                          ),
                                          flex: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //职称
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              height: 50,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    //纵轴居中即垂直居中
                                    children: <Widget>[
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "职称",
                                              style: TextStyle(
                                                  color: Color(0xFF666666)),
                                            ),
                                          ],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 105),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      unFocus();
                                                      _showDoctorTypeModalBottomSheet()
                                                          .then((int? index) {
                                                        print("职称index:$index");
                                                        if (index == null) {
                                                          return;
                                                        }
                                                        setState(() {
                                                          if (doctorTypeList[
                                                                      index!]
                                                                  .key!
                                                                  .length !=
                                                              0) {
                                                            uDoctorTypeText =
                                                                doctorTypeList[
                                                                        index!]
                                                                    .value!;
                                                          } else {
                                                            uDoctorTypeText =
                                                                "";
                                                          }
                                                        });
                                                      });
                                                    },
                                                    child: Text(
                                                      "" == uDoctorTypeText
                                                          ? "请选择您的职称"
                                                          : uDoctorTypeText,
                                                      style: "" ==
                                                              uDoctorTypeText
                                                          ? defaultNoDataTextStyle
                                                          : dataTextStyle,
                                                    ),
                                                  ),
                                                  flex: 1,
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  padding:
                                                      EdgeInsets.only(left: 8),
                                                  child: Image.asset(
                                                    'assets/images/button_icon_continue.png',
                                                    height: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Color(
                                                            0xFFEEEEEE)))),
                                          ),
                                          flex: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //技师资格
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              height: 50,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    //纵轴居中即垂直居中
                                    children: <Widget>[
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "技师资格",
                                              style: TextStyle(
                                                  color: Color(0xFF666666)),
                                            ),
                                          ],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 105),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      unFocus();
                                                      _showTechnicianTypeModalBottomSheet()
                                                          .then((int? index) {
                                                        print("技师index:$index");
                                                        if (index == null) {
                                                          return;
                                                        }
                                                        setState(() {
                                                          if (technicianTypeList[
                                                                      index!]
                                                                  .key!
                                                                  .length !=
                                                              0) {
                                                            uTechnicianTypeText =
                                                                technicianTypeList[
                                                                        index!]
                                                                    .value!;
                                                          } else {
                                                            uTechnicianTypeText =
                                                                "";
                                                          }
                                                        });
                                                      });
                                                    },
                                                    child: Text(
                                                      "" == uTechnicianTypeText
                                                          ? "请选择您的技师资格"
                                                          : uTechnicianTypeText,
                                                      style: "" ==
                                                              uTechnicianTypeText
                                                          ? defaultNoDataTextStyle
                                                          : dataTextStyle,
                                                    ),
                                                  ),
                                                  flex: 1,
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  padding:
                                                      EdgeInsets.only(left: 8),
                                                  child: Image.asset(
                                                    'assets/images/button_icon_continue.png',
                                                    height: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Color(
                                                            0xFFEEEEEE)))),
                                          ),
                                          flex: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //就职医院
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              height: 50,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    //纵轴居中即垂直居中
                                    children: <Widget>[
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '就职医院 ',
                                              style: TextStyle(
                                                  color: Color(0xFF666666)),
                                            ),
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                  color: Color(0xFFE65D4E)),
                                            ),
                                          ],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 105),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: "请输入您的就职医院",
                                                hintStyle: TextStyle(
                                                    color: Color(0xFFCCCCCC),
                                                    fontSize: 12),
                                                border: InputBorder.none,
                                                contentPadding:
                                                EdgeInsets.all(0),
                                                suffix:
                                                    hospitalSuffixIconIsVisible
                                                        ? hospitalSuffixIcon
                                                        : null,
                                              ),
                                              controller: _uHospitalController,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    64),
                                              ],
                                              focusNode: _uHospitalFocusNode,
                                              keyboardType: TextInputType.name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF333333),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Color(
                                                            0xFFEEEEEE)))),
                                          ),
                                          flex: 1,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            //个人简介
                            Container(
                              padding: EdgeInsets.only(top: 14),
                              height: 100,
                              child: Stack(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '个人简介 ',
                                              style: TextStyle(
                                                  color: Color(0xFF666666)),
                                            ),
                                          ],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 105),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: "请输入您的个人简介",
                                                hintStyle: TextStyle(
                                                    color: Color(0xFFCCCCCC),
                                                    fontSize: 12),
                                                border: InputBorder.none,
                                                suffix:
                                                    descriptionSuffixIconIsVisible
                                                        ? descriptionSuffixIcon
                                                        : null,
                                                contentPadding:
                                                    EdgeInsets.all(0),
                                              ),
                                              controller:
                                                  _uDescriptionController,
                                              maxLines: 5,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    300),
                                              ],
                                              focusNode: _uDescriptionFocusNode,
                                              keyboardType: TextInputType.name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF333333),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Color(
                                                            0xFFEEEEEE)))),
                                          ),
                                          flex: 1,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            //问诊价格
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              height: 50,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    //纵轴居中即垂直居中
                                    children: <Widget>[
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '问诊价格(元) ',
                                              style: TextStyle(
                                                  color: Color(0xFF666666)),
                                            ),
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                  color: Color(0xFFE65D4E)),
                                            ),
                                          ],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 105),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: "请输入您的问诊价格",
                                                hintStyle: TextStyle(
                                                    color: Color(0xFFCCCCCC),
                                                    fontSize: 12),
                                                border: InputBorder.none,
                                                contentPadding:
                                                EdgeInsets.all(0),
                                                suffix: priceSuffixIconIsVisible
                                                    ? priceSuffixIcon
                                                    : null,
                                              ),
                                              controller: _uPriceController,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    10),InputFormat(),
                                              ],
                                              focusNode: _uPriceFocusNode,
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF333333),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Color(
                                                            0xFFEEEEEE)))),
                                          ),
                                          flex: 1,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            //专家认证
                            Container(
                              padding: EdgeInsets.only(top: 8),
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    //纵轴居中即垂直居中
                                    children: <Widget>[
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '专家认证  ',
                                              style: TextStyle(
                                                  color: Color(0xFF666666)),
                                            ),
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                  color: Color(0xFFE65D4E)),
                                            ),
                                          ],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 105),
                                    child: Stack(
                                      children: <Widget>[
                                        _previewImages(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ),
              flex: 1,
            ),
            //保存按钮
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: ElevatedButton(
                        onPressed: _isDisable ? null : onSaveClick,
                        child: Text(
                          '保存',
                          style: TextStyle(
                            color: Color(saveTextColor),
                            fontSize: 16,
                          ),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.zero),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all(
                              Color(saveBackgroundColor)),
                        ),
                      ),
                      height: 49,
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector deleteSuffixIcon(TextEditingController editingController) {
    return GestureDetector(
      onTap: () {
        //删除所有的输入的文字
        setState(() {
          editingController.clear();
          setSaveState();
        });
      },
      child: Image(
        image: AssetImage('assets/images/icon_delete_edit.png'),
        width: 16,
      ),
    );
  }

  void showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
          showTitle: true,
          // title: Text('请选择日期'),
          confirm: Text('确定'),
          cancel: Text('取消'),
          selectionOverlay: Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Color(0xFF009999)),
              ),
            ),
          )),
      maxDateTime: DateTime.now(),
      initialDateTime: _dateTime,
      dateFormat: 'yyyy-MM-dd',
      locale: DateTimePickerLocale.zh_cn,
      onCancel: () => print('onCancel'),
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          print('onConfirm');
          _dateTime = dateTime;
          uBirthDate = formatDate(_dateTime!, [yyyy, '-', mm, '-', dd]);
          print('日期：$uBirthDate');
        });
      },
    );
  }

  // 弹出底部菜单列表模态对话框 头像
  Future<int?> _showHeadBottomSheet() {
    return showModalBottomSheet<int>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(
                      headList![index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF009999),
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(index));
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1,
                  color: Color(0xFFEEEEEE),
                );
              },
              itemCount: headList.length,
            )
          ],
        );
      },
    );
  }

  // 弹出底部菜单列表模态对话框 职称
  Future<int?> _showDoctorTypeModalBottomSheet() {
    return showModalBottomSheet<int>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(
                      doctorTypeList[index].value!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF009999),
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(index));
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1,
                  color: Color(0xFFEEEEEE),
                );
              },
              itemCount: doctorTypeList.length,
            )
          ],
        );
      },
    );
  }

  // 弹出底部菜单列表模态对话框 技师资格
  Future<int?> _showTechnicianTypeModalBottomSheet() {
    return showModalBottomSheet<int>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(
                      technicianTypeList[index].value!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF009999),
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(index));
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1,
                  color: Color(0xFFEEEEEE),
                );
              },
              itemCount: technicianTypeList.length,
            )
          ],
        );
      },
    );
  }

  Widget _previewImages() {
    if (_certificationImageFileList != null && _certificationImageFileList!.length != 0) {
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 80,
              crossAxisCount: 4, //每行4列
              mainAxisSpacing: 8, //行间距 上一行与下一行的距离
              //childAspectRatio: 1.0, //显示区域宽高相等
              crossAxisSpacing: 8 //列间距 每一列的间距
              ),
          itemCount: _certificationImageFileList!.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          key: UniqueKey(),
          itemBuilder: (context, index) {
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: GestureDetector(
                child: Image.file(File(_certificationImageFileList[index].path)),
                onTap: () {
                  //点击事件
                  gotoGalleryMultiImage();
                },
              ),
            );
          });
    } else {
      return Row(
        children: <Widget>[
          GestureDetector(
            child: Image.asset(
              'assets/images/picture_default_add.png',
              fit: BoxFit.cover,
              width: 80,
            ),
            onTap: () {
              //TODO 去相册选择图片
              //gotoGallery().then((value) => null);
              unFocus();
              gotoGalleryMultiImage();
            },
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 8),
              child: Text(
                '请上传医生认证资料图片',
                style: TextStyle(fontSize: 12, color: Color(0xFFCCCCCC)),
              ),
            ),
            flex: 1,
          )
        ],
      );
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

//TODO 调接口完成保存信息修改
  void onSaveClick() async {
    print("保存");
    setState(() {
      // 当所有编辑框都失去焦点时键盘就会收起
      FocusScope.of(context).unfocus();
      String cardId;
      String? birthdate;
      int? gender;
      String name;
      int price;
      int? doctorType;
      int? technicianType;
      String hospital;
      String ?description;
      if (_uNameController.text.length==0) {
        Fluttertoast.showToast(msg: "请输入姓名");
        return;
      }
      if (_uIdCardController.text.length==0) {
        Fluttertoast.showToast(msg: "请输入身份证号");
        return;
      }
      IdCardUtil idCardUtil = new IdCardUtil(_uIdCardController.text);
      if (idCardUtil.isCorrect() > 1) {
        Fluttertoast.showToast(msg: "请输入正确格式的身份证号");
        return;
      }

      if (_uHospitalController.text.length==0) {
        Fluttertoast.showToast(msg: "请输入您的就职医院");
        return;
      }
      if (_uPriceController.text.length==0) {
        Fluttertoast.showToast(msg: "请输入您的问诊价格");
        return;
      }
      if (double.parse(_uPriceController.text) > 1000) {
        Fluttertoast.showToast(msg: "您输入的问诊价格已超出1000元");
        return;
      }
      if (_certificationImageFileList.length==0) {
        Fluttertoast.showToast(msg: "请上传您的认证资料图片");
        return;
      }
      cardId=_uIdCardController.text;
      if(uBirthDate.isNotEmpty){
        birthdate=uBirthDate;
      }
      if(_radioGroup!=null&&_radioGroup!.isNotEmpty){
        switch(_radioGroup){
          case '男':
            gender = 1;
            break;
          case '女':
            gender = 2;
            break;
        }
      }
      name=_uNameController.text;
      double tempPrice=double.parse(_uPriceController.text)*100;
      price=int.parse(tempPrice.toStringAsFixed(0));
      doctorType= getDoctorTypeKey(uDoctorTypeText);
      technicianType=getTechnicianTypeKey(uTechnicianTypeText);
      hospital=_uHospitalController.text;
      description=_uDescriptionController.text;
      //保存图片
      executeUploadImage(cardId, birthdate, gender, name, price, doctorType, technicianType, hospital, description);
    });
  }

  executeUploadImage(String cardId,
      String? birthdate,
      int? gender,
      String name,
      int price,
      int? doctorType,
      int? technicianType,
      String hospital,
      String ?description,
      ) async{
    if(isUploadHeadImage){
      if(_headFile!=null){
        var tempImageUrl=await uploadImage(File(_headFile!.path));
        if(tempImageUrl!=null){
          setState(() {
            _headImageUrl=tempImageUrl;
          });
        }

      }
    }
    if(isUploadCertificationImage){
      if(_certificationImageFileList.length!=0){
        var tempImageUrl=await uploadImage(File(_certificationImageFileList[0].path));
        if(tempImageUrl!=null){
          setState(() {
            _certificationImageUrl=tempImageUrl;
          });
        }

      }
    }
    String? headimgurl;
    String? certificationImgUrl;
    if(_headImageUrl.isNotEmpty){
      headimgurl=_headImageUrl;
    }
    if(_certificationImageUrl.isNotEmpty){
      certificationImgUrl=_certificationImageUrl;
    }
     await updateUserInfo(cardId, birthdate, gender, name, price, headimgurl, doctorType, technicianType, hospital, description, certificationImgUrl);
  }
  Future<void> gotoGalleryMultiImage() async {
    final List<XFile> pickedFileList = await _picker.pickMultiImage(
        // maxWidth: 80,
        // maxHeight: 80,
        // imageQuality: 100,

        );
    int length = pickedFileList.length;
    print("长度：$length");
    setState(() {
      _certificationImageFileList = pickedFileList;
      if(_certificationImageFileList.length!=0){
        isUploadCertificationImage=true;
      }
    });
  }

  Future<void> gotoCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    setHeadFile(pickedFile);
  }

  void setHeadFile(XFile? pickedFile) {
    setState(() {
      _headFile = pickedFile;
      _headFileImageProvider = FileImage(File(_headFile!.path));
      isUploadHeadImage=true;
    });
  }

  Future<void> gotoGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setHeadFile(pickedFile);
  }

  getUserInfoForEdit() async {
    try {
      if (!LoginPrefs(context).isLogin()) {
        LoginPrefs(context).logout();
        Navigator.of(context)
            .pushNamedAndRemoveUntil("login", ModalRoute.withName("login"));
        return;
      }
      GetUserInfoForEditResponseEntity getUserInfoForEditResponseEntity =
          await NetWorkWithToken(context).getUserInfoForEdit();
      if (getUserInfoForEditResponseEntity != null) {
        if (getUserInfoForEditResponseEntity.doctorExtend != null) {
          GetUserInfoForEditResponseDoctorExtend doctorExtend =
              getUserInfoForEditResponseEntity.doctorExtend!;
          if ((doctorExtend.name == null || doctorExtend.name!.isEmpty) &&
              (doctorExtend.cardId == null || doctorExtend.cardId!.isEmpty) &&
              (doctorExtend.hospital == null ||
                  doctorExtend.hospital!.isEmpty)) {
            doctorExtend.price = null;
          }
          setViewData(doctorExtend);
        }
      }
    } on DioError catch (e) {
      print(e.message!);
    } finally {}
  }

  setViewData(GetUserInfoForEditResponseDoctorExtend doctorExtend)  {
    setState(() {
      if(doctorExtend.id!=null&&doctorExtend.id!=0){
        id=doctorExtend.id;
      }
      if(doctorExtend.doctorId!=null&&doctorExtend.doctorId!=0){
        doctorId=doctorExtend.doctorId;
      }
      //审核状态
      if(doctorExtend.auditStatus!=null){
        auditStatus=doctorExtend.auditStatus;
        switch(doctorExtend.auditStatus){
          case 1:
            auditStatusText='等待审核';
            break;
          case 2:
            auditStatusText='审核通过';
            break;
          case 3:
            auditStatusText='审核未过';
            break;
        }
        if(doctorExtend.auditStatus!=2){
           auditStatusTextColor = 0xFFF5A631;//审核未通过/等待审核的字体颜色
           auditStatusBackgroundColor = 0x1AF5A631;//审核未通过/等待审核的字体颜色
        }else{
          auditStatusTextColor = 0xFF009999;//审核通过字体颜色
          auditStatusBackgroundColor = 0x1A009999;//审核通过字体颜色
        }



      }

      if (doctorExtend.headimgurl != null) {
        _headImageUrl=doctorExtend.headimgurl!;
        //头像
        if (_headFile == null) {
          _headFile = XFile(doctorExtend.headimgurl!);
          _headFileImageProvider = NetworkImage(_headFile!.path);
        }
        isUploadHeadImage=false;
      }
      _uNameController.text = doctorExtend.name!; //姓名
      if(doctorExtend.phoneNumber!=null){
        phoneNumber=doctorExtend.phoneNumber;
      }
      _uIdCardController.text = doctorExtend.cardId!; //身份证
      if (doctorExtend.gender != null) {
        //性别
        switch (doctorExtend.gender) {
          case 1:
            _radioGroup = "男";
            break;
          case 2:
            _radioGroup = "女";
            break;
        }
      }
      if (doctorExtend.birthdate != null &&
          doctorExtend.birthdate!.isNotEmpty) {
        uBirthDate = doctorExtend.birthdate!.substring(0, 10); //出生日期
      }
      if (doctorExtend.doctorType != null) {
        uDoctorTypeText = getDoctorTypeValue(doctorExtend.doctorType!.toString()); //职称
      }
      if (doctorExtend.technicianType != null) {
        uTechnicianTypeText =
            getTechnicianTypeValue(doctorExtend.technicianType!.toString()); //技师资格
      }
      _uHospitalController.text = doctorExtend.hospital!; //就职医院
      if (doctorExtend.description != null) {
        _uDescriptionController.text = doctorExtend.description!; //个人简介
      }
      if (doctorExtend.price != null) {
        _uPriceController.text = (doctorExtend.price!.toDouble() / 100) //问诊价格
            .toStringAsFixed(2);
      }
      if (doctorExtend.certificationImgUrl != null) {
        _certificationImageUrl=doctorExtend.certificationImgUrl!;
        //专家认证
        getImageFileList(doctorExtend.certificationImgUrl!);
        isUploadCertificationImage=false;

      }
    });
    setSaveState();
  }

  getImageFileList(String imageUrl) async{
    var tempDir = await getTemporaryDirectory();
    var now=DateTime.now().microsecond.toString().replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    String fullPath = tempDir.path + "/$now.jpg";
    print('full path ${fullPath}');
    downloadImageFile(imageUrl,fullPath);

  }
  void downloadImageFile(String imageUrl,String path) async{
    //await downloadImageProgress(imageUrl, path);
    await downloadImage(imageUrl, path);


  }

  String getDoctorTypeValue(String doctorType) {
    for (int i = 0; i < doctorTypeList.length; i++) {
      if (doctorType == doctorTypeList[i].key) {
        return doctorTypeList[i].value!;
      }
    }
    return "";
  }

  int? getDoctorTypeKey(String doctorType) {
      for (int i = 0; i < doctorTypeList.length; i++) {
        if (doctorType == doctorTypeList[i].value) {
          return int.tryParse(doctorTypeList[i].key!);
        }
      }
    return null;
  }

  String getTechnicianTypeValue(String technicianType) {
    for (int i = 0; i < technicianTypeList.length; i++) {
      if (technicianType == technicianTypeList[i].key) {
        return technicianTypeList[i].value!;
      }
    }
    return "";
  }

  int? getTechnicianTypeKey(String technicianType) {
    for (int i = 0; i < technicianTypeList.length; i++) {
      if (technicianType == technicianTypeList[i].value) {
        return int.tryParse(technicianTypeList[i].key!);
      }
    }
    return null;
  }

  Future  downloadImageProgress(String url, String savePath) async {
    try {
      Response response = await NetWorkWithoutToken(context).downLoadFile(url, savePath, (count, total) {
        print('count==$count');
        print('total==$total');
        if (total != -1) {
          String percent=(count / total * 100).toStringAsFixed(0) + "%";
          print(percent);
        }
      });
      if(response!=null){
        File file=new File(savePath);
        if (file.existsSync() && file.length() != 0) {
          setState(() {
            _certificationImageFileList.add(XFile(file.path));
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }
  Future  downloadImage(String url, String savePath) async {
    try {
      List<int>? data = await NetWorkWithoutToken(context).downLoadFileNotProgress(url);
      if (data != null) {
        File file = File(savePath);
        var raf = file.openSync(mode: FileMode.write);
        // buffer is List<int> type
        raf.writeFromSync(data);
        await raf.close();
        if (file.existsSync() && file.length() != 0) {
          setState(() {
            _certificationImageFileList.add(XFile(file.path));
          });
        }
      }
    }catch(e){
      print(e);
    }
  }
  Future<void> requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();
    setState(() {
      for (PermissionStatus value in statuses.values) {
        if(value.isDenied){
          _permissionDenied=true;
          break;
        }
      }
      _permissionDenied=false;
    });


  }

  uploadImage(File file) async{
    try {
      if (!LoginPrefs(context).isLogin()) {
        LoginPrefs(context).logout();
        Navigator.of(context)
            .pushNamedAndRemoveUntil("login", ModalRoute.withName("login"));
        return;
      }
      StsUploadResponseRequestEntity stsUploadResponseRequestEntity=new StsUploadResponseRequestEntity();
      stsUploadResponseRequestEntity.fileType=1;
      stsUploadResponseRequestEntity.fileName=file.path;
      StsUploadResponseResponseEntity stsUploadResponseResponseEntity =
      await NetWorkWithToken(context).stsUploadResponse(stsUploadResponseRequestEntity);//调接口获取oss需要的参数
      if (stsUploadResponseResponseEntity != null) {
        String accessKeyId=stsUploadResponseResponseEntity.accessKeyId;
        String accessKeySecret=stsUploadResponseResponseEntity.accessKeySecret;
        String securityToken=stsUploadResponseResponseEntity.securityToken;
        String bucket=stsUploadResponseResponseEntity.bucket;
        String endPoint=stsUploadResponseResponseEntity.endPoint;
        String ossFileFullName=stsUploadResponseResponseEntity.ossFileFullName;
        ossAccessKeyId=accessKeyId;
        ossAccessKeySecret=accessKeySecret;
        bucketName=bucket;
        ossEndPoint=endPoint;
        ossSecurityToken=securityToken;
        String fileType=ossFileFullName.substring(ossFileFullName.lastIndexOf('.')+1);
        print(fileType);
        Uint8List imageData;
        imageData=await file.readAsBytes();
        String path=await OssUtil().ossUploadImage(imageData, ossFileFullName,fileType: fileType);
        print('阿里云返回的路径：'+path);
        return path;
      }
    } on DioError catch (e) {
      print(e.message!);
    } finally {}
  }
  updateUserInfo(String cardId,
      String? birthdate,
      int? gender,
      String name,
      int price,
      String? headimgurl,
      int? doctorType,
      int? technicianType,
      String hospital,
      String ?description,
      String? certificationImgUrl,
      )async{
    try {
      if (!LoginPrefs(context).isLogin()) {
        LoginPrefs(context).logout();
        Navigator.of(context)
            .pushNamedAndRemoveUntil("login", ModalRoute.withName("login"));
        return;
      }
      CreateOrUpdateDoctorExtendInputRequestEntity createOrUpdateDoctorExtendInputRequestEntity=new CreateOrUpdateDoctorExtendInputRequestEntity();
      CreateOrUpdateDoctorExtendInputRequestDoctorExtend doctorExtend=new CreateOrUpdateDoctorExtendInputRequestDoctorExtend();
      if(id!=null&&id!=0){
        doctorExtend.id=id;
      }

      if(doctorId==null||doctorId==0){
        if(LoginPrefs(context).getUserId()!=null&&LoginPrefs(context).getUserId()!.isNotEmpty){
          doctorId=int.parse(LoginPrefs(context).getUserId()!);
        }
      }
      doctorExtend.doctorId=doctorId;
      doctorExtend.cardId=cardId;
      if(birthdate!=null&&birthdate.isNotEmpty){
        doctorExtend.birthdate=birthdate;
      }
      if(gender!=null){
        doctorExtend.gender=gender;
      }
      doctorExtend.name=name;
      doctorExtend.price=price;

      if(headimgurl!=null&&headimgurl.isNotEmpty){
        doctorExtend.headimgurl=headimgurl;
      }
      if(doctorType!=null){
        doctorExtend.doctorType=doctorType;
      }
      if(technicianType!=null){
        doctorExtend.technicianType=technicianType;
      }
      doctorExtend.hospital=hospital;

      if(description!=null&&description.isNotEmpty){
        doctorExtend.description=description;
      }
      if(certificationImgUrl!=null&&certificationImgUrl.isNotEmpty){
        doctorExtend.certificationImgUrl=certificationImgUrl;
      }
      // if(phoneNumber!=null){
      //   doctorExtend.phoneNumber=phoneNumber;
      // }
      // if(auditStatus!=null){
      //   doctorExtend.auditStatus=auditStatus;
      // }
      doctorExtend.auditStatus=1;
      createOrUpdateDoctorExtendInputRequestEntity.doctorExtend=doctorExtend;
      UpdateUserInfoResponseEntity updateUserInfoResponseEntity=await NetWorkWithToken(context).updateUserInfo(createOrUpdateDoctorExtendInputRequestEntity);
      if(updateUserInfoResponseEntity!=null){
        if(updateUserInfoResponseEntity.msg!=null&&updateUserInfoResponseEntity.msg!.isNotEmpty){
          //编辑失败
          Fluttertoast.showToast(msg: updateUserInfoResponseEntity.msg!);
          return;
        }
        //编辑成功继续
        if(updateUserInfoResponseEntity.doctorExtend!=null){
          Fluttertoast.showToast(msg: "编辑信息成功！");
          Navigator.of(context).pop('refreshData'); //告诉前一页面需要刷新数据了
        }

      }
    }on DioError catch(e){
      print(e.message!);
      }finally{

    }
  }
  unFocus(){
  setState(() {
    if(_uNameFocusNode.hasFocus){
      _uNameFocusNode.unfocus();
    }
    if(_uIdCardFocusNode.hasFocus){
      _uIdCardFocusNode.unfocus();
    }
    if(_uHospitalFocusNode.hasFocus){
      _uHospitalFocusNode.unfocus();
    }
    if(_uDescriptionFocusNode.hasFocus){
      _uDescriptionFocusNode.unfocus();
    }
    if(_uPriceFocusNode.hasFocus){
      _uPriceFocusNode.unfocus();
    }
  });

}

}
