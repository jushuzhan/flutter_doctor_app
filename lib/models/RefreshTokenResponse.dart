class RefreshTokenResponse{
  String? accessToken;
  int? expiresIn;
  String?  tokenType;
  String? userId;
  bool? success;
  String? msg;
  RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    expiresIn = json['expiresIn'];
    tokenType = json['tokenType'];
    userId = json['userId'];
    success = json['success'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['expiresIn'] = this.expiresIn;
    data['tokenType'] = this.tokenType;
    data['userId'] = this.userId;
    data['success'] = this.success;
    data['msg'] = this.msg;
    return data;
  }
}