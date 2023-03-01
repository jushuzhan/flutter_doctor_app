//配置路由

import 'package:flutter/material.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';
import 'package:flutter_doctor_app/register.dart';
import '../about.dart';
import '../bindphone.dart';
import '../changebindphone.dart';
import '../changephone.dart';
import '../editinfo.dart';
import '../forgetpassword.dart';
import '../imagepickerdemo.dart';
import '../login.dart';
import '../main.dart';
import '../modifypassword.dart';
import '../orderList.dart';
import '../personal.dart';
import '../privacypolicy.dart';
import '../setpassword.dart';
import '../setting.dart';

/*
 *  这个方法是固定写法，功能就像是一个拦截器。
 */
Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  Map<String, Widget> routes = {
    'home': MyHomePage(), //定义app路径
    'login': LoginPage(), //定义login路径
    'register':RegisterPage(),//定义注册路径
    'privacy_policy':PrivacyPolicyPage(),//定义隐私政策路径
    'forget_password':ForgetPasswordPage(),//定义忘记密码路径
    'personal':PersonalPage(),//定义个人中心路径
    'setting':SettingPage(),//定义设置路径
    'modify_password':ModifyPasswordPage(),//定义修改密码路径
    'about':AboutPage(),//定义关于我们路径
    'change_bind_phone':ChangeBindPhonePage(),//定义换绑手机路径
    'change_phone':ChangePhonePage(),//定义换绑手机路径
    'bind_phone':BindPhonePage(),//定义绑定手机路径
    'set_password':SetPasswordPage(),//定义设置密码路径
    'edit_info':EditInfoPage(),//定义编辑信息路径
    'image_picker_demo':ImagePickerDemoPage(),//定义demo路径
    'order_list':OrderListPage(),//定义订单列表路径
  };

  String routerName = routeBeforeHook(settings);
  bool mathMap = false;
  Route<dynamic>? mathWidget;
  routes.forEach((key, v) {
    if (key == routerName) {
      mathMap = true;
      mathWidget = MaterialPageRoute(builder: (BuildContext context) => v);
    }
  });

  if (mathMap) {
    return mathWidget;
  }
  return MaterialPageRoute(
      builder: (BuildContext context) => Container(
            child: Text('404'),
          ));
}

String routeBeforeHook(RouteSettings settings) {
  if('home'==settings.name!&&checkToken()==false)
    return 'login';
  return settings.name!;
}
bool checkToken() {
  String token = LoginPrefs.getAccessToken()??'';
  if ('' != token) return true;
    return false;
}
