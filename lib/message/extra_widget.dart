import 'package:flutter/material.dart';
import '../common/constants/constants.dart';

import 'package:image_picker/image_picker.dart';

import 'extra_item.dart';


typedef void OnImageSelect(XFile? mImg);


class DefaultExtraWidget extends StatefulWidget {

  final OnImageSelect? onImageSelectBack;

  const DefaultExtraWidget({
    Key? key,
    this.onImageSelectBack,
  }) : super(key: key);




  @override
  _DefaultExtraWidgetState createState() => _DefaultExtraWidgetState();
}

class _DefaultExtraWidgetState extends State<DefaultExtraWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          new Flexible(
            child: createPicitem(),
            flex: 1,
          ),
          new Flexible(
            child: createVediotem(),
            flex: 1,
          ),
          new Flexible(
            child: createFileitem(),
            flex: 1,
          ),
          new Flexible(
            child: createLocationitem(),
            flex: 1,
          ),
        ],
      ),
    );
  }

  ExtraItemContainer createPicitem() => ExtraItemContainer(
    leadingIconPath: ASSETS_IMG + "ic_ctype_file.png",
    leadingHighLightIconPath: ASSETS_IMG + "ic_ctype_file_pre.png",
    text: "相册",
    onTab: () {
      ImagePicker _picker = ImagePicker();
      Future<XFile?> imageFile = _picker.pickImage(source: ImageSource.gallery);
      imageFile.then((result) {
        widget.onImageSelectBack?.call(result);


      });
    },
  );

  ExtraItemContainer createVediotem() => ExtraItemContainer(
    leadingIconPath: ASSETS_IMG + "ic_ctype_video.png",
    leadingHighLightIconPath:
    ASSETS_IMG + "ic_ctype_video_pre.png",
    text: "视频",
    onTab: () {
      print("添加");
    },
  );

  ExtraItemContainer createFileitem() => ExtraItemContainer(
    leadingIconPath: ASSETS_IMG + "ic_ctype_file.png",
    leadingHighLightIconPath: ASSETS_IMG + "ic_ctype_file_pre.png",
    text: "文件",
    onTab: () {
      print("添加");
    },
  );

  ExtraItemContainer createLocationitem() => ExtraItemContainer(
    leadingIconPath: ASSETS_IMG + "ic_ctype_location.png",
    leadingHighLightIconPath:
    ASSETS_IMG + "ic_ctype_loaction_pre.png",
    text: "位置",
    onTab: () {
      print("添加");
    },
  );
}