import 'package:flutter/material.dart';
import '../common/constants/constants.dart';
import 'Bubble.dart';
import 'voice_animation.dart';
import 'dart:io';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class ChatMessageItem extends StatefulWidget {
  EMMessage? mMessage;
  ValueSetter<String>? onAudioTap;

  ChatMessageItem({Key? key, this.mMessage, this.onAudioTap}) : super(key: key);

  @override
  ChatMessageItemState createState() => ChatMessageItemState();
}

class ChatMessageItemState extends State<ChatMessageItem> {
  List<String> mAudioAssetRightList = [];
  List<String> mAudioAssetLeftList = [];

  bool mIsPlayint = false;
  //String mUUid = "";
  String mMsgId = "";

  // methodInChild(bool isPlay, String uid) {
  //   mIsPlayint = isPlay;
  //   mUUid = uid;
  //   setState(() {});
  // }
  methodInChild(bool isPlay, String msgId) {
    mIsPlayint = isPlay;
    mMsgId = msgId;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    mAudioAssetRightList.add(ASSETS_IMG + "audio_animation_list_right_1.png");
    mAudioAssetRightList.add(ASSETS_IMG + "audio_animation_list_right_2.png");
    mAudioAssetRightList.add(ASSETS_IMG + "audio_animation_list_right_3.png");

    mAudioAssetLeftList.add(ASSETS_IMG + "audio_animation_list_left_1.png");
    mAudioAssetLeftList.add(ASSETS_IMG + "audio_animation_list_left_2.png");
    mAudioAssetLeftList.add(ASSETS_IMG + "audio_animation_list_right_3.png");


  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      // child: widget.mMessage!.isSend!
      //     ? getSentMessageLayout()
      //     : getReceivedMessageLayout(),
      child: widget.mMessage!.direction==MessageDirection.SEND? getSentMessageLayout()
          : getReceivedMessageLayout(),
    );
  }

  Widget getmImageLayout(EMImageMessageBody mMessgae) {
    Widget child;
    if (mMessgae.localPath != null && (!mMessgae.localPath!.isEmpty)) {
      child =
          Image.file(File('${(widget.mMessage!.body as EMImageMessageBody).localPath}'));
    } else {
      child = Image.network(
        '${(widget.mMessage!.body as EMImageMessageBody).localPath}',
        fit: BoxFit.fill,
      );
    }
    return child;
  }

  Widget getItemContent(EMMessage mMessage) {
    switch (mMessage.body.type) {
      case MessageType.IMAGE:
        return Container(
          /* width:mImgWidth,
          height: mImgHeight,*/
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: 150,
          ),
          //child: getmImageLayout(widget.mMessage as HrlImageMessage),
          child: getmImageLayout(mMessage.body as EMImageMessageBody),
        );
        break;
      case MessageType.TXT:
        return Text(
          // '${(widget.mMessage as HrlTextMessage).text}',
          '${(mMessage.body as EMTextMessageBody).content}',
          softWrap: true,
          style: TextStyle(fontSize: 14.0, color: Colors.black),
        );
        break;
      case MessageType.VOICE:
        bool isStop = true;
        //if (mUUid == widget.mMessage?.uuid) {
          if (mMsgId == widget.mMessage?.msgId) {
          if (!mIsPlayint) {
            isStop = true;
          } else {
            isStop = false;
          }
        } else {
          isStop = true;
        }


        //    print("是否停止:"+isStop.toString()+"widget.mUUid=:"+widget.mUUid );
        return GestureDetector(
          onTap: () {
            //  int result = await mAudioPlayer.play((widget.mMessage as HrlVoiceMessage).path, isLocal: true);
           // widget.onAudioTap!((widget.mMessage as HrlVoiceMessage).path!);
            widget.onAudioTap!((mMessage.body as EMVoiceMessageBody).localPath!);
          },
          child: VoiceAnimationImage(
            //mMessage.isSend!?mAudioAssetRightList:mAudioAssetLeftList,
            mMessage.direction==MessageDirection.SEND?mAudioAssetRightList:mAudioAssetLeftList,
            width: 100,
            height: 30,
            isStop: isStop,
            //&&(widget.mUUid==widget.mMessage.uuid)
          ),
        );
        break;
      default:
        return Text("null");
        break;
    }
  }

  /*playLocal() async {
    int result = await mAudioPlayer.play((widget.mMessage as HrlVoiceMessage).path, isLocal: true);
    //  int result = await mAudioPlayer.play("https://github.com/luanpotter/audioplayers");
    print("播放的路径："+"${(widget.mMessage as HrlVoiceMessage).path}"+"播放的结果:"+"${result}");
    mAudioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
         isPalying = false;
       });
    });
    setState(() {
      isPalying = true;
    });
  }*/

  BubbleStyle getItemBundleStyle(EMMessage mMessage) {
    BubbleStyle styleSendText = BubbleStyle(
      nip: BubbleNip.rightText,
      color: Color(0xffCCEAFF),
      nipOffset: 5,
      nipWidth: 10,
      nipHeight: 10,
      margin: BubbleEdges.only(left: 50.0),
      padding: BubbleEdges.only(top: 8, bottom: 10, left: 15, right: 10),
    );
    BubbleStyle styleSendImg = BubbleStyle(
      nip: BubbleNip.noRight,
      color: Colors.transparent,
      nipOffset: 5,
      nipWidth: 10,
      nipHeight: 10,
      margin: BubbleEdges.only(left: 50.0),
    );

    BubbleStyle styleReceiveText = BubbleStyle(
      nip: BubbleNip.leftText,
      color: Colors.white,
      nipOffset: 5,
      nipWidth: 10,
      nipHeight: 10,
      margin: BubbleEdges.only(right: 50.0),
      padding: BubbleEdges.only(top: 8, bottom: 10, left: 10, right: 15),
    );

    BubbleStyle styleReceiveImg = BubbleStyle(
      nip: BubbleNip.noLeft,
      color: Colors.transparent,
      nipOffset: 5,
      nipWidth: 10,
      nipHeight: 10,
      margin: BubbleEdges.only(left: 50.0),
    );

    switch (mMessage.body.type) {
      case MessageType.IMAGE:
        //return widget.mMessage!.isSend! ? styleSendImg : styleReceiveImg;
        return widget.mMessage!.direction==MessageDirection.SEND ? styleSendImg : styleReceiveImg;
        break;
      case MessageType.TXT:
        //return widget.mMessage!.isSend! ? styleSendText : styleReceiveText;
        return widget.mMessage!.direction==MessageDirection.SEND ?  styleSendText : styleReceiveText;
        break;
      case MessageType.VOICE:
       // return widget.mMessage!.isSend! ? styleSendText : styleReceiveText;
        return widget.mMessage!.direction==MessageDirection.SEND ? styleSendText : styleReceiveText;
        break;
      default:
        return styleReceiveText;
        break;
    }
  }

  Widget getSentMessageLayout() {
    return Container(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Visibility(
              // visible: widget.mMessage?.msgType==HrlMessageType.voice,
              // child:  Container(
              //   child:  widget.mMessage?.msgType==HrlMessageType.voice?Text((widget.mMessage as HrlVoiceMessage).duration.toString()+"'",style: TextStyle(fontSize: 14,color: Colors.black),):new Container(),
              // ),
              visible: widget.mMessage?.body?.type==MessageType.VOICE,
              child:  Container(
                //child:  widget.mMessage?.msgType==HrlMessageType.voice?Text((widget.mMessage as HrlVoiceMessage).duration.toString()+"'",style: TextStyle(fontSize: 14,color: Colors.black),):new Container(),
                child:  widget.mMessage?.body?.type==MessageType.VOICE?Text((widget.mMessage?.body as EMVoiceMessageBody).duration.toString()+"'",style: TextStyle(fontSize: 14,color: Colors.black),):new Container(),
              ),
            ),


            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: Bubble(
                style: getItemBundleStyle(widget.mMessage!),
                // child:    Text(  '${(widget.mMessage as HrlTextMessage).text  }',  softWrap: true,style: TextStyle(fontSize: 14.0,color: Colors.black),),
                child: getItemContent(widget.mMessage!),
              ),
              margin: EdgeInsets.only(
                bottom: 5.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 5),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://c-ssl.duitang.com/uploads/item/201208/30/20120830173930_PBfJE.thumb.700_0.jpeg"),
                radius: 16.0,
              ),
            ),
          ],
        ));
  }

  Widget getReceivedMessageLayout() {
    return Container(
        alignment: Alignment.centerLeft,
        child: Row(
          //  mainAxisAlignment:MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 5.0, left: 10),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://c-ssl.duitang.com/uploads/item/201208/30/20120830173930_PBfJE.thumb.700_0.jpeg"),
                radius: 16.0,
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child:  Bubble(
                style: getItemBundleStyle(widget.mMessage!),
                child: getItemContent(widget.mMessage!),
              ),

              margin: EdgeInsets.only(
                bottom: 5.0,
              ),
            ),
          ],
        ));
  }
}
