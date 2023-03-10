const String baseUrl="https://marketingservertest.comeon4eyes.com/";
const int USER_ROLE = 2;
const int LOGIN_TYPE = 2;
const String CLIENT_ID = "app_doctor_client";
const String GET_ENUM="api/Common/GetEnum";
const String GET_USER_INFO="external/WechatAuth/GetUserInfo";
const String REQUEST_TOKEN = "external/Login/RequestToken";
const String REFRESH_TOKEN = "external/Login/RefreshToken";
const String GETPAGED_ORDERS_BY_CURRENT_DOCTOR = "doctor/Order/GetPagedOrdersByCurrentDoctor";//获取订单列表
const String LOGOUT_THIS_DEVICE = "external/Login/LogoutThisDevice";//账号其它设备登陆后本地不再进行登录
const String GET_PAGE_EXAM_VISIT_FOR_DOCTOR = "doctor/ExamVisit/GetPagedExamVisitForDoctor";//专家端获取自己各种状态下的咨询记录
const String LOAD_URL = "https://marketingtest.comeon4eyes.com/#/medicalreport?examRecordId=";
const String UPDATE_EXAMVISIT_STATUS = "doctor/ExamVisit/UpdateExamVisitStatus";//专家修改咨询记录的状态
const String MAKE_CONCLUSION = "doctor/ExamVisit/MakeConclusion";//专家下结论
const String DOCTOR_EXTEND_GET_DOCTOR_EXTEND_BY_DOCTORID = "doctor/DoctorExtend/GetDoctorExtendByDoctorId";//获取医生扩展信息
const String USERINFO_SETTINGS_GET_BY_USERID = "user/UserInfo/UserInfoSettingsGetByUserId";//登陆后获取自身设置
const String USERINFO_SETTINGS_SET_BY_USERID = "user/UserInfo/UserInfoSettingsSetByUserId";//登陆后设置自身设置
const String UPDATE_USER_PASSWORD = "user/UserInfo/UpdateUserPassword";//用户自己修改密码
const String GET_CURRENT_DOCTOR_INFO = "user/UserInfo/GetCurrentDoctorInfo";//获取当前医生信息
const String CREATE_AUTH_CODE = "user/Common/CreateAuthCode";//发送验证码
const String UPDATE_USER_PHONE = "user/UserInfo/UpdateUserPhone";//用户修改绑定手机
const String RESET_USER_PASSWORD = "user/UserInfo/ResetUserPassword";//用户重置密码
const String USER_INFO_REGISTER = "user/UserInfo/UserInfoRegister";//用户注册
const String SET_USER_PASSWORD = "user/UserInfo/SetUserPassword";//用户设置密码
const String BIND_PHONE = "user/UserInfo/UserInfoBindPhone";//绑定手机号
const String GET_USER_INFO_FOR_EDIT = "doctor/DoctorExtend/GetUserInfoForEdit";//获取编辑用户信息
const String STS_UPLOAD_RESPONSE = "user/BackStageCommon/StsUploadResponse";//获取Oss上传需要的Sts
const String UPLOAD_IMAGE_BASE_URL = "https://resource.comeon4eyes.com/";//上传图片的路径
const String UPDATE_USER_INFO = "doctor/DoctorExtend/UpdateUserInfo";//编辑用户信息
const String JIGUANGID = "190e35f7e0a2b54243d";