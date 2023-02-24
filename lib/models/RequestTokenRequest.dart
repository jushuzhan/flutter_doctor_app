class RequestTokenRequest{
  String? clientId;
  String? unionId;
  String? jiguangId;
  String? phone;
  String? password;
  String? userId;
  String? deviceUUID;
  int? loginType;
  int? userRole;
  RequestTokenRequest({required this.clientId, required this.jiguangId, required this.phone, required this.password, required this.deviceUUID, required this.loginType,required this.userRole});
  RequestTokenRequest.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    unionId = json['unionId'];
    jiguangId = json['jiguangId'];
    phone = json['phone'];
    password = json['password'];
    userId = json['userId'];
    deviceUUID = json['deviceUUID'];
    loginType = json['loginType'];
    userRole = json['userRole'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientId'] = this.clientId;
    data['unionId'] = this.unionId;
    data['jiguangId'] = this.jiguangId;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['userId'] = this.userId;
    data['deviceUUID'] = this.deviceUUID;
    data['loginType'] = this.loginType;
    data['userRole'] = this.userRole;
    return data;
  }
}