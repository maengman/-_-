import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Data/API.dart';
import '../../refector.dart';
import 'package:expandable_text/expandable_text.dart';

import '../MainPage/Post_Detail.dart';

class My_Like extends StatefulWidget {
  const My_Like({
    super.key,
    required this.posts,
  });
  final List posts;
  @override
  State<My_Like> createState() => _My_LikeState();
}

class _My_LikeState extends State<My_Like> {
  late List posts;
  String serverip = api_connect.image_serverip.toString() + "/images/";
  List images = [];
  List state = [];
  PageController _pagecontroller = PageController();
  int onPageChanged = 0;
  SharedPreferences? preferences;
  List<String> likeList = [];
  String like = "0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      posts = widget.posts;
      for (var i = 0; i < posts[3][0][5].toString().split(',').length; i++) {
        images.add(posts[3][0][5].toString().split(',')[i]);
      }
      like = posts[3][0][4].toString();
      getImageSize(images);
    });
  }

  Future<void> loadItems() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      likeList = preferences!.getStringList('post_like') ?? [];
    });
    // print(likeList);
  }

  Future<void> saveItems() async {
    await preferences!.setStringList('post_like', likeList);
  }

  void deleteLike(String post_number) {
    if (post_number.isNotEmpty) {
      setState(() {
        likeList.remove(post_number);
      });
      saveItems();
    }
  }

  Future<void> getImageSize(List url) async {
    int imageWidth = 0;
    int imageHeight = 0;
    for (var i = 0; i < url.length; i++) {
      final file = await DefaultCacheManager().getSingleFile(serverip + url[i]);
      final image = img.decodeImage(file.readAsBytesSync());

      if (image != null) {
        imageWidth = image.width;
        imageHeight = image.height;
        if (imageWidth > imageHeight) {
          state.add(true);
        } else {
          state.add(false);
        }
      }
    }
    print(state);
    setState(() {});
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Icon(Icons.account_circle_outlined),
              SizedBox(
                width: 10,
              ),
              Text(
                posts[3][0][3],
                style: textStyle(20, Colors.black, FontWeight.w600, 1.0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAspectRatio(BuildContext context) {
    // 이미지의 가로와 세로 크기에 따라 AspectRatio 조정
    return AspectRatio(
      aspectRatio: state[onPageChanged] ? 4 / 3 : 3 / 4,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          PageView(
            controller: _pagecontroller,
            onPageChanged: (value) {
              setState(() {
                onPageChanged = value;
                print(state[onPageChanged]);
                print(onPageChanged);
              });
            },
            children: List.generate(
              images.length,
              (index) {
                return Image.network(
                  serverip + images[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              ((onPageChanged + 1).toString() + "/" + images.length.toString()),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _info_count(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
        children: [
          Text(
            "좋아요 : " + (like),
            style: textStyle(
                17, Color.fromARGB(255, 77, 77, 77), FontWeight.normal, 1.0),
          ),
          SizedBox(
            width: 30,
          ),
          Text(
            "댓글 : " + (posts.last),
            style: textStyle(
                17, Color.fromARGB(255, 77, 77, 77), FontWeight.normal, 1.0),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExpandableText(
            //3줄이상 작성시 접히는 부분
            posts[3][0][2], //내용
            //prefixText: _posts[5], //내용앞에 작성되는 부분 ex)아이디 닉네임
            prefixStyle: TextStyle(fontWeight: FontWeight.bold), //닉네임 스타일
            expandText: '더보기', //접힐떄 텍스트
            collapseText: '접기', //다시 필때 텍스트
            maxLines: 2, //처음화면에 보이는 라인 개수 닉네임 포함
            expandOnTextTap: true, //글 클릭시 더보기 확장
            collapseOnTextTap: true, //글 클릭시 더보기 접기
            linkColor: Colors.grey, //더보기 색상
            // onPrefixTap: () {
            //   print('test');
            // }, //닉네임 클릭시 이동
            style: textStyle(18, Colors.black, FontWeight.normal, 1.0),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (state.isEmpty)
          Container(
            height: MediaQuery.of(context).size.height * 0.68,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else
          Center(
            child: Column(
              children: [
                Container(
                  width: 400,
                  height: state[onPageChanged] ? 380 : 540,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // 테두리 색상
                      width: 1.0, // 테두리 두께
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _header(),
                      _buildAspectRatio(context),
                      // // _info(context),
                      _info_count(context),
                      Flexible(
                          child: SingleChildScrollView(child: _body(context))),
                      // //_infocount(context),
                      // //if (_posts[2] != " ") _body(context),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // ElevatedButton(onPressed: () {}, child: Text("수정하기")),
                    ElevatedButton(
                      onPressed: () async {
                        print(posts[3][0]);
                        List post_detail = await api_connect.GetPost(
                            "POST", posts[3][0][0].toString());
                        print(post_detail[0]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Post_Detail(
                              post: post_detail[0],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "바로가기",
                        style:
                            textStyle(18, Colors.black, FontWeight.normal, 1.0),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(130, 40),
                          backgroundColor: Colors.grey[400]),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await loadItems();
                        print(posts[3][0][4].toString());
                        deleteLike(posts[3][0][0].toString());
                        await api_connect.post_like(
                            posts[3][0][0].toString(), "un_like");

                        setState(() {
                          like = (int.parse(like) - 1).toString();
                        });
                        //좋아요 취소
                      },
                      child: Text(
                        "좋아요 취소",
                        style:
                            textStyle(18, Colors.black, FontWeight.normal, 1.0),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(130, 40),
                          backgroundColor: Colors.grey[400]),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
