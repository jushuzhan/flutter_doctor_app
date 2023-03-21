import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui show Codec, FrameInfo, Image;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/common/net/NetWorkWithToken.dart';


import '../common/LoginPrefs.dart';
import '../common/event/event.dart';
import '../models/patient_customer_get_by_id_response_entity.dart';
import 'ChatMessageItem.dart';
import 'chat_bottom.dart';
import 'expanded_viewport.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';



class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController listScrollController = new ScrollController();
  List<EMMessage> mlistMessage =  [];

  //https://stackoverflow.com/questions/50733840/trigger-a-function-from-a-widget-to-a-state-object/50739019#50739019
  final changeNotifier = new StreamController.broadcast();
  AudioPlayer mAudioPlayer = AudioPlayer();
  bool isPalyingAudio = false;
  String mPalyingPosition = "";
  bool isShowLoading = false;
  bool isBottomLayoutShowing = false;
  Map<String, dynamic>  arguments=Map();
   String toChatUsername='';//userHuanXinId
   int? patientId;
   int? examRecordId;
   String? headIcon;
  EMConversation? conversation;//当前会话
  TextStyle  commonTextStyle=TextStyle(
    fontSize: 12,color: Color(0xCCFFFFFF)
  );
  Padding verticalLine=Padding(
    padding: EdgeInsets.symmetric(horizontal: 4),
    child: Container(
      width: 1,
      height: 12,
      color: Color(0xCCFFFFFF),
    ),
  );
  String name='';
  String gender='';
  String birthday='';

  @override
  void dispose() {
    // 移除发送消息状态监听器
    EMClient.getInstance.chatManager.removeMessageEvent("SEND_UNIQUE_HANDLER_ID");
    // 移除接收消息状态监听器
    EMClient.getInstance.chatManager.removeEventHandler("RECEIVED_UNIQUE_HANDLER_ID");
    changeNotifier.close();
    super.dispose();
  }

  getHistroryMessage() async{
    print("获取历史消息");
    //List<EMMessage> mHistroyListMessage =  [];
    // final EMMessage mMessgae = new HrlTextMessage();
    // mMessgae.text = "测试消息";
    // mMessgae.msgType = HrlMessageType.text;
    // mMessgae.isSend = false;
    // mHistroyListMessage.add(mMessgae);
    // mHistroyListMessage.add(mMessgae);
    // final HrlImageMessage mMessgaeImg = new HrlImageMessage();
    // mMessgaeImg.msgType = HrlMessageType.image;
    // mMessgaeImg.isSend = false;
    // mMessgaeImg.thumbUrl =
    // "https://c-ssl.duitang.com/uploads/item/201208/30/20120830173930_PBfJE.thumb.700_0.jpeg";
    // mHistroyListMessage.add(mMessgaeImg);
// 执行操作。

    List<EMMessage>? list = await conversation?.loadMessages();
    if(list!=null){
      mlistMessage= list.toList();
    }


  }


  // //文本消息
  // sendTextMsg(String hello) {
  //   final HrlTextMessage mMessgae = new HrlTextMessage();
  //   mMessgae.text = hello;
  //   mMessgae.msgType = HrlMessageType.text;
  //   mMessgae.isSend = true;
  //   mlistMessage.add(mMessgae);
  // }
  initConversation () async{
    conversation =
    await EMClient.getInstance.chatManager.getConversation(
      toChatUsername, type: EMConversationType.Chat,
      createIfNeed: true,
    );
  }
  @override
  void initState() {
    super.initState();
    customerGetById();
    initConversation();
    // 添加消息状态监听器
    //发送消息结果回调，用于接收消息发送进度或者发送结果，如发送成功或失败
    EMClient.getInstance.chatManager.addMessageEvent(
      "SEND_UNIQUE_HANDLER_ID",
      ChatMessageEvent(
        // 收到成功回调之后，可以对发送的消息进行更新处理，或者其他操作。
        onSuccess: (msgId, msg) {
          // msgId 发送时消息ID;
          // msg 发送成功的消息;
          getHistroryMessage();
          listScrollController.animateTo(0.00,
              duration: Duration(milliseconds: 1),
              curve: Curves.easeOut);
          setState(() {});
        },
        // 收到回调之后，可以将发送的消息状态进行更新，或者进行其他操作。
        onError: (msgId, msg, error) {
          // msgId 发送时的消息ID;
          // msg 发送失败的消息;
          // error 失败原因;
        },
        // 对于附件类型的消息，如图片，语音，文件，视频类型，上传或下载文件时会收到相应的进度值，表示附件的上传或者下载进度。
        onProgress: (msgId, progress) {
          // msgId 发送时的消息ID;
          // progress 进度;
        },
      ),
    );

    // 添加监听器
    //接收 消息结果回调 在新消息到来时，你会收到 onMessagesReceived 的事件，消息接收时可能是一条，也可能是多条。你可以在该回调里遍历消息队列，解析并显示收到的消息。
    EMClient.getInstance.chatManager.addEventHandler(
      "RECEIVED_UNIQUE_HANDLER_ID",
      EMChatEventHandler(
        onMessagesReceived: (list) => {
          list.forEach((element) {
            String? username;
            username=element.from;
            // if the message is for current conversation
             if (username==(toChatUsername) || element.to==(toChatUsername) || element.conversationId==(toChatUsername)) {
             // messageList.refreshSelectLast();
               getHistroryMessage();
             conversation!.markMessageAsRead(element.msgId);
            }
          })


        },
      ),
    );
    getHistroryMessage();
    listScrollController.addListener(() {
      if (listScrollController.position.pixels ==
          listScrollController.position.maxScrollExtent) {
        isShowLoading = true;
          getHistroryMessage();
          setState(() {
            isShowLoading = false;
          });

      }
    });
  }


  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print("arguments==$arguments");
    toChatUsername=arguments['toChatUsername'];
    patientId=arguments['patientId'];
    examRecordId=arguments['examRecordId'];
    headIcon=arguments['headIcon'];




    return SafeArea(
        child: new WillPopScope(
          onWillPop: () {
            FocusScope.of(context).requestFocus(FocusNode());
            changeNotifier.sink.add(null);
            Navigator.pop(context);
            return Future(() => true);
          },
          child: Scaffold(
            appBar:AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light, //状态栏字体为白色
              centerTitle: true,
              title: Text(
                "问诊咨询",
                style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)),
              ),
              elevation: 0.0, //阴影设置为0，默认为4
              titleSpacing: 15.0, //标题距离左边大小
              leading: IconButton(
                  icon: Image.asset(
                    'assets/images/nav_icon_back.png',
                    width: 24,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              bottom: PreferredSize(preferredSize: Size.fromHeight(40),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 32,
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Color(0xff008e8e)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: Wrap(
                      children: <Widget>[
                        Text('就诊人',style: commonTextStyle,),
                        verticalLine,
                        Text(name,style: commonTextStyle,),
                      ],
                    ),flex: 2,),
                    Expanded(child: Wrap(
                      children: <Widget>[
                        Text('性别',style: commonTextStyle,),
                        verticalLine,
                        Text(gender,style: commonTextStyle,)
                      ],
                    ),flex: 1,),
                    Expanded(child: Wrap(
                      children: <Widget>[
                        Text('出生日期',style: commonTextStyle,),
                        verticalLine,
                        Text(birthday,style: commonTextStyle,)
                      ],
                    ),),
                  ],
                ),
              ),

              ),
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  /*   Expanded(
          child:Column(
            children: <Widget>[*/

                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        //  点击顶部空白处触摸收起键盘
                        FocusScope.of(context).requestFocus(FocusNode());
                        changeNotifier.sink.add(null);
                      },
                      child: new ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: Scrollable(
                          physics: AlwaysScrollableScrollPhysics(),
                          controller: listScrollController,
                          axisDirection: AxisDirection.up,
                          viewportBuilder: (context, offset) {
                            return ExpandedViewport(
                              offset: offset  ,
                              axisDirection: AxisDirection.up,
                              slivers: <Widget>[
                                SliverExpanded(),
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                        (c, i) {
                                      final GlobalKey<ChatMessageItemState>
                                      mMessageItemKey = GlobalKey();
                                      mMessageItemKey.currentState
                                          ?.methodInChild(false, "");
                                      ChatMessageItem mChatItem = ChatMessageItem(
                                        key: mMessageItemKey,
                                        mMessage: mlistMessage[i],
                                        onAudioTap: (String str) {
                                          if (isPalyingAudio) {
                                            isPalyingAudio = false;
                                            mMessageItemKey.currentState
                                                ?.methodInChild(
                                                false, mPalyingPosition);
                                            mAudioPlayer
                                                .release(); // manually release when no longer needed
                                            mPalyingPosition = "";
                                            setState(() {});
                                          } else {
                                            Future<void> result = mAudioPlayer .play(DeviceFileSource(str));
                                            mAudioPlayer.onPlayerComplete   .listen((event) {
                                              mMessageItemKey.currentState
                                                  ?.methodInChild(
                                                  false, mPalyingPosition);
                                              isPalyingAudio = false;
                                              mPalyingPosition = "";
                                            });

                                            isPalyingAudio = true;
                                            mPalyingPosition = mlistMessage[i].msgId!;
                                            mMessageItemKey.currentState
                                                ?.methodInChild(
                                                true, mPalyingPosition);
                                          }
                                        },
                                      );
                                      return mChatItem;
                                    },
                                    childCount: mlistMessage.length,
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: isShowLoading
                                      ? Container(
                                    margin: EdgeInsets.only(top: 5),
                                    height: 50,
                                    child: Center(
                                      child: SizedBox(
                                        width: 25.0,
                                        height: 25.0,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                        ),
                                      ),
                                    ),
                                  )
                                      : new Container(),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  /*  ],
          )*/
                  //   ),

                  ChatBottomInputWidget(
                      shouldTriggerChange: changeNotifier.stream,
                      onSendCallBack: (value) {
                        print("发送的文字:" + value);
                        // final HrlTextMessage mMessgae = new HrlTextMessage();
                        // mMessgae.uuid = Uuid().v4() + "";
                        // mMessgae.text = value;
                        // mMessgae.msgType = HrlMessageType.text;
                        // mMessgae.isSend = true;
                        // mMessgae.state = HrlMessageState.sending;
                        // 设置发送的消息类型。消息类型共支持 8 种。具体详见 `MessageType` 枚举类型。
                        //MessageType messageType = MessageType.TXT;
// 设置消息接收对象 ID。
                        String targetId = toChatUsername;
// 设置消息接收对象类型。消息接收对象类型包括单人、群组和聊天室。具体详见 `ChatType` 枚举类型。
                       // ChatType chatType = ChatType.Chat;
// 构造消息。构造不同类型的消息，需要不同的参数。
// 构造文本消息
                        EMMessage msg = EMMessage.createTxtSendMessage(
                          targetId: targetId,
                          content: value,
                        );
                        //通过 EMChatManager 将该消息发出
                        // 消息发送结果会通过回调对象返回，该返回结果仅表示该方法的调用结果，与实际消息发送状态无关。
                        EMClient.getInstance.chatManager.sendMessage(msg).then((value) {
                          // 消息发送动作完成。
                        });
                      },
                      onImageSelectCallBack: (value) {
                        File image = new File(
                            value?.path??""); // Or any other way to get a File instance.
                        Future<ui.Image> decodedImage =
                        decodeImageFromList(image.readAsBytesSync());


                        decodedImage.then((result) {
                          print("图片的宽:" + "${result.width}");
                          print("图片的高:" + "${result.height}");
                        });

                        String targetId = toChatUsername;
                        EMMessage msg = EMMessage.createImageSendMessage(
                          targetId: targetId,
                          filePath: value?.path??"",
                        );
                        EMClient.getInstance.chatManager.sendMessage(msg).then((value) {
                          // 消息发送动作完成。
                        });

                      },
                      onAudioCallBack: (value, duration) {
                        String targetId = toChatUsername;
                        EMMessage msg = EMMessage.createVoiceSendMessage(
                          targetId: targetId,
                          filePath: value.path,
                          duration: duration,
                        );
                        EMClient.getInstance.chatManager.sendMessage(msg).then((value) {
                          // 消息发送动作完成。
                        });

                      }),
                ],
              ),
            ),
          ),
        ));
  }

}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details){
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    } else {
      return super.buildOverscrollIndicator(context, child, details);
    }
  }
  // @override
  // Widget buildViewportChrome(
  //     BuildContext context, Widget child, AxisDirection axisDirection) {
  //   if (Platform.isAndroid || Platform.isFuchsia) {
  //     return child;
  //   } else {
  //     return super.buildViewportChrome(context, child, axisDirection);
  //
  //   }
  // }


}