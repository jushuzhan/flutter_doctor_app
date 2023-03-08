import 'package:flutter_doctor_app/models/bind_phone_response_entity.dart';

bindPhoneResponseEntityFromJson(BindPhoneResponseEntity data, Map<String, dynamic> json) {
	if (json['successed'] != null) {
		data.successed = json['successed'];
	}
	if (json['msg'] != null) {
		data.msg = json['msg'].toString();
	}
	if (json['setPassword'] != null) {
		data.setPassword = json['setPassword'];
	}
	if (json['userId'] != null) {
		data.userId = json['userId'] is String
				? int.tryParse(json['userId'])
				: json['userId'].toInt();
	}
	return data;
}

Map<String, dynamic> bindPhoneResponseEntityToJson(BindPhoneResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['successed'] = entity.successed;
	data['msg'] = entity.msg;
	data['setPassword'] = entity.setPassword;
	data['userId'] = entity.userId;
	return data;
}