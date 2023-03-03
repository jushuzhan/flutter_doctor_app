import 'package:flutter_doctor_app/models/common_input_response_entity.dart';

commonInputResponseEntityFromJson(CommonInputResponseEntity data, Map<String, dynamic> json) {
	if (json['successed'] != null) {
		data.successed = json['successed'];
	}
	if (json['msg'] != null) {
		data.msg = json['msg'].toString();
	}
	return data;
}

Map<String, dynamic> commonInputResponseEntityToJson(CommonInputResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['successed'] = entity.successed;
	data['msg'] = entity.msg;
	return data;
}