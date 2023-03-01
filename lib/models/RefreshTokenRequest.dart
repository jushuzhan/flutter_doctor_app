class RefreshTokenRequest{
  String? clientId;
  String? userId;
  String? deviceUUID;
  RefreshTokenRequest({required this.clientId, required this.userId, required this.deviceUUID});
  RefreshTokenRequest.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    userId = json['userId'];
    deviceUUID = json['deviceUUID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientId'] = this.clientId;
    data['userId'] = this.userId;
    data['deviceUUID'] = this.deviceUUID;
    return data;
  }
}