class GetUserInfoRequest{
  String? code;
  int? userRole;
  int? loginType;
  GetUserInfoRequest({
    required this.code,
    required this.userRole,
    required this.loginType
});

  GetUserInfoRequest.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    userRole = json['userRole'];
    loginType = json['loginType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['userRole'] = this.userRole;
    data['loginType'] = this.loginType;
    return data;
  }
}