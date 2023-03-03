import 'package:flutter/material.dart';

import 'package:flutter_doctor_app/common/LoginPrefs.dart';

import 'common/constants/constants.dart';

import 'package:webview_flutter/webview_flutter.dart';

// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class AuditRecordPage extends StatefulWidget {
  @override
  _AuditRecordPageState createState() => _AuditRecordPageState();
}

class _AuditRecordPageState extends State<AuditRecordPage> {
  late final WebViewController _controller;
  late Widget dialog;
  late  Map<String, dynamic>  arguments;
  late  int examRecordId;

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
    // #enddocregion platform_features
    _controller = controller;

  }


  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print("arguments==$arguments");
    examRecordId=arguments["examRecordId"];
    print(examRecordId);
    _controller.loadRequest(
        Uri.parse(LOAD_URL + examRecordId.toString()));
    return WillPopScope(
     onWillPop:  () async {
       //拦截 返回键
       return false;
     },
      child: Material(
        type: MaterialType.transparency,
        child: contentColumn(),
      ),
    );
  }

  Column contentColumn() {
    return Column(
      children: <Widget>[
        //第一行标题
        Container(
          margin: EdgeInsets.only(top: 20),
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

}
