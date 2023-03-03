import 'package:flutter/material.dart';

import 'package:date_format/date_format.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';
import 'package:flutter_doctor_app/common/net/NetWorkWithToken.dart';

import 'common/constants/constants.dart';
import 'models/paged_result_dto_response_entity.dart';

import 'package:webview_flutter/webview_flutter.dart';

// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'models/update_exam_visit_status_input_request_entity.dart';
import 'models/update_exam_visit_status_input_response_entity_entity.dart';
import 'package:fluttertoast/fluttertoast.dart';
typedef RefreshDataCallBack = void Function();//接口回调 item点击了拒绝申请
class ExamVisitItemPage extends StatefulWidget {

  final RefreshDataCallBack refreshDataCallBack;
  final PagedResultDtoResponseItems examVisitItem;
   ExamVisitItemPage({required this.examVisitItem,required this.refreshDataCallBack,}) : super(key: ValueKey(examVisitItem.creationTime));

  @override
  _ExamVisitItemPageState createState() => _ExamVisitItemPageState();
}

class _ExamVisitItemPageState extends State<ExamVisitItemPage> {
  final TextStyle grey12TextStyle = TextStyle(
    fontSize: 12,
    color: Color(0xFF999999),
  );

  late final WebViewController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            String accessToken = LoginPrefs(context).getAccessToken()!;
            controller.runJavaScriptReturningResult(
                "javascript:setH5Token({token:'" + accessToken + "'})");
            controller.runJavaScriptReturningResult(
                "javascript:" + "reloadPage" + "()");
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          // onNavigationRequest: (NavigationRequest request) {
          //   if (request.url.startsWith('https://www.youtube.com/')) {
          //     debugPrint('blocking navigation to ${request.url}');
          //     return NavigationDecision.prevent;
          //   }
          //   debugPrint('allowing navigation to ${request.url}');
          //   return NavigationDecision.navigate;
          // },
        ),
      )
      ..addJavaScriptChannel(
        'jsInterface',
        onMessageReceived: (JavaScriptMessage message) {
          print('message:' + message.message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      );

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    controller.loadRequest(
        Uri.parse(LOAD_URL + widget.examVisitItem.examRecordId.toString()));
    // #enddocregion platform_features
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          //状态
          Row(
            children: _buildTopList(),
          ),
          //第一行
          Padding(
            padding: EdgeInsets.only(top: 8, left: 15, right: 15),
            child: Row(
              children: <Widget>[
                Container(
                  width: 38,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xFF009999),
                      borderRadius: BorderRadius.all(Radius.circular(2))),
                  child: Text(
                    '就诊人',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      widget.examVisitItem.patientName!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  flex: 1,
                ),
                Text(
                  getTime(getDateTime(widget.examVisitItem.creationTime!)),
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          //第二行
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 27, right: 15),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Text('描述:', style: grey12TextStyle),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.examVisitItem.isExpanded=!widget.examVisitItem.isExpanded;
                      });

                    },
                    child: Text(
                      widget.examVisitItem.question != null
                          ? widget.examVisitItem.question!
                          : "",
                      maxLines: widget.examVisitItem.isExpanded?null:2,
                      overflow: widget.examVisitItem.isExpanded?null:TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
          //最后一行动态创建布局
          Column(
            children: _buildBottomList(),
          ),
        ],
      ),
    );
  }

  /// 创建列表 ,状态显示
  List<Widget> _buildTopList() {
    List<Widget> widgets = [];
    int? examVisitStatus = widget.examVisitItem.examVisitStatus;
    if (examVisitStatus != null) {
      switch (examVisitStatus) {
        // case 1://已申请
        //   break;
        case 2: //超时，未回复
          widgets.add(Padding(
            padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
            child: Text(
              '您回复已超时，不能进行下一步操作',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
          ));
          break;
        case 3: //拒绝
          widgets.add(Padding(
            padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
            child: Text(
              '您已拒绝该申请',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
          ));
          break;
        // case 4://同意
        //   break;
        // case 5://已解决
        //   break;
        case 6: //诊断超时
          widgets.add(Padding(
            padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
            child: Text(
              '您诊断已超时',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
          ));
          break;
        // case 7://超时，未支付
        //   break;
      }
    }

    return widgets;
  }

  Divider horizontalLine() {
    return Divider(
      height: 1,
      color: Color(0xFFEEEEEE),
    );
  }

  Container verticalLine() {
    return Container(
      height: 24,
      width: 1,
      color: Color(0xFFEEEEEE),
    );
  }

  /// 创建列表 ,底部按钮显示
  List<Widget> _buildBottomList() {
    List<Widget> widgets = [];
    int? examVisitStatus = widget.examVisitItem.examVisitStatus;
    if (examVisitStatus != null) {
      switch (examVisitStatus) {
        case 1: //已申请
          widgets.add(horizontalLine());
          widgets.add(Row(
            crossAxisAlignment: CrossAxisAlignment.center, //垂直居中
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '拒绝申请',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF009999),
                      ),
                    ),
                  ),
                  onTap: () {
                    //TODO 调接口，拒绝申请
                    rejectApplyClick();
                  },
                ),
                flex: 1,
              ),
              verticalLine(),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '检查记录',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF009999),
                      ),
                    ),
                  ),
                  onTap: () {
                    //TODO 跳转至检查记录界面
                    checkRecordClick();
                  },
                ),
                flex: 1,
              ),
              verticalLine(),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '同意申请',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF009999),
                      ),
                    ),
                  ),
                  onTap: () {
                    //TODO 调接口，同意申请
                    agreeApplyClick();
                  },
                ),
                flex: 1,
              ),
            ],
          ));
          break;
        case 2: //超时，未回复
          break;
        case 3: //拒绝
          widgets.add(horizontalLine());
          widgets.add(Row(
            crossAxisAlignment: CrossAxisAlignment.center, //垂直居中
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '检查记录',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF009999),
                      ),
                    ),
                  ),
                  onTap: () {
                    //TODO 跳转至检查记录界面
                    checkRecordClick();
                  },
                ),
                flex: 1,
              ),
            ],
          ));
          break;
        case 4: //同意
          widgets.add(horizontalLine());
          widgets.add(Row(
            crossAxisAlignment: CrossAxisAlignment.center, //垂直居中
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '检查记录',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF009999),
                      ),
                    ),
                  ),
                  onTap: () {
                    //TODO 跳转至检查记录界面
                    checkRecordClick();
                  },
                ),
                flex: 1,
              ),
              verticalLine(),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '继续对话',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF009999),
                      ),
                    ),
                  ),
                  onTap: () {
                    //TODO 跳转至聊天界面
                  },
                ),
                flex: 1,
              ),
              verticalLine(),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '填写结论',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF009999),
                      ),
                    ),
                  ),
                  onTap: () {
                    //TODO 跳转至填写结论界面
                  },
                ),
                flex: 1,
              ),
            ],
          ));
          break;
        case 5: //已解决
          widgets.add(horizontalLine());
          widgets.add(Row(
            crossAxisAlignment: CrossAxisAlignment.center, //垂直居中
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '检查记录',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF009999),
                      ),
                    ),
                  ),
                  onTap: () {
                    //TODO 跳转至检查记录界面
                    checkRecordClick();
                  },
                ),
                flex: 1,
              ),
              verticalLine(),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '查看结论',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF009999),
                      ),
                    ),
                  ),
                  onTap: () {
                    //TODO 跳转至查看结论界面
                  },
                ),
                flex: 1,
              ),
            ],
          ));
          break;
        case 6: //诊断超时
          widgets.add(horizontalLine());
          widgets.add(Row(
            crossAxisAlignment: CrossAxisAlignment.center, //垂直居中
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '检查记录',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF009999),
                      ),
                    ),
                  ),
                  onTap: () {
                    //TODO 跳转至检查记录界面
                    checkRecordClick();
                  },
                ),
                flex: 1,
              ),
              verticalLine(),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '查看对话',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF009999),
                      ),
                    ),
                  ),
                  onTap: () {
                    //TODO 跳转至聊天界面
                  },
                ),
                flex: 1,
              ),
            ],
          ));
          break;
        case 7: //超时，未支付
          break;
      }
    }

    return widgets;
  }

  void checkRecordClick() async {
    showDialog(
        context: context,
        builder: (context) {
          return contentColumn();
        },
        barrierDismissible: false);
  }
  void rejectApplyClick()async{
    bool isSuccess=await isUpdateExamVisitStatusSuccess(3);
    if(isSuccess){
      widget.refreshDataCallBack();
    }
  }
  void agreeApplyClick()async{
    bool isSuccess=await isUpdateExamVisitStatusSuccess(4);
    if(isSuccess){
      widget.refreshDataCallBack();
    }
  }
  Future<bool> isUpdateExamVisitStatusSuccess(int examVisitStatus) async{
    UpdateExamVisitStatusInputRequestEntity updateExamVisitStatusInputRequestEntity=UpdateExamVisitStatusInputRequestEntity();
    updateExamVisitStatusInputRequestEntity.id=widget.examVisitItem.id;
    updateExamVisitStatusInputRequestEntity.examVisitStatus=examVisitStatus;
    UpdateExamVisitStatusInputResponseEntityEntity updateExamVisitStatus=await NetWorkWithToken(context).updateExamVisitStatus(updateExamVisitStatusInputRequestEntity);
    if(updateExamVisitStatus.successed!=null&&updateExamVisitStatus.successed==true){
      if(updateExamVisitStatus.msg!=null){
        Fluttertoast.showToast(msg: updateExamVisitStatus.msg!);
      }
      return true;
    }else{
      if(updateExamVisitStatus.msg!=null){
        Fluttertoast.showToast(msg: updateExamVisitStatus.msg!);
      }
      return false;
    }
  }

  Column contentColumn() {
    return Column(
      children: <Widget>[
        //第一行标题
        Container(
          width: MediaQuery.of(context).size.width,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            color: Colors.white,
          ),
          child: Text(
            '检查记录',
            style: TextStyle(
                fontSize: 18,
                color: Color(0xFF333333),
                fontWeight: FontWeight.bold),
          ),
        ),
        //第二行
        Divider(
          height: 1,
          color: Color(0xFFEEEEEE),
        ),
        //第三行
        Expanded(
          child: WebViewWidget(
            controller: _controller,
          ),
          flex: 1,
        ),
        //第四行
        Divider(
          height: 1,
          color: Color(0xFFEEEEEE),
        ),
        //第五行
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 49,
            alignment: Alignment.center,
            child: Image(
              image: AssetImage(
                'assets/images/icon_close.png',
              ),
              width: 32,
            ),
          ),
        )
      ],
    );
  }

  DateTime? getDateTime(String time) {
    DateTime? dateTime = DateTime.tryParse("${time.substring(0, 19)}");
    return dateTime;
  }

  String getTime(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }
    return formatDate(
        dateTime!, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
  }
}
