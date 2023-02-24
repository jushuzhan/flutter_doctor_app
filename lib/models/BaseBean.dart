
class BaseBean<T>{
  T? result;
  String? targetUrl;
  bool? success;
  String? error;
  bool? unAuthorizedRequest;
  bool? bAbp;
  BaseBean(Map<String, dynamic> json):
        targetUrl = json['targetUrl'],
        success = json['success'],
        error = json['error'],
        unAuthorizedRequest = json['unAuthorizedRequest'],
        bAbp = json['__abp'],
        result=json['result'];
}