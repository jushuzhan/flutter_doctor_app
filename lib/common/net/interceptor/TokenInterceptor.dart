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


class TokenInterceptor extends Interceptor{
  late Dio _dio;
  bool isReLogin = false;
  Queue queue = new Queue();
  TokenInterceptor(this._dio);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }
  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    // TODO: implement onResponse
    //print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('RESPONSE');
    print('${response.statusCode}');
    super.onResponse(response, handler);


  }
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // TODO: implement onError
    //print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('ERROR');
    print('${err.response?.statusCode}');
    BuildContext context= err.requestOptions.extra['context'];
    if(err.response!=null&&err.response!.statusCode==401){
      //401代表token过期
      String? userId = LoginPrefs.getUserId();
      if (userId==null||userId.isEmpty) {
        print("sp取到的userId为空");
        //如果sp取到userid为空，可以直接认为用户没有登录过，直接提示登录即可
        print("刷新token也失败了");
        Navigator.of(context).pushNamedAndRemoveUntil(
            "login", ModalRoute.withName("login"));
      }

      RefreshTokenRequest refreshTokenRequest=RefreshTokenRequest(clientId: CLIENT_ID, userId: userId, deviceUUID: JIGUANGID);
      Future<RefreshTokenResponse> refreshTokenResponse = NetWorkWithoutToken(
          context).refreshToken(refreshTokenRequest);
      refreshTokenResponse.then((refreshTokenResponse) {
        if(refreshTokenResponse.success!=null&&refreshTokenResponse.success==true&&refreshTokenResponse.accessToken!=null&&refreshTokenResponse.accessToken!.isNotEmpty){
          print("刷新token成功，用新token重新发送请求");
          LoginPrefs.setAccessToken(refreshTokenResponse.accessToken!);
          // _retry(err,handler);
        }else{
          //直接跳登录
          //BuildContext? context= navigatorKey.currentState?.overlay?.context;
          print("刷新token也失败了");
          LogoutThisDeviceRequestEntity logoutThisDeviceRequestEntity=LogoutThisDeviceRequestEntity();
          logoutThisDeviceRequestEntity.userId=userId!;
          logoutThisDeviceRequestEntity.loginType=LOGIN_TYPE;
          logoutThisDeviceRequestEntity.clientId=CLIENT_ID;
          logoutThisDeviceRequestEntity.deviceUUID=JIGUANGID;
          Future<BaseBean> baseBean=NetWorkWithoutToken(context).logoutThisDevice(logoutThisDeviceRequestEntity);
          baseBean.then((value) {
            print(value.success);
            LoginPrefs.logout();
            Navigator.of(context).pushNamedAndRemoveUntil(
                "login", ModalRoute.withName("login"));
          });

        }
        handler.next(err);

      });

      // queue.add(_getTokenData(err,handler).then((value) => null));
      handler.next(err);

    }

    // super.onError(err, handler);
  }

  /// 重发请求
  Future<Response<dynamic>> _retry(DioError err,ErrorInterceptorHandler handler) {
    RequestOptions options = err.requestOptions;
    // options.headers[HttpHeaders.authorizationHeader] = 'Bearer '+LoginPrefs.getAccessToken()!;
    //_dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer '+LoginPrefs.getAccessToken()!;
    options.headers[HttpHeaders.authorizationHeader]= 'Bearer '+LoginPrefs.getAccessToken()!;
    if('GET'==options.method){//如果是get请求那就使用get 其它用post请求
      return _dio.get(options.path, data: options.data,queryParameters: options.queryParameters);
    }
    return _dio.post(options.path, data: options.data,queryParameters: options.queryParameters);

  }
  
}