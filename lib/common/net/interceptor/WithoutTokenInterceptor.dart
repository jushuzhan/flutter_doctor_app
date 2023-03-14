import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_doctor_app/common/LoginPrefs.dart';


import '../../../main.dart';
import '../../../models/BaseBean.dart';
import '../../../models/RefreshTokenRequest.dart';
import '../../../models/RefreshTokenResponse.dart';
import '../../../models/logout_this_device_request_entity.dart';
import '../../constants/constants.dart';
import '../NetWorkWithToken.dart';
import '../NetWorkWithoutToken.dart';


class WithoutTokenInterceptor extends QueuedInterceptor{
  late Dio _dio;
  bool isReLogin = false;
  WithoutTokenInterceptor(this._dio);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    // TODO: implement onRequest
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // TODO: implement onResponse
    //print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('RESPONSE');
    print('${response.statusCode}');
    super.onResponse(response, handler);


  }
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // TODO: implement onError
    if(err.response==null){
      return;
    }
    //print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('Interceptor:ERROR');
    print('Interceptor:${err.response?.statusCode}');
    BuildContext context=navigatorKey.currentState!.context;
    if(err.response!=null&&err.response!.statusCode==456){
//401代表token过期
      String? userId = LoginPrefs(context).getUserId();
      if (userId==null||userId.isEmpty) {
        print("Interceptor:sp取到的userId为空");
        handler.reject(err);
        //如果sp取到userid为空，可以直接认为用户没有登录过，直接提示登录即可
        Navigator.of(context).pushNamedAndRemoveUntil(
            "login", ModalRoute.withName("login"));

        return;
      }

      LogoutThisDeviceRequestEntity logoutThisDeviceRequestEntity=LogoutThisDeviceRequestEntity();
      logoutThisDeviceRequestEntity.userId=userId!;
      logoutThisDeviceRequestEntity.loginType=LOGIN_TYPE;
      logoutThisDeviceRequestEntity.clientId=CLIENT_ID;
      logoutThisDeviceRequestEntity.deviceUUID=JIGUANGID;
      BaseBean baseBean= await NetWorkWithoutToken(context).logoutThisDevice(logoutThisDeviceRequestEntity);
      if(baseBean!=null){
        handler.reject(err);
        print('Interceptor:退出设备${baseBean.success}');
        LoginPrefs(context).logout();
        Navigator.of(context).pushNamedAndRemoveUntil(
            "login", ModalRoute.withName("login"));
      }else{
        LoginPrefs(context).logout();
        Navigator.of(context).pushNamedAndRemoveUntil(
            "login", ModalRoute.withName("login"));
      }
    }else{
    return handler.next(err);
    }
  }
}