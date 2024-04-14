import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_fishing_log/Pages/MarineScreen.dart';
import 'Data/API.dart';
import 'Data/UserInfo.dart';
import 'Pages/MainScreen.dart';
import 'Pages/Fish_Species_Analysis.dart';
import 'Pages/MyPage.dart';
import 'UserController/Register.dart';
import 'Pages/FishingTip.dart';

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

// final List<Widget> _widgetOptions = [
//   MainScreen(),
//   screen1(),
//   MarineScreen(),
//   screen3(),
// ];

class _AppState extends State<App> {
  late List<Widget> _widgetOptions;
  int _index = 0;
  String serverip_profile =
      api_connect.image_serverip.toString() + "/user_profile/";
  String? profile;
  void checkUserInfo() async {
    final userID = await getUserID();
    final password = await getUserPw();
    if (userID == null && password == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _widgetOptions = [
      MainScreen(),
      Fish_Species_Analysis(),
      MarineScreen(),
      WebApp(),
      MyPage(),
    ];
    checkUserInfo();
    //test();
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      final msg = "'뒤로'버튼을 한 번 더 누르면 종료됩니다.";

      Fluttertoast.showToast(msg: msg);
      return Future.value(false);
    }

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: WillPopScope(
          onWillPop: onWillPop,
          child: SafeArea(
            child: _widgetOptions.elementAt(_index),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black, //선택된 아이콘
        unselectedItemColor: Colors.black, //선택안된거 색상
        type: BottomNavigationBarType.fixed, //선택시 유동 혹은 고정
        showSelectedLabels: true, //선택된 아이콘 라벨
        showUnselectedLabels: false, //선택안된 아이콘 라벨
        currentIndex: _index,
        elevation: 0.0,
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '메인페이지',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.image_search),
            activeIcon: Icon(Icons.image_search),
            label: '어종 분석',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.waves_outlined),
            activeIcon: Icon(Icons.waves),
            label: '바다날씨',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.question_mark),
            activeIcon: Icon(Icons.question_mark),
            label: '낚시팁',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: '마이페이지',
          ),
          // BottomNavigationBarItem(
          //   icon: Container(
          //     width: 30,
          //     height: 30,
          //     child: Column(
          //       children: [
          //         if (profile == null)
          //           CircleAvatar(
          //             radius: 10,
          //             child: Icon(
          //               Icons.account_circle_outlined,
          //               size: 20,
          //               color: Colors.white,
          //             ),
          //             backgroundColor: Colors.grey,
          //           ),
          //         if (profile != null)
          //           CircleAvatar(
          //             radius: 10,
          //             backgroundImage:
          //                 NetworkImage(serverip_profile + profile!),
          //             backgroundColor: Colors.grey,
          //           ),
          //       ],
          //     ),
          //   ),
          //   label: '마이페이지',
          // ),
        ],
      ),
    );
  }
}
