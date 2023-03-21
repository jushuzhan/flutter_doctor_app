import 'package:flutter_doctor_app/models/get_huanxin_id_output_response_entity.dart';

getHuanxinIdOutputResponseEntityFromJson(GetHuanxinIdOutputResponseEntity data, Map<String, dynamic> json) {
	if (json['userHuanxinId'] != null) {
		data.userHuanxinId = json['userHuanxinId'].toString();
	}
	if (json['doctorHuanxinId'] != null) {
		data.doctorHuanxinId = json['doctorHuanxinId'].toString();
	}
	if (json['successed'] != null) {
		data.successed = json['successed'];
	}
	if (json['msg'] != null) {
		data.msg = json['msg'].toString();
	}
	return data;
}

Map<String, dynamic> getHuanxinIdOutputResponseEntityToJson(GetHuanxinIdOutputResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['userHuanxinId'] = entity.userHuanxinId;
	data['doctorHuanxinId'] = entity.doctorHuanxinId;
	data['successed'] = entity.successed;
	data['msg'] = entity.msg;
	return data;
}