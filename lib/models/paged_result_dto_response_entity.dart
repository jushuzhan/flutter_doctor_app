import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class PagedResultDtoResponseEntity with JsonConvert<PagedResultDtoResponseEntity> {
	int? totalCount;
	List<PagedResultDtoResponseItems>? items;
}

class PagedResultDtoResponseItems with JsonConvert<PagedResultDtoResponseItems> {
	int? doctorId;
	String? doctorName;
	int? userId;
	int? patientId;
	String? patientName;
	String? question;
	int? examRecordId;
	int? diagnoseId;
	int? recommendUserId;
	String? recommendUserName;
	int? tenantId;
	String? tenantName;
	int? receivablePrice;
	int? actualPrice;
	int? examVisitType;
	String? examVisitTypeRemark;
	int? examVisitStatus;
	String? examVisitStatusRemark;
	String? orderNumber;
	String? conclusion;
	String? creationTime;
	String? lastModificationTime;
	String? deletionTime;
	bool? isDeleted;
	int? id;
	bool isExpanded=false;
}
