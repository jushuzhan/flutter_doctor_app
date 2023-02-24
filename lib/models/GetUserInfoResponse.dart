class GetUserInfoResponse {
  String? openid;
  String? nickname;
  int? sex;
  String? unionid;
  String? externalGetUserInfoSucceed;
  String? externalGetUserInfoMsg;
  String?  userId;
  bool phoneBinded=false;
  bool setPassword=false;

  GetUserInfoResponse();


  GetUserInfoResponse.fromJson(Map<String, dynamic> json) {
    openid = json['openid'];
    nickname = json['nickname'];
    sex = json['sex'];
    unionid = json['unionid'];
    externalGetUserInfoSucceed = json['externalGetUserInfoSucceed'];
    externalGetUserInfoMsg = json['externalGetUserInfoMsg'];
    userId = json['userId'];
    phoneBinded = json['phoneBinded'];
    setPassword = json['setPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['openid'] = this.openid;
    data['nickname'] = this.nickname;
    data['sex'] = this.sex;
    data['unionid'] = this.unionid;
    data['externalGetUserInfoSucceed'] = this.externalGetUserInfoSucceed;
    data['externalGetUserInfoMsg'] = this.externalGetUserInfoMsg;
    data['userId'] = this.userId;
    data['phoneBinded'] = this.phoneBinded;
    data['setPassword'] = this.setPassword;
    return data;
  }
}