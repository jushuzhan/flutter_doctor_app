import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'PrivacypolicyItem.dart';
import 'keepalivewrapper.dart';
class PrivacyPolicyPage extends StatefulWidget {
  @override
  _PrivacyPolicyPageState createState() {
    return _PrivacyPolicyPageState();
  }
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> with SingleTickerProviderStateMixin{
  List<String> tabs = ["用户协议", "隐私政策"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFFFFFFFF),
          titleSpacing: 15.0, //标题距离左边大小
          title: Text("隐私条款",style: TextStyle(
            fontSize: 18,
            color: Color(0XFF333333),
          ),),
          leading: IconButton(
              icon: Image.asset(
                'assets/images/nav_icon_back_gray.png',
                width: 24,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          bottom: TabBar(
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
          //构建
          children: tabs.map((e) {
            return KeepAliveWrapper(
              child: PrivacyPolicyItemPage(e),
            );
          }).toList(),
        ),
      ),
    );
  }
}
