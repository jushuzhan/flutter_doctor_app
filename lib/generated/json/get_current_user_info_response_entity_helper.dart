import 'package:flutter_doctor_app/models/get_current_user_info_response_entity.dart';

getCurrentUserInfoResponseEntityFromJson(GetCurrentUserInfoResponseEntity data, Map<String, dynamic> json) {
	if (json['nickName'] != null) {
		data.nickName = json['nickName'].toString();
	}
	if (json['phoneNumber'] != null) {
		data.phoneNumber = json['phoneNumber'].toString();
	}
	if (json['bindWechat'] != null) {
		data.bindWechat = json['bindWechat'];
	}
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	return data;
}

Map<String, dynamic> getCurrentUserInfoResponseEntityToJson(GetCurrentUserInfoResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['nickName'] = entity.nickName;
	data['phoneNumber'] = entity.phoneNumber;
	data['bindWechat'] = entity.bindWechat;
	data['id'] = entity.id;
	return data;
}