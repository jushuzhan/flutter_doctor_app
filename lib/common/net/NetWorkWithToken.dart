import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';
import 'package:flutter_doctor_app/common/constants/constants.dart';

import '../../generated/json/doctor_extend_by_doctor_id_response_entity_helper.dart';
import '../../generated/json/get_paged_exam_visit_for_doctor_input_entity_helper.dart';
import '../../generated/json/get_paged_order_response_entity_helper.dart';
import '../../generated/json/make_conclusion_input_request_entity_helper.dart';
import '../../generated/json/paged_result_dto_response_entity_helper.dart';
import '../../generated/json/update_exam_visit_status_input_request_entity_helper.dart';
import '../../generated/json/common_input_response_entity_helper.dart';
import '../../models/BaseBean.dart';
import '../../models/create_or_update_doctor_extend_input_request_entity.dart';
import '../../models/doctor_extend_by_doctor_id_response_entity.dart';
import '../../models/get_current_user_info_response_entity.dart';
import '../../models/get_paged_exam_visit_for_doctor_input_entity.dart';
import '../../models/get_paged_order_response_entity.dart';
import '../../models/get_user_info_for_edit_response_entity.dart';
import '../../models/make_conclusion_input_request_entity.dart';
import '../../models/paged_result_dto_response_entity.dart';
import '../../models/sts_upload_response_request_entity.dart';
import '../../models/sts_upload_response_response_entity.dart';
import '../../models/update_exam_visit_status_input_request_entity.dart';
import '../../models/common_input_response_entity.dart';
import '../../models/update_user_info_response_entity.dart';
import '../../models/update_user_password_request_entity.dart';
import '../../models/update_user_phone_request_entity.dart';
import '../../models/user_info_settings_get_by_user_id_request_entity.dart';
import '../../models/user_info_settings_get_by_user_id_response_entity.dart';
import '../../models/user_info_settings_set_by_user_id_request_entity.dart';
import 'interceptor/TokenInterceptor.dart';
export 'package:dio/dio.dart' show DioError;

class NetWorkWithToken {
  // 在网络请求过程中可能会需要使用当前的context信息，比如在请求失败时
  // 打开一个新路由，而打开新路由需要context信息。
  NetWorkWithToken([this.context]) {
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

  static void init() async{
    // 添加缓存插件
     dio.interceptors.add(TokenInterceptor(dio,));
    // 设置用户token（可能为null，代表未登录）
    String? token=await LoginPrefs(dio.options.extra['context']).getToken();
    print('token init :$token');
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer '+token!;

  }

  // // 登录接口，登录成功后返回用户信息
  // Future<User> login(String login, String pwd) async {
  //   String basic = 'Basic ' + base64.encode(utf8.encode('$login:$pwd'));
  //   var r = await dio.get(
  //     "/user",
  //     options: _options.copyWith(headers: {
  //       HttpHeaders.authorizationHeader: basic
  //     }, extra: {
  //       "noCache": true, //本接口禁用缓存
  //     }),
  //   );
  //   //登录成功后更新公共头（authorization），此后的所有请求都会带上用户身份信息
  //   dio.options.headers[HttpHeaders.authorizationHeader] = basic;
  //   //清空所有缓存
  //   Global.netCache.cache.clear();
  //   //更新profile中的token信息
  //   Global.profile.token = basic;
  //   return User.fromJson(r.data);
  // }

  // //获取用户项目列表
  // Future<List<Repo>> getRepos({
  //   Map<String, dynamic>? queryParameters, //query参数，用于接收分页信息
  //   refresh = false,
  // }) async {
  //   var r = await dio.get<List>(
  //     "user/repos",
  //     queryParameters: queryParameters,
  //     options: _options,
  //   );
  //   return r.data!.map((e) => Repo.fromJson(e)).toList();
  // }
  //获取订单列表
Future <GetPagedOrderResponseEntity> getPagedOrdersByCurrentDoctor({
  Map<String, dynamic>? queryParameters, //query参数，用于接收分页信息
  refresh = false,
}) async{
     var r=await dio.get(GETPAGED_ORDERS_BY_CURRENT_DOCTOR,queryParameters: queryParameters,options: _options);
     print(r.data['result'].toString());
     return getPagedOrderResponseEntityFromJson(GetPagedOrderResponseEntity(),BaseBean(r.data).result);
}
//专家端获取自己各种状态下的咨询记录
Future<PagedResultDtoResponseEntity> getPagedExamVisitForDoctor(GetPagedExamVisitForDoctorInputEntity visitForDoctorInputEntity) async{
    var r=await dio.post(GET_PAGE_EXAM_VISIT_FOR_DOCTOR,data:getPagedExamVisitForDoctorInputEntityToJson(visitForDoctorInputEntity));
    print(r.data);
    return pagedResultDtoResponseEntityFromJson(PagedResultDtoResponseEntity() ,BaseBean(r.data).result);
}
//专家修改咨询记录的状态
  Future<CommonInputResponseEntity> updateExamVisitStatus(UpdateExamVisitStatusInputRequestEntity updateExamVisitStatusInputRequestEntity) async{
    var r=await dio.post(UPDATE_EXAMVISIT_STATUS,data:updateExamVisitStatusInputRequestEntityToJson(updateExamVisitStatusInputRequestEntity));
    print(r.data);
    return commonInputResponseEntityFromJson(CommonInputResponseEntity() ,BaseBean(r.data).result);
  }
//专家下结论
  Future<CommonInputResponseEntity> makeConclusion(MakeConclusionInputRequestEntity makeConclusionInputRequestEntity) async{
    // var r=await dio.post(MAKE_CONCLUSION,data:makeConclusionInputRequestEntityToJson(makeConclusionInputRequestEntity));
    var r=await dio.post(MAKE_CONCLUSION,data:makeConclusionInputRequestEntity.toJson());
    print(r.data);
    return commonInputResponseEntityFromJson(CommonInputResponseEntity() ,BaseBean(r.data).result);
  }
  //获取医生扩展信息
  Future<DoctorExtendByDoctorIdResponseEntity> getDoctorExtendByDoctorId(String? userId) async{
    var r=await dio.get(DOCTOR_EXTEND_GET_DOCTOR_EXTEND_BY_DOCTORID,queryParameters: {'input':userId});
    print('获取医生扩展信息');
    print(r.data);
    return doctorExtendByDoctorIdResponseEntityFromJson(DoctorExtendByDoctorIdResponseEntity() ,BaseBean(r.data).result);
  }

  //登陆后获取自身设置
  Future<UserInfoSettingsGetByUserIdResponseEntity> userInfoSettingsGetByUserId(UserInfoSettingsGetByUserIdRequestEntity userIdRequestEntity) async{
    var r=await dio.post(USERINFO_SETTINGS_GET_BY_USERID,data:userIdRequestEntity.toJson());
    print(r.data);
   return UserInfoSettingsGetByUserIdResponseEntity().fromJson(BaseBean(r.data).result);
  }

  //登陆后设置自身设置
  Future<CommonInputResponseEntity> userInfoSettingsSetByUserId(UserInfoSettingsSetByUserIdRequestEntity userIdRequestEntity) async{
    var r=await dio.post(USERINFO_SETTINGS_SET_BY_USERID,data:userIdRequestEntity.toJson());
    print(r.data);
    return CommonInputResponseEntity().fromJson(BaseBean(r.data).result);
  }
  //用户自己修改密码
  Future<CommonInputResponseEntity> updateUserPassword(UpdateUserPasswordRequestEntity updateUserPasswordRequestEntity) async{
    var r=await dio.post(UPDATE_USER_PASSWORD,data:updateUserPasswordRequestEntity.toJson());
    print(r.data);
    return CommonInputResponseEntity().fromJson(BaseBean(r.data).result);
  }
  //获取当前医生信息
  Future <GetCurrentUserInfoResponseEntity> getCurrentDoctorInfo() async{
    var r=await dio.get(GET_CURRENT_DOCTOR_INFO);
    print(r.data);
    return GetCurrentUserInfoResponseEntity().fromJson(BaseBean(r.data).result);
  }

  //重新绑定手机号码
  Future<CommonInputResponseEntity> updateUserPhone(UpdateUserPhoneRequestEntity updateUserPhoneRequestEntity) async{
    var r=await dio.post(UPDATE_USER_PHONE,data:updateUserPhoneRequestEntity.toJson());
    print(r.data);
    return CommonInputResponseEntity().fromJson(BaseBean(r.data).result);
  }

  //获取编辑用户信息
  Future<GetUserInfoForEditResponseEntity> getUserInfoForEdit() async{
    var r=await dio.get(GET_USER_INFO_FOR_EDIT);
    print(r.data);
    return GetUserInfoForEditResponseEntity().fromJson(BaseBean(r.data).result);
  }

  //获取Oss上传需要的Sts
  Future<StsUploadResponseResponseEntity> stsUploadResponse(StsUploadResponseRequestEntity stsUploadResponseRequestEntity) async{
    var r=await dio.post(STS_UPLOAD_RESPONSE,data:stsUploadResponseRequestEntity.toJson());
    print(r.data);
    return StsUploadResponseResponseEntity().fromJson(BaseBean(r.data).result);
  }
  //编辑用户信息
  Future<UpdateUserInfoResponseEntity> updateUserInfo(CreateOrUpdateDoctorExtendInputRequestEntity createOrUpdateDoctorExtendInputRequestEntity) async{
    print('上传的json数据:${createOrUpdateDoctorExtendInputRequestEntity.toJson()}');
    var r=await dio.post(UPDATE_USER_INFO,data:createOrUpdateDoctorExtendInputRequestEntity.toJson());
    print(r.data);
    return UpdateUserInfoResponseEntity().fromJson(BaseBean(r.data).result);
  }
}