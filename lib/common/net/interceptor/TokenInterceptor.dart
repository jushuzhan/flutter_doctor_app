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
import 'package:fluttertoast/fluttertoast.dart';

class TokenInterceptor extends QueuedInterceptor{
  late Dio _dio;
  bool isReLogin = false;
  Queue queue = new Queue();
  TokenInterceptor(this._dio);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    // TODO: implement onRequest
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    // 设置用户token（可能为null，代表未登录）
    String? token=await LoginPrefs(_dio.options.extra['context']).getToken();//options中包含context
    print('token init :$token');
    if(token!=null&&token.isNotEmpty){
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer '+token!;
    }
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
    //BuildContext context= err.requestOptions.extra['context'];
    BuildContext context=navigatorKey.currentState!.context;
    if(err.response!.statusCode==401){
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

      RefreshTokenRequest refreshTokenRequest=RefreshTokenRequest(clientId: CLIENT_ID, userId: userId, deviceUUID: JIGUANGID);
      Future<RefreshTokenResponse> refreshTokenResponse = NetWorkWithoutToken(
          context).refreshToken(refreshTokenRequest);
      refreshTokenResponse.then((value) {
        if(value.success!=null&&value.success==true&&value.accessToken!=null&&value.accessToken!.isNotEmpty){
          print("Interceptor:刷新token成功，用新token重新发送请求");
          print('Interceptor:${value.accessToken!}');
          LoginPrefs(context).setAccessToken(value.accessToken!);
          // Response<dynamic> response=await _retry(err.requestOptions);
          // // if(err.response?.statusCode!=200){
          // //   handler.reject(err);
          // // }
          err.requestOptions.headers[HttpHeaders.authorizationHeader] = 'Bearer '+value.accessToken!;

        }else{
          //直接跳登录
          print("Interceptor:刷新token也失败了");
          LogoutThisDeviceRequestEntity logoutThisDeviceRequestEntity=LogoutThisDeviceRequestEntity();
          logoutThisDeviceRequestEntity.userId=userId!;
          logoutThisDeviceRequestEntity.loginType=LOGIN_TYPE;
          logoutThisDeviceRequestEntity.clientId=CLIENT_ID;
          logoutThisDeviceRequestEntity.deviceUUID=JIGUANGID;
          Future<BaseBean> baseBean=NetWorkWithoutToken(context).logoutThisDevice(logoutThisDeviceRequestEntity);
          baseBean.then((value) {
            handler.reject(err);
            print('Interceptor:退出设备${value.success}');
            LoginPrefs(context).logout();
            Navigator.of(context).pushNamedAndRemoveUntil(
                "login", ModalRoute.withName("login"));

          });

        }
      }).then((value) {
        //再发送请求
        _dio.fetch(err.requestOptions).then((response) => handler.resolve(response),
        onError: (e){
          handler.reject(e);
        }
        );
      });
      return handler.next(err);

    }else if(err.response!=null&&err.response!.statusCode==456){
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
    }else if(err.response!=null&&err.response!.statusCode==500){
      Fluttertoast.showToast(msg: "服务器错误");
    return handler.next(err);
    }else{
      return handler.next(err);
    }
  }

  // /// 重发请求
  // Future<Response<dynamic>> _retry(DioError err,ErrorInterceptorHandler handler,String accessToken) {
  //   RequestOptions options = err.requestOptions;
  //   options.headers[HttpHeaders.authorizationHeader]= 'Bearer '+accessToken!;
  //   if('GET'==options.method){//如果是get请求那就使用get 其它用post请求
  //     return _dio.get(options.path, data: options.data,queryParameters: options.queryParameters);
  //   }
  //   return _dio.post(options.path, data: options.data,queryParameters: options.queryParameters);
  // }

  /// For retrying request with new token
  ///
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }
}