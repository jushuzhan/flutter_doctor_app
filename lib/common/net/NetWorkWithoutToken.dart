import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/src/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_doctor_app/common/constants/constants.dart';
import 'package:flutter_doctor_app/models/BaseBean.dart';
import 'package:flutter_doctor_app/models/GetEnum.dart';
import 'package:flutter_doctor_app/models/GetUserInfoResponse.dart';

import '../../generated/json/logout_this_device_request_entity_helper.dart';
import '../../models/GetUserInfoRequest.dart';
import '../../models/RefreshTokenRequest.dart';
import '../../models/RefreshTokenResponse.dart';
import '../../models/RequestTokenRequest.dart';
import '../../models/RequestTokenResponse.dart';
import '../../models/bind_phone_request_entity.dart';
import '../../models/bind_phone_response_entity.dart';
import '../../models/common_input_response_entity.dart';
import '../../models/create_auth_code_request_entity.dart';
import '../../models/get_current_app_vision_response_entity.dart';
import '../../models/logout_this_device_request_entity.dart';
import '../../models/reset_user_password_request_entity.dart';
import '../../models/set_password_input_request_entity.dart';
import '../../models/user_info_register_request_entity.dart';
export 'package:dio/dio.dart' show DioError;

class NetWorkWithoutToken {
  // 在网络请求过程中可能会需要使用当前的context信息，比如在请求失败时
  // 打开一个新路由，而打开新路由需要context信息。
  NetWorkWithoutToken([this.context]) {
    _options = Options(extra: {"context": context});
  }

  BuildContext? context;
  late Options _options;
  static Dio dio = new Dio(BaseOptions(
    baseUrl: baseUrl,
    contentType: 'application/json',
    headers: {
      HttpHeaders.acceptHeader: "*",
    },
  ));

  static void init() {
    dio.options.contentType="application/json; charset=utf-8";

  }

  // 获取枚举接口
  Future<GetEnum> getEnum() async {
    var r = await dio.get(
      GET_ENUM,
    );
    return GetEnum.fromJson(r.data);
  }
  //微信登录接口
Future<GetUserInfoResponse> wechatLogin(GetUserInfoRequest getUserInfoRequest )async{
    var r=await dio.post(GET_USER_INFO,data:getUserInfoRequest.toJson());
    GetUserInfoResponse  response=GetUserInfoResponse.fromJson(BaseBean(r.data).result);
    return response;
}
//请求token接口
  Future<RequestTokenResponse> requestToken(RequestTokenRequest requestTokenRequest)async{
    var r=await dio.post(REQUEST_TOKEN,data:requestTokenRequest.toJson());
    RequestTokenResponse response=RequestTokenResponse.fromJson(BaseBean(r.data).result);
    return response;
  }
//刷新token接口
  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest refreshTokenRequest)async{
    var r=await dio.post(REFRESH_TOKEN,data:refreshTokenRequest.toJson());
    RefreshTokenResponse response=RefreshTokenResponse.fromJson(BaseBean(r.data).result);
    return response;
  }
  //退出登录
Future<BaseBean> logoutThisDevice(LogoutThisDeviceRequestEntity logoutThisDeviceRequestEntity) async{
    var r= await  dio.post(LOGOUT_THIS_DEVICE,data:logoutThisDeviceRequestEntityToJson(logoutThisDeviceRequestEntity));
    BaseBean baseBean=BaseBean(r.data);
    return baseBean;
}
  //发送手机验证码
  Future<CommonInputResponseEntity> createAuthCode(CreateAuthCodeRequestEntity codeRequestEntity)async{
    var r=await dio.post(CREATE_AUTH_CODE,data:codeRequestEntity.toJson());
    return CommonInputResponseEntity().fromJson(BaseBean(r.data).result);
  }
  //用户重置密码
  Future<CommonInputResponseEntity> resetUserPassword(ResetUserPasswordRequestEntity resetUserPasswordRequestEntity)async{
    var r=await dio.post(RESET_USER_PASSWORD,data:resetUserPasswordRequestEntity.toJson());
    return CommonInputResponseEntity().fromJson(BaseBean(r.data).result);
  }

  //用户注册（手机号码，验证码）
  Future<CommonInputResponseEntity> userInfoRegister(UserInfoRegisterRequestEntity userInfoRegisterRequestEntity)async{
    var r=await dio.post(USER_INFO_REGISTER,data:userInfoRegisterRequestEntity.toJson());
    return CommonInputResponseEntity().fromJson(BaseBean(r.data).result);
  }

  //用户设置密码
  Future<CommonInputResponseEntity> setUserPassword(SetPasswordInputRequestEntity setPasswordInputRequestEntity)async{
    var r=await dio.post(SET_USER_PASSWORD,data:setPasswordInputRequestEntity.toJson());
    return CommonInputResponseEntity().fromJson(BaseBean(r.data).result);
  }
  //绑定手机号码(实现注册信息)
  Future<BindPhoneResponseEntity> userInfoBindPhone(BindPhoneRequestEntity bindPhoneRequestEntity)async{
    var r=await dio.post(BIND_PHONE,data:bindPhoneRequestEntity.toJson());
    return BindPhoneResponseEntity().fromJson(BaseBean(r.data).result);
  }

  Future<Response<dynamic>> downLoadFile(String urlPath,String savePath,ProgressCallback onReceiveProgress) async{
    var r=await dio.download(urlPath, savePath,onReceiveProgress:onReceiveProgress);
    return r;
  }
  Future<List<int>?> downLoadFileNotProgress(urlPath) async{
    final rs = await dio.get<List<int>>(
      urlPath,
      options: Options(responseType: ResponseType.bytes), // Set the response type to `bytes`.
    );
    if(rs.statusCode==200&&rs.data!=null){
      return rs.data!;
    }
    return null;

  }
  Future<GetCurrentAppVisionResponseEntity> getCurrentAppVision(int appType,int appPlatform) async{
    var r=await dio.get(GET_CURRENT_APP_VEERSION,queryParameters:{
    'AppType': appType,
    'AppPlatform': appPlatform
    });
    print(r.data);
    return GetCurrentAppVisionResponseEntity().fromJson(BaseBean(r.data).result);
  }
}