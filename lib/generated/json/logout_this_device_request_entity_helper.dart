import 'package:flutter_doctor_app/models/logout_this_device_request_entity.dart';

logoutThisDeviceRequestEntityFromJson(LogoutThisDeviceRequestEntity data, Map<String, dynamic> json) {
	if (json['clientId'] != null) {
		data.clientId = json['clientId'].toString();
	}
	if (json['userId'] != null) {
		data.userId = json['userId'].toString();
	}
	if (json['loginType'] != null) {
		data.loginType = json['loginType'] is String
				? int.tryParse(json['loginType'])
				: json['loginType'].toInt();
	}
	if (json['deviceUUID'] != null) {
		data.deviceUUID = json['deviceUUID'].toString();
	}
	return data;
}

Map<String, dynamic> logoutThisDeviceRequestEntityToJson(LogoutThisDeviceRequestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['clientId'] = entity.clientId;
	data['userId'] = entity.userId;
	data['loginType'] = entity.loginType;
	data['deviceUUID'] = entity.deviceUUID;
	return data;
}