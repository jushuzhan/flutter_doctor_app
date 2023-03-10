import 'dart:core';
class IdCardUtil {
  String idCardNum;
  /**
   * 构造方法。
   *
   * @param idCardNum
   */
  IdCardUtil(this.idCardNum) {
    this.idCardNum = idCardNum.trim();
    if(this.idCardNum.isNotEmpty){
      this.idCardNum = this.idCardNum.replaceAll("x", "X");
    }
  }

  static int IS_EMPTY = 1;
  static int LEN_ERROR = 2;
  static int CHAR_ERROR = 3;
  static int DATE_ERROR = 4;
  static int CHECK_BIT_ERROR = 5;
   List<String> errMsgList=<String>['身份证完全正确！','身份证为空！','身份证长度不正确！','身份证有非法字符！','身份证中出生日期不合法！','身份证校验位错误！'];


   int error = 0;



   String getIdCardNum() {
    return idCardNum;
  }

   void setIdCardNum(String idCardNum) {
    this.idCardNum = idCardNum;
    if (this.idCardNum.isNotEmpty) {
      this.idCardNum = this.idCardNum.replaceAll("x", "X");
    }
  }

  /**
   * 得到身份证详细错误信息。
   *
   * @return 错误信息。
   */
   String getErrMsg() {
    return this.errMsgList[this.error];
  }

  /**
   * 是否为空。
   *
   * @return true: null  false: not null;
   */
  bool isEmpty() {
    if (this.idCardNum == null)
      return true;
    else
      return this.idCardNum.trim().length<= 0;
  }

  /**
   * 身份证长度。
   *
   * @return
   */
   int getLength() {
    return this.isEmpty() ? 0 : this.idCardNum.length;
  }

  /**
   * 身份证长度。
   *
   * @return
   */
   int getLengthByStr(String str) {
    return this.isEmpty() ? 0 : str.length;
  }

  /**
   * 是否是15位身份证。
   *
   * @return true: 15位  false：其他。
   */
  bool is15() {
    return this.getLength() == 15;
  }

  /**
   * 是否是18位身份证。
   *
   * @return true: 18位  false：其他。
   */
  bool is18() {
    return this.getLength() == 18;
  }

  /**
   * 得到身份证的省份代码。
   *
   * @return 省份代码。
   */
   String getProvince() {
    return this.isCorrect() == 0 ? this.idCardNum.substring(0, 2) : "";
  }

  /**
   * 得到身份证的城市代码。
   *
   * @return 城市代码。
   */
   String getCity() {
    return this.isCorrect() == 0 ? this.idCardNum.substring(2, 4) : "";
  }

  /**
   * 得到身份证的区县代码。
   *
   * @return 区县代码。
   */
   String getCountry() {
    return this.isCorrect() == 0 ? this.idCardNum.substring(4, 6) : "";
  }

  /**
   * 得到身份证的出生年份。
   *
   * @return 出生年份。
   */
   String getYear() {
    if (this.isCorrect() != 0)
      return "";

    if (this.getLength() == 15) {
      return "19" + this.idCardNum.substring(6, 8);
    } else {
      return this.idCardNum.substring(6, 10);
    }
  }

  /**
   * 得到身份证的出生月份。
   *
   * @return 出生月份。
   */
   String getMonth() {
    if (this.isCorrect() != 0)
      return "";

    if (this.getLength() == 15) {
      return this.idCardNum.substring(8, 10);
    } else {
      return this.idCardNum.substring(10, 12);
    }
  }

  /**
   * 得到身份证的出生日子。
   *
   * @return 出生日期。
   */
   String getDay() {
    if (this.isCorrect() != 0)
      return "";

    if (this.getLength() == 15) {
      return this.idCardNum.substring(10, 12);
    } else {
      return this.idCardNum.substring(12, 14);
    }
  }

  /**
   * 得到身份证的出生日期。
   *
   * @return 出生日期。
   */
   String getBirthday() {
    if (this.isCorrect() != 0)
      return "";

    if (this.getLength() == 15) {
      return "19" + this.idCardNum.substring(6, 12);
    } else {
      return this.idCardNum.substring(6, 14);
    }
  }

  /**
   * 得到身份证的出生年月。
   *
   * @return 出生年月。
   */
   String getBirthMonth() {
    return getBirthday().substring(0, 6);
  }

  /**
   * 得到身份证的顺序号。
   *
   * @return 顺序号。
   */
   String getOrder() {
    if (this.isCorrect() != 0)
      return "";

    if (this.getLength() == 15) {
      return this.idCardNum.substring(12, 15);
    } else {
      return this.idCardNum.substring(14, 17);
    }
  }

  /**
   * 得到性别。
   *
   * @return 性别：1－男  2－女
   */
   String getSex() {
    if (this.isCorrect() != 0)
      return "";
    int p = int.parse(getOrder());
    if (p % 2 == 1) {
      return "男";
    } else {
      return "女";
    }
  }

  /**
   * 得到性别值。
   *
   * @return 性别：1－男  2－女
   */
   String getSexValue() {
    if (this.isCorrect() != 0)
      return "";
    int p = int.parse(getOrder());
    if (p % 2 == 1) {
      return "1";
    } else {
      return "2";
    }
  }

  /**
   * 得到校验位。
   *
   * @return 校验位。
   */
   String getCheck() {
    if (!this.isLenCorrect())
      return "";

    String lastStr = this.idCardNum.substring(this.idCardNum.length - 1);
    if ("x"==lastStr) {
      lastStr = "X";
    }
    return lastStr;
  }

  /**
   * 得到15位身份证。
   *
   * @return 15位身份证。
   */
   String to15() {
    if (this.isCorrect() != 0)
      return "";

    if (this.is15())
      return this.idCardNum;
    else
      return this.idCardNum.substring(0, 6) + this.idCardNum.substring(8, 17);
  }

  /**
   * 得到18位身份证。
   *
   * @return 18位身份证。
   */
   String to18() {
    if (this.isCorrect() != 0)
      return "";

    if (this.is18())
      return this.idCardNum;
    else
      return this.idCardNum.substring(0, 6) + "19" + this.idCardNum.substring(6) + this.getCheckBit();
  }

  /**
   * 得到18位身份证。
   *
   * @return 18位身份证。
   */
   static String toNewIdCard(String tempStr) {
    if (tempStr.length == 18)
      return tempStr.substring(0, 6) + tempStr.substring(8, 17);
    else
      return tempStr.substring(0, 6) + "19" + tempStr.substring(6) + getCheckBitByStr(tempStr);
  }

  /**
   * 校验身份证是否正确
   *
   * @return 0：正确
   */
   int isCorrect() {
    if (this.isEmpty()) {
      this.error = IdCardUtil.IS_EMPTY;
      return this.error;
    }

    if (!this.isLenCorrect()) {
      this.error = IdCardUtil.LEN_ERROR;
      return this.error;
    }

    if (!this.isCharCorrect()) {
      this.error = IdCardUtil.CHAR_ERROR;
      return this.error;
    }

    if (!this.isDateCorrect()) {
      this.error = IdCardUtil.DATE_ERROR;
      return this.error;
    }

    if (this.is18()) {
      if(this.getCheck()!=this.getCheckBit()){
        this.error = IdCardUtil.CHECK_BIT_ERROR;
        return this.error;
      }
    }

    return 0;
  }


  bool isLenCorrect() {
    return this.is15() || this.is18();
  }

  /**
   * 判断身份证中出生日期是否正确。
   *
   * @return
   */
  bool isDateCorrect() {

    /*非闰年天数*/

    List<int> monthDayN=<int>[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    /*闰年天数*/
    List<int> monthDayL = <int>[31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    int month;
    if (this.is15()) {
      month = int.parse(this.idCardNum.substring(8, 10));
    } else {
      month = int.parse(this.idCardNum.substring(10, 12));
    }

    int day;
    if (this.is15()) {
      day = int.parse(this.idCardNum.substring(10, 12));
    } else {
      day = int.parse(this.idCardNum.substring(12, 14));
    }

    if (month > 12 || month <= 0) {
      return false;
    }

    if (this.isLeapyear()) {
      return day <= monthDayL[month - 1] && day > 0;
    } else {
      return day <= monthDayN[month - 1] && day > 0;
    }

  }

  /**
   * 得到校验位。
   *
   * @return
   */
   String getCheckBit() {
    if (!this.isLenCorrect())
      return "";

    String temp;
    if (this.is18())
      temp = this.idCardNum;
    else
      temp = this.idCardNum.substring(0, 6) + "19" + this.idCardNum.substring(6);

     List<String> checkTable=<String>["1", "0", "X", "9", "8", "7", "6", "5", "4", "3", "2"];
    List<int> wi=<int>[7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1];
    int sum = 0;

    for (int i = 0; i < 17; i++) {
    String ch = temp.substring(i, i + 1);
    sum = sum + int.parse(ch) * wi[i];
    }

    int y = sum % 11;

    return checkTable[y];
  }


  /**
   * 得到校验位。
   *
   * @return
   */
   static  String getCheckBitByStr(String str) {

    String temp;
    if (str.length == 18)
      temp = str;
    else
      temp = str.substring(0, 6) + "19" + str.substring(6);


    List<String> checkTable=<String>["1", "0", "X", "9", "8", "7", "6", "5", "4", "3", "2"];
    List<int> wi = <int>[7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1];
    int sum = 0;

    for (int i = 0; i < 17; i++) {
    String ch = temp.substring(i, i + 1);
    sum = sum + int.parse(ch) * wi[i];
    }

    int y = sum % 11;

    return checkTable[y];
  }


  /**
   * 身份证号码中是否存在非法字符。
   *
   * @return true: 正确  false：存在非法字符。
   */
  bool isCharCorrect() {
    bool iRet = true;

    if (this.isLenCorrect()) {
      //转unicode列表
      List<int> temp = this.idCardNum.runes.toList();

      if (this.is15()) {
        for (int i = 0; i < temp.length; i++) {
          if (temp[i] < 48 || temp[i] > 57) {
            iRet = false;
            break;
          }
        }
      }

      if (this.is18()) {
        for (int i = 0; i < temp.length; i++) {
          if (temp[i] < 48 || temp[i] > 57) {
            if (i == 17 && temp[i] != 88) {
              iRet = false;
              break;
            }
          }
        }
      }
    } else {
      iRet = false;
    }
    return iRet;
  }

  /**
   * 判断身份证的出生年份是否未闰年。
   *
   * @return true ：闰年  false 平年
   */
   bool isLeapyear() {
    String temp;
    if (this.is15()) {
      temp = "19" + this.idCardNum.substring(6, 8);
    } else {
      temp = this.idCardNum.substring(6, 10);
    }
    int year = int.parse(temp);

    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }


}
