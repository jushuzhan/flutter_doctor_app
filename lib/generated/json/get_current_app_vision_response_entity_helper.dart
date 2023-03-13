import 'package:flutter_doctor_app/models/get_current_app_vision_response_entity.dart';

getCurrentAppVisionResponseEntityFromJson(GetCurrentAppVisionResponseEntity data, Map<String, dynamic> json) {
	if (json['appType'] != null) {
		data.appType = json['appType'] is String
				? int.tryParse(json['appType'])
				: json['appType'].toInt();
	}
	if (json['appPlatform'] != null) {
		data.appPlatform = json['appPlatform'] is String
				? int.tryParse(json['appPlatform'])
				: json['appPlatform'].toInt();
	}
	if (json['vision'] != null) {
		data.vision = json['vision'] is String
				? int.tryParse(json['vision'])
				: json['vision'].toInt();
	}
	if (json['build'] != null) {
		data.build = json['build'] is String
				? int.tryParse(json['build'])
				: json['build'].toInt();
	}
	if (json['displayVision'] != null) {
		data.displayVision = json['displayVision'].toString();
	}
	if (json['apkMd5'] != null) {
		data.apkMd5 = json['apkMd5'].toString();
	}
	if (json['downLoadUrl'] != null) {
		data.downLoadUrl = json['downLoadUrl'].toString();
	}
	if (json['description'] != null) {
		data.description = json['description'].toString();
	}
	return data;
}

Map<String, dynamic> getCurrentAppVisionResponseEntityToJson(GetCurrentAppVisionResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['appType'] = entity.appType;
	data['appPlatform'] = entity.appPlatform;
	data['vision'] = entity.vision;
	data['build'] = entity.build;
	data['displayVision'] = entity.displayVision;
	data['apkMd5'] = entity.apkMd5;
	data['downLoadUrl'] = entity.downLoadUrl;
	data['description'] = entity.description;
	return data;
}