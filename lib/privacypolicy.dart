import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color.dart';
import 'keepalivewrapper.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
class PrivacyPolicyPage extends StatefulWidget {
  @override
  _PrivacyPolicyPageState createState() {
    return _PrivacyPolicyPageState();
  }
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> with SingleTickerProviderStateMixin{
  List<String> tabs = ["用户协议", "隐私政策"];
  late final WebViewController user_controller;
  late final WebViewController privacy_controller;
  late TabController _tabController;
  //late WebViewController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // #docregion platform_features
    // #enddocregion platform_features
    user_controller = initWebView('assets/files/yonghuxieyi.html');
    privacy_controller = initWebView('assets/files/yinsizhengce.html');
    //controller=user_controller;
    _tabController=_tabController = TabController(vsync:this,length: tabs.length,);
    _tabController.addListener((){
      print("当前的index:");
      print(_tabController.index);
      //loadHtml();

    });
  }
  // void loadHtml () {
  //   setState(() {
  //     if(_tabController.index==0){
  //       controller=user_controller;
  //       controller.loadFlutterAsset('assets/files/yonghuxieyi.html');
  //     }else{
  //       controller=privacy_controller;
  //       controller.loadFlutterAsset('assets/files/yinsizhengce.html');
  //     }
  //   });
  // }

  WebViewController initWebView(String load) {
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

        ),
      )
    ..loadFlutterAsset(load);
      // ..loadRequest(Uri.parse('https://flutter.cn'));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features
    return controller;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFFFFFFFF),
          title: Text("隐私条款",style: TextStyle(
            fontSize: 18,
            color: Color(0XFF333333),
          ),),
          leading: IconButton(
              icon: Image.asset(
                'assets/images/nav_icon_back_gray.png',
                width: 24,
              ),
              padding: EdgeInsets.only(left: 15),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          bottom: TabBar(
            controller: _tabController,
            tabs: tabs.map((e) => Tab(text: e)).toList(),
            labelColor: Color(0xFF333333),
            labelStyle: TextStyle(
              fontSize: 16,
              //color: Color(0xFF333333)//如果不设置labelColor 此color不生效，所以可以去掉此行代码，因为颜色已经设置过了
            ),
            unselectedLabelColor: Color(0xFF999999),
            unselectedLabelStyle: TextStyle(
              fontSize: 16,
              //color: Color(0xFF999999)//如果不设置unselectedLabelColor 此color不生效，所以可以去掉此行代码，因为颜色已经设置过了
            ),
            indicatorColor: Color(0xFF333333),
            indicatorPadding: EdgeInsets.only(top: 9),
            indicatorSize: TabBarIndicatorSize.label,//和label大小一致，即指示器的宽度与用户协议的宽度一致
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,//状态栏字体为黑色
          elevation: 0,
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            WebViewWidget(controller: user_controller!),
            WebViewWidget(controller: privacy_controller!),
          ],
        ),
    );
  }
}
