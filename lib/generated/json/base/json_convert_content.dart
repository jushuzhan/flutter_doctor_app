// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:flutter_doctor_app/models/user_info_settings_get_by_user_id_request_entity.dart';
import 'package:flutter_doctor_app/generated/json/user_info_settings_get_by_user_id_request_entity_helper.dart';
import 'package:flutter_doctor_app/models/common_input_response_entity.dart';
import 'package:flutter_doctor_app/generated/json/common_input_response_entity_helper.dart';
import 'package:flutter_doctor_app/models/user_info_settings_set_by_user_id_request_entity.dart';
import 'package:flutter_doctor_app/generated/json/user_info_settings_set_by_user_id_request_entity_helper.dart';
import 'package:flutter_doctor_app/models/doctor_extend_by_doctor_id_response_entity.dart';
import 'package:flutter_doctor_app/generated/json/doctor_extend_by_doctor_id_response_entity_helper.dart';
import 'package:flutter_doctor_app/models/get_paged_exam_visit_for_doctor_input_entity.dart';
import 'package:flutter_doctor_app/generated/json/get_paged_exam_visit_for_doctor_input_entity_helper.dart';
import 'package:flutter_doctor_app/models/get_paged_order_response_entity.dart';
import 'package:flutter_doctor_app/generated/json/get_paged_order_response_entity_helper.dart';
import 'package:flutter_doctor_app/models/paged_result_dto_response_entity.dart';
import 'package:flutter_doctor_app/generated/json/paged_result_dto_response_entity_helper.dart';
import 'package:flutter_doctor_app/models/make_conclusion_input_request_entity.dart';
import 'package:flutter_doctor_app/generated/json/make_conclusion_input_request_entity_helper.dart';
import 'package:flutter_doctor_app/models/logout_this_device_request_entity.dart';
import 'package:flutter_doctor_app/generated/json/logout_this_device_request_entity_helper.dart';
import 'package:flutter_doctor_app/models/user_info_settings_get_by_user_id_response_entity.dart';
import 'package:flutter_doctor_app/generated/json/user_info_settings_get_by_user_id_response_entity_helper.dart';
import 'package:flutter_doctor_app/models/update_exam_visit_status_input_request_entity.dart';
import 'package:flutter_doctor_app/generated/json/update_exam_visit_status_input_request_entity_helper.dart';

class JsonConvert<T> {
	T fromJson(Map<String, dynamic> json) {
		return _getFromJson<T>(runtimeType, this, json);
	}

  Map<String, dynamic> toJson() {
		return _getToJson<T>(runtimeType, this);
  }

  static _getFromJson<T>(Type type, data, json) {
		switch (type) {
			case UserInfoSettingsGetByUserIdRequestEntity:
				return userInfoSettingsGetByUserIdRequestEntityFromJson(data as UserInfoSettingsGetByUserIdRequestEntity, json) as T;
			case CommonInputResponseEntity:
				return commonInputResponseEntityFromJson(data as CommonInputResponseEntity, json) as T;
			case UserInfoSettingsSetByUserIdRequestEntity:
				return userInfoSettingsSetByUserIdRequestEntityFromJson(data as UserInfoSettingsSetByUserIdRequestEntity, json) as T;
			case DoctorExtendByDoctorIdResponseEntity:
				return doctorExtendByDoctorIdResponseEntityFromJson(data as DoctorExtendByDoctorIdResponseEntity, json) as T;
			case GetPagedExamVisitForDoctorInputEntity:
				return getPagedExamVisitForDoctorInputEntityFromJson(data as GetPagedExamVisitForDoctorInputEntity, json) as T;
			case GetPagedOrderResponseEntity:
				return getPagedOrderResponseEntityFromJson(data as GetPagedOrderResponseEntity, json) as T;
			case GetPagedOrderResponseItems:
				return getPagedOrderResponseItemsFromJson(data as GetPagedOrderResponseItems, json) as T;
			case GetPagedOrderResponseItemsOrder:
				return getPagedOrderResponseItemsOrderFromJson(data as GetPagedOrderResponseItemsOrder, json) as T;
			case GetPagedOrderResponseItemsVisit:
				return getPagedOrderResponseItemsVisitFromJson(data as GetPagedOrderResponseItemsVisit, json) as T;
			case GetPagedOrderResponseItemsExamRecord:
				return getPagedOrderResponseItemsExamRecordFromJson(data as GetPagedOrderResponseItemsExamRecord, json) as T;
			case GetPagedOrderResponseItemsCheckItems:
				return getPagedOrderResponseItemsCheckItemsFromJson(data as GetPagedOrderResponseItemsCheckItems, json) as T;
			case PagedResultDtoResponseEntity:
				return pagedResultDtoResponseEntityFromJson(data as PagedResultDtoResponseEntity, json) as T;
			case PagedResultDtoResponseItems:
				return pagedResultDtoResponseItemsFromJson(data as PagedResultDtoResponseItems, json) as T;
			case MakeConclusionInputRequestEntity:
				return makeConclusionInputRequestEntityFromJson(data as MakeConclusionInputRequestEntity, json) as T;
			case LogoutThisDeviceRequestEntity:
				return logoutThisDeviceRequestEntityFromJson(data as LogoutThisDeviceRequestEntity, json) as T;
			case UserInfoSettingsGetByUserIdResponseEntity:
				return userInfoSettingsGetByUserIdResponseEntityFromJson(data as UserInfoSettingsGetByUserIdResponseEntity, json) as T;
			case UpdateExamVisitStatusInputRequestEntity:
				return updateExamVisitStatusInputRequestEntityFromJson(data as UpdateExamVisitStatusInputRequestEntity, json) as T;    }
		return data as T;
	}

  static _getToJson<T>(Type type, data) {
		switch (type) {
			case UserInfoSettingsGetByUserIdRequestEntity:
				return userInfoSettingsGetByUserIdRequestEntityToJson(data as UserInfoSettingsGetByUserIdRequestEntity);
			case CommonInputResponseEntity:
				return commonInputResponseEntityToJson(data as CommonInputResponseEntity);
			case UserInfoSettingsSetByUserIdRequestEntity:
				return userInfoSettingsSetByUserIdRequestEntityToJson(data as UserInfoSettingsSetByUserIdRequestEntity);
			case DoctorExtendByDoctorIdResponseEntity:
				return doctorExtendByDoctorIdResponseEntityToJson(data as DoctorExtendByDoctorIdResponseEntity);
			case GetPagedExamVisitForDoctorInputEntity:
				return getPagedExamVisitForDoctorInputEntityToJson(data as GetPagedExamVisitForDoctorInputEntity);
			case GetPagedOrderResponseEntity:
				return getPagedOrderResponseEntityToJson(data as GetPagedOrderResponseEntity);
			case GetPagedOrderResponseItems:
				return getPagedOrderResponseItemsToJson(data as GetPagedOrderResponseItems);
			case GetPagedOrderResponseItemsOrder:
				return getPagedOrderResponseItemsOrderToJson(data as GetPagedOrderResponseItemsOrder);
			case GetPagedOrderResponseItemsVisit:
				return getPagedOrderResponseItemsVisitToJson(data as GetPagedOrderResponseItemsVisit);
			case GetPagedOrderResponseItemsExamRecord:
				return getPagedOrderResponseItemsExamRecordToJson(data as GetPagedOrderResponseItemsExamRecord);
			case GetPagedOrderResponseItemsCheckItems:
				return getPagedOrderResponseItemsCheckItemsToJson(data as GetPagedOrderResponseItemsCheckItems);
			case PagedResultDtoResponseEntity:
				return pagedResultDtoResponseEntityToJson(data as PagedResultDtoResponseEntity);
			case PagedResultDtoResponseItems:
				return pagedResultDtoResponseItemsToJson(data as PagedResultDtoResponseItems);
			case MakeConclusionInputRequestEntity:
				return makeConclusionInputRequestEntityToJson(data as MakeConclusionInputRequestEntity);
			case LogoutThisDeviceRequestEntity:
				return logoutThisDeviceRequestEntityToJson(data as LogoutThisDeviceRequestEntity);
			case UserInfoSettingsGetByUserIdResponseEntity:
				return userInfoSettingsGetByUserIdResponseEntityToJson(data as UserInfoSettingsGetByUserIdResponseEntity);
			case UpdateExamVisitStatusInputRequestEntity:
				return updateExamVisitStatusInputRequestEntityToJson(data as UpdateExamVisitStatusInputRequestEntity);
			}
			return data as T;
		}
  //Go back to a single instance by type
	static _fromJsonSingle<M>( json) {
		String type = M.toString();
		if(type == (UserInfoSettingsGetByUserIdRequestEntity).toString()){
			return UserInfoSettingsGetByUserIdRequestEntity().fromJson(json);
		}
		if(type == (CommonInputResponseEntity).toString()){
			return CommonInputResponseEntity().fromJson(json);
		}
		if(type == (UserInfoSettingsSetByUserIdRequestEntity).toString()){
			return UserInfoSettingsSetByUserIdRequestEntity().fromJson(json);
		}
		if(type == (DoctorExtendByDoctorIdResponseEntity).toString()){
			return DoctorExtendByDoctorIdResponseEntity().fromJson(json);
		}
		if(type == (GetPagedExamVisitForDoctorInputEntity).toString()){
			return GetPagedExamVisitForDoctorInputEntity().fromJson(json);
		}
		if(type == (GetPagedOrderResponseEntity).toString()){
			return GetPagedOrderResponseEntity().fromJson(json);
		}
		if(type == (GetPagedOrderResponseItems).toString()){
			return GetPagedOrderResponseItems().fromJson(json);
		}
		if(type == (GetPagedOrderResponseItemsOrder).toString()){
			return GetPagedOrderResponseItemsOrder().fromJson(json);
		}
		if(type == (GetPagedOrderResponseItemsVisit).toString()){
			return GetPagedOrderResponseItemsVisit().fromJson(json);
		}
		if(type == (GetPagedOrderResponseItemsExamRecord).toString()){
			return GetPagedOrderResponseItemsExamRecord().fromJson(json);
		}
		if(type == (GetPagedOrderResponseItemsCheckItems).toString()){
			return GetPagedOrderResponseItemsCheckItems().fromJson(json);
		}
		if(type == (PagedResultDtoResponseEntity).toString()){
			return PagedResultDtoResponseEntity().fromJson(json);
		}
		if(type == (PagedResultDtoResponseItems).toString()){
			return PagedResultDtoResponseItems().fromJson(json);
		}
		if(type == (MakeConclusionInputRequestEntity).toString()){
			return MakeConclusionInputRequestEntity().fromJson(json);
		}
		if(type == (LogoutThisDeviceRequestEntity).toString()){
			return LogoutThisDeviceRequestEntity().fromJson(json);
		}
		if(type == (UserInfoSettingsGetByUserIdResponseEntity).toString()){
			return UserInfoSettingsGetByUserIdResponseEntity().fromJson(json);
		}
		if(type == (UpdateExamVisitStatusInputRequestEntity).toString()){
			return UpdateExamVisitStatusInputRequestEntity().fromJson(json);
		}

		return null;
	}

  //list is returned by type
	static M _getListChildType<M>(List data) {
		if(<UserInfoSettingsGetByUserIdRequestEntity>[] is M){
			return data.map<UserInfoSettingsGetByUserIdRequestEntity>((e) => UserInfoSettingsGetByUserIdRequestEntity().fromJson(e)).toList() as M;
		}
		if(<CommonInputResponseEntity>[] is M){
			return data.map<CommonInputResponseEntity>((e) => CommonInputResponseEntity().fromJson(e)).toList() as M;
		}
		if(<UserInfoSettingsSetByUserIdRequestEntity>[] is M){
			return data.map<UserInfoSettingsSetByUserIdRequestEntity>((e) => UserInfoSettingsSetByUserIdRequestEntity().fromJson(e)).toList() as M;
		}
		if(<DoctorExtendByDoctorIdResponseEntity>[] is M){
			return data.map<DoctorExtendByDoctorIdResponseEntity>((e) => DoctorExtendByDoctorIdResponseEntity().fromJson(e)).toList() as M;
		}
		if(<GetPagedExamVisitForDoctorInputEntity>[] is M){
			return data.map<GetPagedExamVisitForDoctorInputEntity>((e) => GetPagedExamVisitForDoctorInputEntity().fromJson(e)).toList() as M;
		}
		if(<GetPagedOrderResponseEntity>[] is M){
			return data.map<GetPagedOrderResponseEntity>((e) => GetPagedOrderResponseEntity().fromJson(e)).toList() as M;
		}
		if(<GetPagedOrderResponseItems>[] is M){
			return data.map<GetPagedOrderResponseItems>((e) => GetPagedOrderResponseItems().fromJson(e)).toList() as M;
		}
		if(<GetPagedOrderResponseItemsOrder>[] is M){
			return data.map<GetPagedOrderResponseItemsOrder>((e) => GetPagedOrderResponseItemsOrder().fromJson(e)).toList() as M;
		}
		if(<GetPagedOrderResponseItemsVisit>[] is M){
			return data.map<GetPagedOrderResponseItemsVisit>((e) => GetPagedOrderResponseItemsVisit().fromJson(e)).toList() as M;
		}
		if(<GetPagedOrderResponseItemsExamRecord>[] is M){
			return data.map<GetPagedOrderResponseItemsExamRecord>((e) => GetPagedOrderResponseItemsExamRecord().fromJson(e)).toList() as M;
		}
		if(<GetPagedOrderResponseItemsCheckItems>[] is M){
			return data.map<GetPagedOrderResponseItemsCheckItems>((e) => GetPagedOrderResponseItemsCheckItems().fromJson(e)).toList() as M;
		}
		if(<PagedResultDtoResponseEntity>[] is M){
			return data.map<PagedResultDtoResponseEntity>((e) => PagedResultDtoResponseEntity().fromJson(e)).toList() as M;
		}
		if(<PagedResultDtoResponseItems>[] is M){
			return data.map<PagedResultDtoResponseItems>((e) => PagedResultDtoResponseItems().fromJson(e)).toList() as M;
		}
		if(<MakeConclusionInputRequestEntity>[] is M){
			return data.map<MakeConclusionInputRequestEntity>((e) => MakeConclusionInputRequestEntity().fromJson(e)).toList() as M;
		}
		if(<LogoutThisDeviceRequestEntity>[] is M){
			return data.map<LogoutThisDeviceRequestEntity>((e) => LogoutThisDeviceRequestEntity().fromJson(e)).toList() as M;
		}
		if(<UserInfoSettingsGetByUserIdResponseEntity>[] is M){
			return data.map<UserInfoSettingsGetByUserIdResponseEntity>((e) => UserInfoSettingsGetByUserIdResponseEntity().fromJson(e)).toList() as M;
		}
		if(<UpdateExamVisitStatusInputRequestEntity>[] is M){
			return data.map<UpdateExamVisitStatusInputRequestEntity>((e) => UpdateExamVisitStatusInputRequestEntity().fromJson(e)).toList() as M;
		}

		throw Exception("not found");
	}

  static M fromJsonAsT<M>(json) {
		if (json is List) {
			return _getListChildType<M>(json);
		} else {
			return _fromJsonSingle<M>(json) as M;
		}
	}
}