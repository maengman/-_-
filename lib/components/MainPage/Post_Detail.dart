import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_fishing_log/Data/API.dart';
import 'package:my_fishing_log/Data/UserInfo.dart';
import 'package:my_fishing_log/refector.dart';

class Post_Detail extends StatefulWidget {
  const Post_Detail({super.key, required this.post});
  final List post;
  @override
  State<Post_Detail> createState() => _Post_DetailState();
}

class _Post_DetailState extends State<Post_Detail> {
  String serverip = api_connect.image_serverip.toString() + "/images/";
  late List _post;
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _textController = TextEditingController();
  late LatLng _position;
  List Images = [];
  List comment = [];
  List comment_image = [];
  String serverip_profile =
      api_connect.image_serverip.toString() + "/user_profile/";
  // List test = [
  //   ["name1", "comment1"],
  //   ["name2", "comment2"],
  //   ["name3", "comment3"],
  //   ["name4", "comment4"],
  //   ["name5", "comment5"],
  //   ["name6", "comment6"],
  //   ["name7", "comment7"],
  //   ["name8", "comment8"],
  //   ["name9", "comment9"],
  // ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _post = widget.post;
      _position = LatLng(_post[1], _post[2]);
      for (var i = 8; i < _post.length - 1; i++) {
        Images.add(serverip + _post[i].toString());
      }
      print(Images);
      print(_post);
      fetchData(_post[0].toString());
    });
  }

  Future<void> fetchData(String post_id) async {
    comment = await api_connect.select_post_comment(post_id);
    print(comment);
    for (var i = 0; i < comment.length; i++) {
      await getprofileImage(comment[i][0]);
    }

    setState(() {});
  }

  // Widget _Image() {
  //   return AspectRatio(
  //     aspectRatio: 16 / 9,
  //     child: Image.network(Images[0]),
  //   );
  // }

  Widget _Image() {
    return Container(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 열의 개수
          // crossAxisSpacing: 1.0, // 열 간의 간격
          // mainAxisSpacing: 1.0, // 행 간의 간격
        ),
        itemCount: Images.length, // 아이템의 개수
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            Images[index],
            fit: BoxFit.cover,
            scale: 1.0,
            filterQuality: FilterQuality.high,
          );
        },
      ),
    );
  }

  Widget _Google_Map() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.15,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _position,
          zoom: 18,
        ), //시작점
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },

        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          new Factory<OneSequenceGestureRecognizer>(
            () => new EagerGestureRecognizer(),
          ),
        ].toSet(),

        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId(""),
            position: _position,
          ),
        },
      ),
    );
  }

  Widget User_Text() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                " " + _post[5].toString(),
                style: textStyle(20, Colors.black87, FontWeight.normal, 1.8),
              ),
              Text(
                "/",
                style: textStyle(18, Colors.black87, FontWeight.normal, 1.8),
              ),
              Text(
                _post[3].toString(),
                style: textStyle(18, Colors.black87, FontWeight.normal, 1.8),
              ),
              Text(
                "/",
                style: textStyle(18, Colors.black87, FontWeight.normal, 1.8),
              ),
              Row(
                children: [
                  Icon(
                    Icons.arrow_circle_down,
                    size: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Text(
                    "조행기 ",
                    style:
                        textStyle(20, Colors.black87, FontWeight.normal, 1.8),
                  ),
                ],
              ),
            ],
          ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.01,
          // ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(31, 151, 151, 151),
                  Color.fromARGB(255, 193, 195, 196),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SingleChildScrollView(
              child: Text(
                _post[4].toString(),
                style: textStyle(22, Colors.black, FontWeight.normal, 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _Comment() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                " 댓글",
                style: textStyle(20, Colors.black87, FontWeight.normal, 1.8),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Icon(
                Icons.arrow_circle_down,
                size: 30,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                    comment.length,
                    (index) =>
                        user_Comment(comment[index], comment_image[index]))
                .toList(),
          )
        ],
      ),
    );
  }

  Future<void> getprofileImage(String nickname) async {
    print(nickname);
    String name = await api_connect.Select_Pfrofile(nickname);
    if (name == "default") {
      comment_image.add("");
    } else
      comment_image.add(serverip_profile + name);
    // profile_image =
    //     "https://yt3.googleusercontent.com/f0CZ6JLqRRiYxM49cRcyylAWY0zYfvG07YM3wS8nZG65Y1TfLPcOolpCM3YmpW-GIp3WvqFa3q8=s176-c-k-c0x00ffffff-no-rj";

    print(comment_image);
  }

  Widget user_Comment(List comment, String image) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (image == "")
                CircleAvatar(
                  radius: 25,
                  child: Icon(
                    Icons.account_circle_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.grey,
                ),
              if (image != "")
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(image),
                  backgroundColor: Colors.grey,
                ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment[0],
                    style: textStyle(20, Colors.black, FontWeight.w600, 1.0),
                  ),
                  Text(
                    comment[1],
                    style: textStyle(20, Colors.black, FontWeight.normal, 1.0),
                  ),
                ],
              ),
            ],
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
        ],
      ),
    );
  }

  Widget _Comment_insert() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[200],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(),
          SizedBox(
            width: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              controller: _textController,
              onSubmitted: (String value) async {
                // 사용자가 엔터 키를 눌렀을 때 호출되는 콜백
                // 여기에서 작업을 수행하고 텍스트를 지우려면 다음을 추가합니다.
                String? user_nick = await getUserNick();
                String res = await api_connect.user_post_comment(
                    value.toString(),
                    _post[0].toString(),
                    user_nick!.toString());
                await getprofileImage(user_nick);
                print(res + "asdf");
                setState(() {
                  comment.add([user_nick, value]);
                });
                _textController.clear();
              },
              decoration: InputDecoration(
                labelText: '입력해주세요',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(45)),
              ),
            ),
          ),
          // SizedBox(
          //   width: 30,
          // ),
          // ElevatedButton(
          //     onPressed: () {
          //       print(_textController.text.toString());
          //       setState(() {
          //         // _textController.dispose();
          //       });
          //     },
          //     child: Text("asdf"))
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 80,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: Images.length > 3
                              ? MediaQuery.of(context).size.height * 0.30
                              : MediaQuery.of(context).size.height * 0.15,
                          child: _Image()),
                      _divider(),
                      _Google_Map(),
                      _divider(),
                      User_Text(),
                      _divider(),
                      _Comment(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(bottom: 0, child: _Comment_insert()),
          ],
        ),
        // body: FutureBuilder<void>(
        //   future: fetchData(_post[0].toString()), // 비동기 작업을 수행하는 Future 객체
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       // 작업이 아직 완료되지 않았을 때 로딩 인디케이터를 표시
        //       return CircularProgressIndicator();
        //     } else if (snapshot.hasError) {
        //       // 작업 중 오류가 발생한 경우 오류 메시지를 표시
        //       return Text('Error: ${snapshot.error}');
        //     } else {
        //       // 작업이 성공적으로 완료된 경우 결과 데이터를 화면에 표시
        //       return Stack(
        //         children: [
        //           Positioned(
        //             top: 0,
        //             bottom: 80,
        //             child: Container(
        //               width: MediaQuery.of(context).size.width,
        //               height: MediaQuery.of(context).size.height,
        //               child: SingleChildScrollView(
        //                 child: Column(
        //                   children: [
        //                     Container(
        //                         width: MediaQuery.of(context).size.width,
        //                         height: Images.length > 3
        //                             ? MediaQuery.of(context).size.height * 0.30
        //                             : MediaQuery.of(context).size.height * 0.15,
        //                         child: _Image()),
        //                     _divider(),
        //                     _Google_Map(),
        //                     _divider(),
        //                     User_Text(),
        //                     _divider(),
        //                     _Comment(),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),
        //           Positioned(bottom: 0, child: _Comment_insert()),
        //         ],
        //       );
        //     }
        //   },
        // ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: Colors.black45,
      height: MediaQuery.of(context).size.height * 0.02,
      thickness: 0.4,
    );
  }
}
