import 'package:flutter/material.dart';

class Palette {
  static const Color iconColor = Color(0xFFB6C7D1);
  static const Color activeColor = Color(0xFF09126C);
  static const Color textColor1 = Color(0XFFA7BCC7);
  static const Color textColor2 = Color(0XFF9BB3C0);
  static const Color textformColor = Color(0xFF3B5999);
  static const Color googleColor = Color(0xFFDE4B39);
  static const Color snackbarColor = Color.fromARGB(255, 116, 221, 235);
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackbar(
    BuildContext context, text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: textStyle(15, Colors.white, FontWeight.normal, 1.0),
      ),
      backgroundColor: Color.fromARGB(255, 60, 117, 238),
      duration: Duration(milliseconds: 1500),
    ),
  );
}

/**텍스트 스타일 */
TextStyle textStyle(double size, Color color, FontWeight weight, double space) {
  return TextStyle(
    fontSize: size,
    color: color,
    fontWeight: weight,
    letterSpacing: space,
  );
}

InputDecoration textformfieldDecoration(String text, IconData icons) {
  return InputDecoration(
    prefixIcon: Icon(
      //앞에 아이콘 띄워주기
      icons,
      color: Palette.iconColor,
    ),
    enabledBorder: OutlineInputBorder(
      //선택 안됬을때 생김새만들기 아래 코드 없으면 선택이 일자로 변함
      borderSide: BorderSide(
        color: Palette.textformColor,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(35.0),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      //선택 되었을떄 이미지
      borderSide: BorderSide(
        color: Palette.textformColor,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(35.0),
      ),
    ),
    hintText: text, //텍스트폼 안에 글자 힌트
    hintStyle: TextStyle(fontSize: 15, color: Colors.black),
    contentPadding: EdgeInsets.all(10),
  );
}

String obscode(String name) {
  String obscode;
  switch (name) {
    case '감천항':
      obscode = "TW_0088";
      break;
    case '경포대해수욕장':
      obscode = "TW_0089";
      break;
    case '고래불해수욕장':
      obscode = "TW_0095";
      break;
    case '교본초':
      obscode = "DT_0042";
      break;
    case '낙산해수욕장':
      obscode = "TW_0091";
      break;
    case '남해동부':
      obscode = "KG_0025";
      break;
    case '대천해수욕장':
      obscode = "TW_0069";
      break;
    case '망상해수욕장':
      obscode = "TW_0094";
      break;
    case '복사초':
      obscode = "DT_0041";
      break;
    case '상왕등도':
      obscode = "TW_0079";
      break;
    case '생일도':
      obscode = "TW_0081";
      break;
    case '속초해수욕장':
      obscode = "TW_0093";
      break;
    case '송정해수욕장':
      obscode = "TW_0090";
      break;
    case '신안가거초':
      obscode = "IE_0061";
      break;
    case '옹진소청초':
      obscode = "IE_0062";
      break;
    case '왕돌초':
      obscode = "DT_0039";
      break;
    case '우이도':
      obscode = "TW_0080";
      break;
    case '울릉도북서':
      obscode = "KG_0102";
      break;
    case '이어도':
      obscode = "IE_0060";
      break;
    case '임랑해수욕장':
      obscode = "TW_0092";
      break;
    case '제주남부':
      obscode = "KG_0021";
      break;
    case '제주해협':
      obscode = "KG_0028";
      break;
    case '중문해수욕장':
      obscode = "TW_0075";
      break;
    case '해운대해수욕장':
      obscode = "TW_0062";
      break;
    default:
      obscode = "TW_0088";
      break;
  }
  return obscode;
}
