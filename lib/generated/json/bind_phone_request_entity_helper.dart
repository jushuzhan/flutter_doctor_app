import 'package:flutter_doctor_app/models/bind_phone_request_entity.dart';

bindPhoneRequestEntityFromJson(BindPhoneRequestEntity data, Map<String, dynamic> json) {
	if (json['unionId'] != null) {
		data.unionId = json['unionId'].toString();
	}
	if (json['openid'] != null) {
		data.openid = json['openid'].toString();
	}
	if (json['nickname'] != null) {
		data.nickname = json['nickname'].toString();
	}
	if (json['sex'] != null) {
		data.sex = json['sex'] is String
				? int.tryParse(json['sex'])
				: json['sex'].toInt();
	}
	if (json['phone'] != null) {
		data.phone = json['phone'].toString();
	}
	if (json['authCode'] != null) {
		data.authCode = json['authCode'].toString();
	}
	if (json['loginType'] != null) {
		data.loginType = json['loginType'] is String
				? int.tryParse(json['loginType'])
				: json['loginType'].toInt();
	}
	if (json['userRole'] != null) {
		data.userRole = json['userRole'] is String
				? int.tryParse(json['userRole'])
				: json['userRole'].toInt();
	}
	return data;
}

Map<String, dynamic> bindPhoneRequestEntityToJson(BindPhoneRequestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['unionId'] = entity.unionId;
	data['openid'] = entity.openid;
	data['nickname'] = entity.nickname;
	data['sex'] = entity.sex;
	data['phone'] = entity.phone;
	data['authCode'] = entity.authCode;
	data['loginType'] = entity.loginType;
	data['userRole'] = entity.userRole;
	return data;
}