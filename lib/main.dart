import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/callback/TabListener.dart';
import 'package:flutter_doctor_app/common/App.dart';
import 'package:flutter_doctor_app/common/net/NetWorkWithToken.dart';
import 'package:flutter_doctor_app/common/view/LoadingDialog.dart';
import 'color.dart';
import 'common/Prefs.dart';
import 'common/constants/constants.dart';
import 'common/net/NetWorkWithoutToken.dart';
import 'common/view/DownLoadDialog.dart';
import 'examVisitList.dart';
import 'keepalivewrapper.dart';
import 'common/MyRoutes.dart';
import 'common/LoginPrefs.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'models/doctor_extend_by_doctor_id_response_entity.dart';
import 'models/get_current_app_vision_response_entity.dart';
import 'models/get_paged_exam_visit_for_doctor_input_entity.dart';
import 'models/paged_result_dto_response_entity.dart';
import 'common/event/event.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

void main() async {
  String value =
      await App.init(); // await 关键字必须用在异步方法中 await等待异步方法执行完毕 异步方法必须用变量接收
  if ('ok' == value) {
    runApp(MyApp());
  }
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      //去除右上角的Debug标签
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: createMaterialColor(Color(0xFF009999)),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "home",
      onGenerateRoute: onGenerateRoute,
      //注册路由表
    );
  }
}

typedef RefreshDataCallBack = void Function(); //接口回调 tab切换 点击或是滑动

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List tabs = ["已申请", "已同意", "已诊断", "全部"];
  List<PagedResultDtoResponseItems>? items = [];
  late TabController _tabController;
  ImageProvider backgroundImage =
      AssetImage('assets/images/info_image_portrait.png');
  var warnDialog;
  var downLoadDialog;
  bool _permissionDenied = true; //默认权限拒绝

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDoctorExtendInfo();
    });

    _tabController = TabController(vsync: this, length: tabs.length);
    //监听tab切换的回调
    _tabController.addListener(() {
      var index = _tabController.index;
    });

    eventBus.on<MyEventRefresh>().listen((event) {
      // All events are of type MyEventRefresh (or subtypes of it).
      print(event.isRefresh);
      if (event.isRefresh) {
        //需要刷新数据
        getDoctorExtendInfo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "问诊申请",
          style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs.map((e) => Tab(text: e)).toList(),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Color(0xFFFFFFFF),
          unselectedLabelColor: Color(0x99FFFFFF),
          labelStyle: TextStyle(fontSize: 16),
          unselectedLabelStyle: TextStyle(fontSize: 14),
          indicatorPadding: EdgeInsets.only(top: 10),
          padding: EdgeInsets.only(bottom: 8),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              skipPersonalCenter();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: CircleAvatar(
                backgroundImage: backgroundImage,
              ),
            ),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light, //状态栏字体为白色
      ),
      body: TabBarView(
        controller: _tabController,
        //构建
        children: tabs.map((e) {
          return KeepAliveWrapper(
            child: ExamVisitListPage(e),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  void getDoctorExtendInfo() {
    if (!LoginPrefs(context).isLogin()) {
      LoginPrefs(context).logout();
      Navigator.of(context)
          .pushNamedAndRemoveUntil("login", ModalRoute.withName("login"));
      return;
    }
    getDoctorExtendByDoctorId();
  }

  getDoctorExtendByDoctorId() async {
    DoctorExtendByDoctorIdResponseEntity doctor =
        await NetWorkWithToken(context)
            .getDoctorExtendByDoctorId(LoginPrefs(context).getUserId());
    if (doctor != null) {
      //更新头像
      setState(() {
        if (doctor.headimgurl != null) {
          backgroundImage = NetworkImage(doctor.headimgurl!);
        }
      });
    } else {
      warnDialog = await _alertDialog();
    }
  }

  Container verticalLine() {
    return Container(
      height: 24,
      width: 1,
      color: Color(0xFFE6E6E6),
    );
  }

  void skipPersonalCenter() async {
    var result = await Navigator.pushNamed(context, 'personal'); //跳转至个人中心
    if (result != null) {
      //重新调取接口
      getDoctorExtendInfo();
    }
  }

  void skipEditInfo() async {
    if (warnDialog != null) {
      Navigator.pop(context);
    }
    var result = await Navigator.pushNamed(context, 'edit_info'); //跳转至编辑信息
    if (result != null) {
      //重新调取接口
      getDoctorExtendInfo();
    }
  }

  getCurrentAppVision(int appType, int appPlatform) async {
    GetCurrentAppVisionResponseEntity currentAppVisionResponseEntity =
        await NetWorkWithoutToken(context)
            .getCurrentAppVision(appType, appPlatform);
    if (currentAppVisionResponseEntity != null) {
      if (currentAppVisionResponseEntity.vision != null) {
        if (currentAppVisionResponseEntity.vision! > VERSION) {
          var alertDialogs = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "版本更新",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    "检测到新版本，是否立即更新？",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                  ),
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
                                  Navigator.pop(context); //关闭弹窗
                                  SystemNavigator.pop();//关闭此界面
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
                                    '确认',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF009999),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context); //关闭弹窗
                                  //下载apk
                                  downLoadApk(currentAppVisionResponseEntity
                                      .downLoadUrl!);
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
              },
              barrierDismissible: false);

          //弹窗提示
        } else if (currentAppVisionResponseEntity.vision == VERSION &&
            currentAppVisionResponseEntity.build! > BUILD) {
          var alertDialogs = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "版本更新",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    "检测到新版本，是否立即更新？",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                  ),
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
                                  Navigator.pop(context); //关闭弹窗
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
                                    '确认',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF009999),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context); //关闭弹窗
                                  //下载apk
                                  downLoadApk(currentAppVisionResponseEntity
                                      .downLoadUrl!);
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
              },
              barrierDismissible: false);
        }
      }
    }
  }

  Future downloadApkProgress(String url, String savePath) async {
    try {
      Response response = await NetWorkWithoutToken(context)
          .downLoadFile(url, savePath, (count, total) {
        print('count==$count');
        print('total==$total');
        if (total != -1) {
          setState(() {
            var p = (count / total).toStringAsFixed(2);
           double progress = double.parse(p);
           String percent = (count / total * 100).toStringAsFixed(0) + "%";
            print(percent);
            eventBus.fire(MyEventProgress(percent,progress));
          });
        }
      });
      if (response != null) {
        File file = new File(savePath);
        if (file.existsSync() && file.length() != 0) {
          setState(() {
            //下载完apk 安装
            if(downLoadDialog!=null){
              Navigator.pop(context);
            }
            installApk(file.path);
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  _alertDialog() async {
    var alertDialogs = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "您还未添加认证信息",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.bold),
            ),
            content: Text(
              "请先添加您的认证信息",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
            ),
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
                            Navigator.pop(context); //关闭弹窗
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
                              '立即添加',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF009999),
                              ),
                            ),
                          ),
                          onTap: () {
                            //下载apk
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
        },
        barrierDismissible: false);
    return alertDialogs;
  }



  void downLoadApk(String downLoadUrl) async {
    var tempDir = await getTemporaryDirectory();
    String fullPath = tempDir.path + "/lbjkdoctor.apk";
    print('full path ${fullPath}');
    File file = new File(fullPath);
    if (file.existsSync()) {
      file.deleteSync();
    }
    downLoadDialog= DownloadDialog.showDownLoadDialog(context);
    await downloadApkProgress(downLoadUrl, fullPath);


  }

  Future<void> requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.requestInstallPackages,
      Permission.camera,
      Permission.storage,
    ].request();
    setState(() {
      for (PermissionStatus value in statuses.values) {
        if (value.isDenied) {
          _permissionDenied = true;
          break;
        }
      }
      _permissionDenied = false;
      if (_permissionDenied == false) {
        getCurrentAppVision(3, 2);
      }
    });
  }



  void installApk(String apkPath) async {
    OpenFile.open(apkPath);
  }
}
