
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/common/AppVersion.dart';

class ChangeBindPhonePage extends StatefulWidget {
  @override
  _ChangeBindPhonePageState createState() {
    return _ChangeBindPhonePageState();
  }
}

class _ChangeBindPhonePageState extends State<ChangeBindPhonePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFFFFFFF),
        titleSpacing: 15.0,
        //标题距离左边大小
        title: Text(
          "换绑手机",
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
                'assets/images/change_mobile_warn.png',
                width: 80,
                alignment: Alignment.center,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Text('当前手机号码 186 0000 2036',style: TextStyle(
                fontSize: 18,
                color: Color(0xFF666666)
              ),),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 14,bottom: 40),
              child: Text('已将该手机号码绑定账号，可用于手机账号的登录方式',style: TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
              ),),

            ),

            //更换手机号码
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 58),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: ElevatedButton(
                        onPressed: ()=> Navigator.of(context).pop(),//TODO 之后跳转换绑手机界面
                        child: Text(
                          '更换手机号码',
                          style: TextStyle(
                            color: Colors.white,
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
                              Color(0xFF009999)),
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
      ),
    );
  }
}
