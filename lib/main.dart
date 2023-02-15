import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color.dart';
import 'keepalivewrapper.dart';
import 'common/MyRoutes.dart';
import 'common/LoginPrefs.dart';

void main() async{
  String value= await LoginPrefs.init();// await 关键字必须用在异步方法中 await等待异步方法执行完毕 异步方法必须用变量接收
  if('ok'==value){
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List tabs = ["已申请", "已同意", "已诊断", "全部"];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("问诊申请",style: TextStyle(
            fontSize: 18,
            color: Color(0xFFFFFFFF)
          ),),
          bottom: TabBar(
            tabs: tabs.map((e) => Tab(text: e)).toList(),
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Color(0xFFFFFFFF),
            unselectedLabelColor: Color(0x99FFFFFF),
            labelStyle: TextStyle(
              fontSize:16
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14
            ),
            indicatorPadding: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(bottom: 8),

          ),
          actions: [
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, 'personal');//跳转至首页
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
          systemOverlayStyle: SystemUiOverlayStyle.light,//状态栏字体为白色
        ),
        body: TabBarView(
          //构建
          children: tabs.map((e) {
            return KeepAliveWrapper(
              child: Container(
                alignment: Alignment.center,
                child: Text("目前还没有申请\n点击刷新",
                    textScaleFactor: 1.5,
                    style: TextStyle(
                        color: createMaterialColor(Color(0xFF999999)))),
                // child:ConstrainedBox(//通过ConstrainedBox来确保Stack占满屏幕
                //   constraints: BoxConstraints.expand(),
                //   child: Stack(
                //     alignment: Alignment.center,//指定未定位或部分定位widget的对齐方式
                //     fit: StackFit.expand,//未定位widget占满Stack整个空间
                //     children: <Widget>[
                //       Container(
                //         child:Text(e,textScaleFactor: 1.5,style: TextStyle(color: createMaterialColor(Color(0xFF999999))),textAlign: TextAlign.center,),
                //       )
                //     ],
                //   ),
                // ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
