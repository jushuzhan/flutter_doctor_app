import 'dart:convert';
import 'dart:io';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';
import 'package:flutter_doctor_app/common/Prefs.dart';
import 'package:flutter_doctor_app/models/EnumBean.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:image_picker/image_picker.dart';


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

  String auditStatusText = '等待审核';
  int auditStatusTextColor = 0xFFF5A631;
  int auditStatusBackgroundColor = 0x1AF5A631;

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

  late List<EnumBean> doctorTypeList;
  late List<EnumBean> technicianTypeList;

  String? _radioGroup = "";

  void _handleRadioValueChanged(String? value) {
    setState(() {
      _radioGroup = value;
    });
  }

  List<XFile>? _imageFileList;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initView();
  }

  void initView() {
    doctorTypeList = getDoctorType();
    doctorTypeList.add(EnumBean(key: "", value: "取消"));
    technicianTypeList = getTechnicianType();
    technicianTypeList.add(EnumBean(key: "", value: "取消"));
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
    // if (_originalPasswordController.text.length >= 6&&_newPasswordController.text.length >= 6&&_surePasswordController.text.length >= 6) {
    //   setState(() {
    //     _isDisable = false; //保存按钮可用
    //     saveTextColor = 0xFFFFFFFF;
    //     saveBackgroundColor = 0xFF009999;
    //   });
    // } else {
    //   setState(() {
    //     _isDisable = true; //保存按钮不可用
    //     saveTextColor = 0xFF999999;
    //     saveBackgroundColor = 0xFFE6E6E6;
    //   });
    // }
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
                            Container(
                              padding: EdgeInsets.only(top: 8),
                              height: 96,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                //纵轴居中即垂直居中
                                children: <Widget>[
                                  Text(
                                    '头像',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Image.asset(
                                            'assets/images/info_image_portrait.png'),
                                        width: 56,
                                        alignment: Alignment.center,
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
                                  )
                                ],
                              ),
                            ),
                            //分割线
                            Divider(
                              height: 1,
                              color: Color(0xFFeeeeee),
                            ),
                            //姓名
                            Container(
                              padding: EdgeInsets.only(top: 8),
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
                              padding: EdgeInsets.only(top: 8),
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
                              padding: EdgeInsets.only(top: 8),
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
                              padding: EdgeInsets.only(top: 8),
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
                              padding: EdgeInsets.only(top: 8),
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
                              padding: EdgeInsets.only(top: 8),
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
                              padding: EdgeInsets.only(top: 8),
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
                              padding: EdgeInsets.only(top: 8),
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
                                                suffix: priceSuffixIconIsVisible
                                                    ? priceSuffixIcon
                                                    : null,
                                              ),
                                              controller: _uPriceController,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    10),
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
        });
      },
      child: Image(
        image: AssetImage('assets/images/icon_delete_edit.png'),
        width: 16,
      ),
    );
  }

  //@param label label  @param textData 数据 @param hintText hintText @param onClick 点击事件
  Container chooseDataContainer(
      String label, String textData, String hintText, void Function() onClick) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      height: 50,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            //纵轴居中即垂直居中
            children: <Widget>[
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: label,
                      style: TextStyle(color: Color(0xFF666666)),
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
                              onClick();
                            },
                            child: Text(
                              "" == textData ? hintText : textData,
                              style: "" == textData
                                  ? defaultNoDataTextStyle
                                  : dataTextStyle,
                            ),
                          ),
                          flex: 1,
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
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0xFFEEEEEE)))),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
        ],
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

  Widget _previewImages(){
    if (_imageFileList != null&&_imageFileList!.length!=0) {
      return GridView.builder(
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 80,
                  crossAxisCount: 4, //每行4列
                  mainAxisSpacing: 8,//行间距 上一行与下一行的距离
                  //childAspectRatio: 1.0, //显示区域宽高相等
                  crossAxisSpacing: 8//列间距 每一列的间距
                ),
                itemCount: _imageFileList!.length,
                physics:NeverScrollableScrollPhysics(),
                shrinkWrap:true,
                key: UniqueKey(),
                itemBuilder: (context, index) {
                  return Semantics(
                    label: 'image_picker_example_picked_image',
                    child: GestureDetector(
                      child: kIsWeb
                          ? Image.network(_imageFileList![index].path)
                          : Image.file(File(_imageFileList![index].path)),
                      onTap: (){
                        //点击事件
                        gotoGallery();
                      },
                    ),
                  );
                });
    }else{
      return  Row(
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
              gotoGallery();
            },
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding:
              EdgeInsets.only(left: 8),
              child: Text(
                '请上传医生认证资料图片',
                style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFCCCCCC)),
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
      //TODO 调接口保存信息
      Navigator.of(context).pop(); //密码修改成功，此页消失。
    });
  }

  Future<void> gotoGallery() async {
    final List<XFile> pickedFileList = await _picker.pickMultiImage(
      // maxWidth: 80,
      // maxHeight: 80,
      // imageQuality: 100,

    );
    int length=pickedFileList.length;
    print("长度：$length");
    setState(() {
      _imageFileList = pickedFileList;
    });
  }
}
