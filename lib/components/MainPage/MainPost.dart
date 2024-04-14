import 'package:flutter/material.dart';
import 'package:my_fishing_log/Data/API.dart';
import 'package:my_fishing_log/components/MainPage/Post_Detail.dart';
import 'package:my_fishing_log/refector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as img;

class Post_widget extends StatefulWidget {
  const Post_widget({
    super.key,
    required this.posts,
  });
  final List posts;
  @override
  State<Post_widget> createState() => _Post_widgetState();
}

class _Post_widgetState extends State<Post_widget> {
  String serverip = api_connect.image_serverip.toString() + "/images/";
  String serverip_profile =
      api_connect.image_serverip.toString() + "/user_profile/";
  //String serverip = "http://10.101.244.47:8000/";
  late List _posts;
  List<String> images = [];
  PageController _pagecontroller = PageController();
  int onPageChanged = 0;
  List images_size = [];
  List aspectio_size = [];
  bool? state;
  Icon like_Icon = Icon(Icons.star_border);
  SharedPreferences? preferences;
  List<String> likeList = [];
  String like = "0";
  String? profile_image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _posts = widget.posts;
      print(_posts);
      print(_posts.length);
      //print(_posts[9]);
      // for (int i = 0; i < 9; i++) {
      //   images!.add(i.toString());
      // }
      like = _posts[7];
      for (int i = 8; i <= _posts.length - 2; i++) {
        images.add(serverip + _posts[i]);

        print(serverip + _posts[i]);
      }
      getImageSize(images[onPageChanged]);
      getprofileImage(_posts[5]);
      loadItems();
      // for (var i = 0; i < images.length; i++) {
      //   getImageSize(images[i]);
      // }
    });
  }

  Future<void> getprofileImage(String nickname) async {
    print(nickname);
    String name = await api_connect.Select_Pfrofile(nickname);
    setState(() {
      profile_image = serverip_profile + name;
      // profile_image =
      //     "https://yt3.googleusercontent.com/f0CZ6JLqRRiYxM49cRcyylAWY0zYfvG07YM3wS8nZG65Y1TfLPcOolpCM3YmpW-GIp3WvqFa3q8=s176-c-k-c0x00ffffff-no-rj";
    });
    print(profile_image);
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

  void addLike(String post_number) {
    if (post_number.isNotEmpty) {
      setState(() {
        likeList.add(post_number);
      });
      saveItems();
    }
  }

  void deleteLike(String post_number) {
    if (post_number.isNotEmpty) {
      setState(() {
        likeList.remove(post_number);
      });
      saveItems();
    }
  }

  // String searchText = '';
  // List<String> searchLike(String text) {
  //   return likeList
  //       .where((item) => item.toLowerCase().contains(text.toLowerCase()))
  //       .toList();
  // }

  Future<void> getImageSize(String url) async {
    int imageWidth = 0;
    int imageHeight = 0;

    final file = await DefaultCacheManager().getSingleFile(url);
    final image = img.decodeImage(file.readAsBytesSync());

    if (image != null) {
      imageWidth = image.width;
      imageHeight = image.height;
    }

    if (imageWidth > imageHeight) {
      state = true;
    } else {
      state = false;
    }
    print(state);
    setState(() {});
  }
  // Future<void> getImageSize(List url) async {
  //   int imageWidth = 0;
  //   int imageHeight = 0;
  //   for (var i = 0; i < url.length; i++) {
  //     final file = await DefaultCacheManager().getSingleFile(url[i]);
  //     final image = img.decodeImage(file.readAsBytesSync());

  //     if (image != null) {
  //       imageWidth = image.width;
  //       imageHeight = image.height;
  //       if (imageWidth > imageHeight) {
  //         state.add(true);
  //       } else {
  //         state.add(false);
  //       }
  //     }
  //   }
  //   print(state);
  //   setState(() {});
  // }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              if (profile_image == "default")
                CircleAvatar(
                  radius: 20,
                  child: Icon(
                    Icons.account_circle_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.grey,
                ),
              if (profile_image != null)
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(profile_image!),
                  backgroundColor: Colors.grey,
                ),
              SizedBox(
                width: 10,
              ),
              Text(
                _posts[5],
                style: textStyle(20, Colors.black, FontWeight.w600, 1.0),
              ),
            ],
          ),
        ),
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.bookmark_outlined,
        //     color: Colors.blue[300],
        //   ),
        // ),
      ],
    );
  }

  Widget _image(BuildContext context) {
    return AspectRatio(
      aspectRatio: state! ? 4 / 3 : 3 / 4,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          PageView(
            controller: _pagecontroller,
            onPageChanged: (value) async {
              setState(() {
                print(value);
                onPageChanged = value;
              });
              await getImageSize(images[onPageChanged]);
            },
            children: List.generate(
              images.length,
              (index) {
                return Container(
                  child: Image.network(
                    images[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(50)),
            child: Text(
              ((onPageChanged + 1).toString() + "/" + images.length.toString()),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(BuildContext context) {
    //List<String> likeItems = searchLike(searchText);
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () async {
                print(_posts[0]);
                await loadItems();
                if (likeList.contains(_posts[0].toString())) {
                  deleteLike(_posts[0].toString());
                  await api_connect.post_like(_posts[0].toString(), "un_like");
                  if (like != 0) {
                    setState(() {
                      like = (int.parse(like) - 1).toString();
                    });
                  } //좋아요 취소

                } else {
                  addLike(_posts[0].toString());
                  await api_connect.post_like(_posts[0].toString(), "like");
                  setState(() {
                    like = (int.parse(like) + 1).toString();
                  });
                }

                print(likeList);
                // final te = await api_connect.post_like(_posts[0].toString());
                // print(te);
                // setState(() {
                //   if (likeItems.contains(_posts[0].toString())) {
                //     // final te =
                //     //     api_connect.post_like(_posts[0].toString(), "un_like");
                //     // print(te);
                //     deleteLike(_posts[0].toString());
                //     if (like != 0) {
                //       like = (int.parse(like) - 1).toString();
                //       //print(like);
                //     }
                //     // (int.parse(like) + 1).toString();
                //   } else {
                //     // final te =
                //     //     api_connect.post_like(_posts[0].toString(), "like");
                //     // print(te);
                //     addLike(_posts[0].toString());
                //     like = (int.parse(like) + 1).toString();
                //     //print(like);
                //   }
                //   // preferences!.clear();
                // });
              },
              icon: likeList.contains(_posts[0].toString())
                  ? Icon(
                      Icons.star,
                      color: Colors.yellow[700],
                    )
                  : Icon(
                      Icons.star_border,
                      color: Colors.black,
                    ),
              iconSize: 30,
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Post_Detail(
                      post: _posts,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.chat_outlined),
              iconSize: 30,
            ),
          ],
        ),
        SmoothPageIndicator(
          controller: _pagecontroller,
          count: images.length,
          effect: WormEffect(
            dotColor: Colors.grey,
            dotHeight: 10,
            dotWidth: 10,
            activeDotColor: Colors.black,
            type: WormType.thinUnderground,
          ),
        ),
        Positioned(
          right: 10,
          child: Text(
            _posts[3],
            style: textStyle(15, Colors.black, FontWeight.normal, 1.0),
          ),
        ),
      ],
    );
  }

  Widget _info_count(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        children: [
          Text(
            "좋아요 : " + like,
            style: textStyle(
                17, Color.fromARGB(255, 77, 77, 77), FontWeight.normal, 1.0),
          ),
          SizedBox(
            width: 30,
          ),
          Text(
            "댓글 : " + (_posts.last),
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
            _posts[4], //내용
            //prefixText: _posts[5], //내용앞에 작성되는 부분 ex)아이디 닉네임
            prefixStyle: TextStyle(fontWeight: FontWeight.bold), //닉네임 스타일
            expandText: '더보기', //접힐떄 텍스트
            collapseText: '접기', //다시 필때 텍스트
            maxLines: 3, //처음화면에 보이는 라인 개수 닉네임 포함
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
    // List<String> likeItems = searchLike(searchText);
    return GestureDetector(
      onTap: () {
        print(_posts);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Post_Detail(
              post: _posts,
            ),
          ),
        );
      },
      child: Column(
        children: [
          _header(),
          if (state == null)
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (state != null) _image(context),
          _info(context),
          _info_count(context),
          if (_posts[4] != " ") _body(context),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
