class RequestTokenResponse{
  String? accessToken;
  int? expiresIn;
  String?  tokenType;
  String? userId;
  bool? setPassword;
  bool? success;
  String? msg;
  RequestTokenResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    expiresIn = json['expiresIn'];
    tokenType = json['tokenType'];
    userId = json['userId'];
    setPassword = json['setPassword'];
    success = json['success'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['expiresIn'] = this.expiresIn;
    data['tokenType'] = this.tokenType;
    data['userId'] = this.userId;
    data['setPassword'] = this.setPassword;
    data['success'] = this.success;
    data['msg'] = this.msg;
    return data;
  }
}