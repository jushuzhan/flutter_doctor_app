import 'package:flutter_doctor_app/models/user_info_register_request_entity.dart';

userInfoRegisterRequestEntityFromJson(UserInfoRegisterRequestEntity data, Map<String, dynamic> json) {
	if (json['nickName'] != null) {
		data.nickName = json['nickName'].toString();
	}
	if (json['phone'] != null) {
		data.phone = json['phone'].toString();
	}
	if (json['authCode'] != null) {
		data.authCode = json['authCode'].toString();
	}
	if (json['password'] != null) {
		data.password = json['password'].toString();
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

Map<String, dynamic> userInfoRegisterRequestEntityToJson(UserInfoRegisterRequestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['nickName'] = entity.nickName;
	data['phone'] = entity.phone;
	data['authCode'] = entity.authCode;
	data['password'] = entity.password;
	data['loginType'] = entity.loginType;
	data['userRole'] = entity.userRole;
	return data;
}