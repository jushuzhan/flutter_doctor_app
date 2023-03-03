import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/callback/TabListener.dart';
import 'package:flutter_doctor_app/common/App.dart';
import 'package:flutter_doctor_app/common/net/NetWorkWithToken.dart';
import 'color.dart';
import 'common/Prefs.dart';
import 'common/net/NetWorkWithoutToken.dart';
import 'examVisitList.dart';
import 'keepalivewrapper.dart';
import 'common/MyRoutes.dart';
import 'common/LoginPrefs.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'models/get_paged_exam_visit_for_doctor_input_entity.dart';
import 'models/paged_result_dto_response_entity.dart';


void main() async{
  String value= await App.init(); // await 关键字必须用在异步方法中 await等待异步方法执行完毕 异步方法必须用变量接收
  if('ok'==value){
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
typedef RefreshDataCallBack = void Function();//接口回调 tab切换 点击或是滑动
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List tabs = ["已申请", "已同意", "已诊断", "全部"];
  List<PagedResultDtoResponseItems>? items=[];
  late TabController _tabController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    //监听tab切换的回调
    _tabController.addListener(() {
      var index=_tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("问诊申请", style: TextStyle(
              fontSize: 18,
              color: Color(0xFFFFFFFF)
          ),),
          bottom: TabBar(
            controller: _tabController,
            tabs: tabs.map((e) => Tab(text: e)).toList(),
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Color(0xFFFFFFFF),
            unselectedLabelColor: Color(0x99FFFFFF),
            labelStyle: TextStyle(
                fontSize: 16
            ),
            unselectedLabelStyle: TextStyle(
                fontSize: 14
            ),
            indicatorPadding: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(bottom: 8),

          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'personal'); //跳转至首页
              },
              child: Container(
                width: 40,
                //TODO 之后需要改变头像的路径
                child: Image.asset(
                  'assets/images/info_image_portrait.png',
                ),
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0.0),
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


}


