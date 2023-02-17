
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/common/AppVersion.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() {
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPage> {
 late String? appName;
 late String? version;
 late String? buildNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVersion();
  }
  getVersion() {
    setState(() {
      appName = AppVersion.getAppName();
      version = AppVersion.getVersion();
      buildNumber = AppVersion.getBuildNumber();
      print('appName:$appName');
      print('version:$version');
      print('buildNumber:$buildNumber');
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFFFFFFF),
        titleSpacing: 15.0,
        //标题距离左边大小
        title: Text(
          "关于我们",
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
        width: MediaQuery.of(context).size.width, // 获取屏幕尺寸,宽度充满全屏,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            //上半部分
            Container(
              width: MediaQuery.of(context).size.width, // 获取屏幕尺寸,宽度充满全屏,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 40,horizontal: 15),
              child: Image.asset(
                'assets/images/about_image_logo.png',
                width: 80,
                alignment: Alignment.center,
              ),
            ),
            //中间部分
            Expanded(child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15,),
              child: Text('\u3000\u3000秉承科技创新精神，以互联网大数据技术结合传统技术，构建一个服务平台——全新眼健康系统。',style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),),
            ),flex: 1,),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(bottom: 16),
              alignment: Alignment.center,
              child: Text('APP版本：V$version',style: TextStyle(
                fontSize: 12,
                color: Color(0xFF999999)
              ),),
            )

          ],
        ),
      ),
    );
  }
}
