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
const String JIGUANGID = "190e35f7e0a2b54243d";