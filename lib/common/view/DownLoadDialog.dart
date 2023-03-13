import 'package:flutter/material.dart';

import '../event/event.dart';


class DownloadDialog extends StatefulWidget{
  String percent = '0%';
  double progress = 0; //下载默认进度是0


  static showDownLoadDialog(
      BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: DownloadDialog(
              ),onWillPop: _onWillPop);
        });
  }
  static Future<bool> _onWillPop() async{
    return false;
  }

  @override
  _DownloadDialogState createState() {
    // TODO: implement createState
    return _DownloadDialogState();
  }


}
class _DownloadDialogState extends State<DownloadDialog>{

  @override
  void initState() {
    super.initState();
    eventBus.on<MyEventProgress>().listen((event) {
      // All events are of type MyEventProgress (or subtypes of it).
      print(event.percent);
      print(event.progress);
      if(mounted){
        setState(() {
          widget.percent=event.percent;
          widget.progress=event.progress;
        });
      }



    });

  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            child: Image.asset(
              'assets/images/image_upgrade.png',
              width: MediaQuery.of(context).size.width,
              height: 139,
              fit: BoxFit.fill,
            ),
            padding: EdgeInsets.symmetric(horizontal: 28),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 28),
            decoration: BoxDecoration(
              color:  Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6),bottomRight: Radius.circular(6))
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 74),
                        child: Text(
                          widget.percent,
                          style:
                          TextStyle(color: Color(0xFF009999), fontSize: 24),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8,left: 40,right: 40),
                        height: 12,
                        child:ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          child: LinearProgressIndicator(
                            value: widget.progress,
                            backgroundColor: Color(0xFFEEEEEE),
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xff30c1b5)),
                          ),
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40, bottom: 73),
                        child: Text(
                          '新版本正在更新，请稍等…',
                          style:
                          TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}
