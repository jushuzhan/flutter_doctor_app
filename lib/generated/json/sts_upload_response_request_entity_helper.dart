import 'package:flutter_doctor_app/models/sts_upload_response_request_entity.dart';

stsUploadResponseRequestEntityFromJson(StsUploadResponseRequestEntity data, Map<String, dynamic> json) {
	if (json['fileName'] != null) {
		data.fileName = json['fileName'].toString();
	}
	if (json['fileType'] != null) {
		data.fileType = json['fileType'] is String
				? int.tryParse(json['fileType'])
				: json['fileType'].toInt();
	}
	return data;
}

Map<String, dynamic> stsUploadResponseRequestEntityToJson(StsUploadResponseRequestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['fileName'] = entity.fileName;
	data['fileType'] = entity.fileType;
	return data;
}