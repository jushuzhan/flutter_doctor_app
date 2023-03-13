import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class GetCurrentAppVisionResponseEntity with JsonConvert<GetCurrentAppVisionResponseEntity> {
	int? appType;
	int? appPlatform;
	int? vision;
	int? build;
	String? displayVision;
	String? apkMd5;
	String? downLoadUrl;
	String? description;
}
