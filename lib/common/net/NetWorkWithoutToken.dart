import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/src/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_doctor_app/common/constants/constants.dart';
import 'package:flutter_doctor_app/models/GetEnum.dart';

import 'interceptor/TokenInterceptor.dart';
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
    headers: {
      HttpHeaders.acceptHeader: "*",
    },
  ));

  static void init() {
     dio.interceptors.add(TokenInterceptor());
    dio.options.contentType="application/json; charset=utf-8";

  }

  // 获取枚举接口
  Future<GetEnum> getEnum() async {
    var r = await dio.get(
      "api/Common/GetEnum",
    );
    return GetEnum.fromJson(r.data);
  }

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
}