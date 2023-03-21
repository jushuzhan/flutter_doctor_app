import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class PatientCustomerGetByIdResponseEntity with JsonConvert<PatientCustomerGetByIdResponseEntity> {
	String? name;
	String? birthdate;
	int? gender;
	String? genderRemark;
	int? userId;
	String? showCardId;
	String? phone;
	int? id;
}
