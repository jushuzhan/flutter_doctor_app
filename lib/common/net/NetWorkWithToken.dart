import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';
import 'package:flutter_doctor_app/common/constants/constants.dart';

import '../../generated/json/get_paged_exam_visit_for_doctor_input_entity_helper.dart';
import '../../generated/json/get_paged_order_response_entity_helper.dart';
import '../../generated/json/paged_result_dto_response_entity_helper.dart';
import '../../generated/json/update_exam_visit_status_input_request_entity_helper.dart';
import '../../generated/json/update_exam_visit_status_input_response_entity_entity_helper.dart';
import '../../models/BaseBean.dart';
import '../../models/get_paged_exam_visit_for_doctor_input_entity.dart';
import '../../models/get_paged_order_response_entity.dart';
import '../../models/paged_result_dto_response_entity.dart';
import '../../models/update_exam_visit_status_input_request_entity.dart';
import '../../models/update_exam_visit_status_input_response_entity_entity.dart';
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
  Future<UpdateExamVisitStatusInputResponseEntityEntity> updateExamVisitStatus(UpdateExamVisitStatusInputRequestEntity updateExamVisitStatusInputRequestEntity) async{
    var r=await dio.post(UPDATE_EXAMVISIT_STATUS,data:updateExamVisitStatusInputRequestEntityToJson(updateExamVisitStatusInputRequestEntity));
    print(r.data);
    return updateExamVisitStatusInputResponseEntityEntityFromJson(UpdateExamVisitStatusInputResponseEntityEntity() ,BaseBean(r.data).result);
  }

}