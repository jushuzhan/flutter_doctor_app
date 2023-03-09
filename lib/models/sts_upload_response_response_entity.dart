import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class StsUploadResponseResponseEntity with JsonConvert<StsUploadResponseResponseEntity> {
	late String accessKeyId;
	late String accessKeySecret;
	late String securityToken;
	late String bucket;
	late String endPoint;
	late String ossFileFullName;
}
