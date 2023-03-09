import 'package:flutter_doctor_app/models/sts_upload_response_response_entity.dart';

stsUploadResponseResponseEntityFromJson(StsUploadResponseResponseEntity data, Map<String, dynamic> json) {
	if (json['accessKeyId'] != null) {
		data.accessKeyId = json['accessKeyId'].toString();
	}
	if (json['accessKeySecret'] != null) {
		data.accessKeySecret = json['accessKeySecret'].toString();
	}
	if (json['securityToken'] != null) {
		data.securityToken = json['securityToken'].toString();
	}
	if (json['bucket'] != null) {
		data.bucket = json['bucket'].toString();
	}
	if (json['endPoint'] != null) {
		data.endPoint = json['endPoint'].toString();
	}
	if (json['ossFileFullName'] != null) {
		data.ossFileFullName = json['ossFileFullName'].toString();
	}
	return data;
}

Map<String, dynamic> stsUploadResponseResponseEntityToJson(StsUploadResponseResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['accessKeyId'] = entity.accessKeyId;
	data['accessKeySecret'] = entity.accessKeySecret;
	data['securityToken'] = entity.securityToken;
	data['bucket'] = entity.bucket;
	data['endPoint'] = entity.endPoint;
	data['ossFileFullName'] = entity.ossFileFullName;
	return data;
}