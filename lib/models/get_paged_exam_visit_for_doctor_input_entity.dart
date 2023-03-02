import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class GetPagedExamVisitForDoctorInputEntity with JsonConvert<GetPagedExamVisitForDoctorInputEntity> {
	int? examVisitStatus;
	late int maxResultCount;
	late int skipCount;
}
