import 'package:flutter/material.dart';
import 'package:my_fishing_log/Data/API.dart';
import 'package:my_fishing_log/UserController/profile_change.dart';
import 'package:my_fishing_log/components/MyPage/MyLike.dart';
import 'package:my_fishing_log/refector.dart';
import '../Data/UserInfo.dart' as user_info;
import '../Data/UserInfo.dart';
import '../components/MyPage/MyPage.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String serverip = api_connect.image_serverip.toString() + "/images/";
  String serverip_profile =
      api_connect.image_serverip.toString() + "/user_profile/";
  String? name;
  List data = [];
  List? user_post;
  List? post_like;
  PageController _pagecontroller = PageController();
  int onPageChanged = 0;
  bool post_state = true;
  String? profile;

  Future<bool> fetchData_post() async {
    name = await user_info.getUserNick();
    String? _profile = await user_info.getProfile_Image();
    print(_profile.toString() + "zxcv");
    if (_profile != "default") {
      print(_profile! + " asdf");
      profile = serverip_profile + _profile;
    }

    data = await api_connect.MyPage(name!, "post"); //좋아요 따로 구분해서 가져온다음에 추가해주기
    user_post = data[0];
    post_like = data[1];
    return true;
  }

  // Future<bool> fetchData_post_like() async {
  //   name = await user_info.getUserNick();
  //   user_post =
  //       await api_connect.MyPage(name!, "post_like"); //좋아요 따로 구분해서 가져온다음에 추가해주기
  //   print(user_post);
  //   return false;
  // }

  Future<void> _onRefresh() async {
    // TODO: 데이터를 새로고침
    await Future.delayed(Duration(milliseconds: 1));
    setState(() {});
  }

  Future<void> showCustomDialog(BuildContext context, int index) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            post_state
                ? AlertDialog(
                    content: My_Page(
                        posts: user_post![index]), // 로딩 스피너 또는 진행 상황을 나타내는 위젯
                  )
                : AlertDialog(
                    content: My_Like(
                        posts: post_like![index]), // 로딩 스피너 또는 진행 상황을 나타내는 위젯
                  )
          ],
        );
      },
    );
  }

  Widget header() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(23, 20, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              if (profile == null)
                CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.account_circle_outlined,
                    size: 100,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.grey,
                ),
              if (profile != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profile!),
                  backgroundColor: Colors.grey,
                ),
            ],
          ),
          Column(
            children: [
              Container(
                child: Center(
                  child: Text(
                    "작성글",
                    style: textStyle(20, Colors.black, FontWeight.w500, 1.0),
                  ),
                ),
              ),
              Text(
                user_post!.length.toString(),
                style: textStyle(20, Colors.black, FontWeight.w500, 1.0),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                child: Center(
                  child: Text(
                    "좋아요",
                    style: textStyle(20, Colors.black, FontWeight.w500, 1.0),
                  ),
                ),
              ),
              Text(
                post_like!.length.toString(),
                style: textStyle(20, Colors.black, FontWeight.w500, 1.0),
              ),
            ],
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  Widget info() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(name!,
                style: textStyle(15, Colors.black, FontWeight.w500, 1.0)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  minimumSize: Size(200, 30)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Profile_Change()),
                );
              },
              child: Text(
                "프로필 변경",
                style: textStyle(15, Colors.black, FontWeight.w500, 1.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget post_or_post_like() {
    return Container(
      margin: EdgeInsets.fromLTRB(3, 0, 3, 0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black, // 테두리 색상
          width: 1.0, // 테두리 두께
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        GestureDetector(
          onTap: () {
            setState(() {
              post_state = true;
            });
            print(user_post);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "작성글",
                style: textStyle(20, Colors.black, FontWeight.w500, 1.0),
              ),
              if (post_state == true)
                Container(
                  width: 60,
                  height: 3,
                  color: Palette.activeColor,
                )
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.08,
          width: 2,
          color: Colors.black,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              post_state = false;
            });
            print(post_like!.length);
            print(post_like![0][3][0][5]);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "좋아요",
                style: textStyle(20, Colors.black, FontWeight.w500, 1.0),
              ),
              if (post_state == false)
                Container(
                  width: 60,
                  height: 3,
                  color: Palette.activeColor,
                )
            ],
          ),
        )
      ]),
    );
  }

  Widget _posts(bool post) {
    if (post == true) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 열의 개수
          crossAxisSpacing: 3.0, // 열 간의 간격
          mainAxisSpacing: 3.0, // 행 간의 간격
        ),
        itemCount: user_post!.length, // 아이템의 개수
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              //print(serverip + user_post![index][4].toString().split(',')[0]);
              //showCustomDialog(context, user_post![index][4]);
              showCustomDialog(context, index);
              //print(user_post![index]);
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(4, 13, 4, 0),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black, // 테두리 색상
                  width: 1.0, // 테두리 두께
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(
                  serverip + user_post![index][5].toString().split(',')[0],
                  fit: BoxFit.cover,
                  scale: 0.8,
                  filterQuality: FilterQuality.low,
                ),
              ),
            ),
          );
        },
      );
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 열의 개수
          crossAxisSpacing: 3.0, // 열 간의 간격
          mainAxisSpacing: 3.0, // 행 간의 간격
        ),
        itemCount: post_like!.length, // 아이템의 개수
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              //print(serverip + user_post![index][4].toString().split(',')[0]);
              //showCustomDialog(context, user_post![index][4]);
              showCustomDialog(context, index);
              //print(user_post![index]);
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(4, 13, 4, 0),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black, // 테두리 색상
                  width: 1.0, // 테두리 두께
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(
                  serverip +
                      post_like![index][3][0][5].toString().split(',')[0],
                  fit: BoxFit.cover,
                  scale: 0.8,
                  filterQuality: FilterQuality.low,
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: fetchData_post(), // 비동기 작업을 수행하는 Future 객체
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 작업이 아직 완료되지 않았을 때 로딩 인디케이터를 표시
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 작업 중 오류가 발생한 경우 오류 메시지를 표시
            return Text('Error: ${snapshot.error}');
          } else {
            // 작업이 성공적으로 완료된 경우 결과 데이터를 화면에 표시
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: Column(
                children: [
                  header(),
                  SizedBox(
                    child: info(),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Divider(
                    height: 30,
                    color: Colors.black,
                    thickness: 0.2,
                  ),
                  post_or_post_like(),
                  // Expanded(
                  //   child: ListView(
                  //     children: [
                  //       ListTile(
                  //         title: Text("전체 금어기 확인하기"),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Flexible(child: _posts(post_state)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
