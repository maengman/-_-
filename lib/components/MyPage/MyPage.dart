// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:my_fishing_log/Data/API.dart';
// import 'package:my_fishing_log/refector.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:image/image.dart' as img;

// class My_Page extends StatefulWidget {
//   const My_Page({
//     super.key,
//     required this.posts,
//   });
//   final List posts;
//   @override
//   State<My_Page> createState() => _My_PageState();
// }

// class _My_PageState extends State<My_Page> {
//   String serverip = api_connect.image_serverip.toString() + "/images/";
//   //String serverip = "http://10.101.244.47:8000/";
//   late List _posts;
//   List images = [];
//   PageController _pagecontroller = PageController();
//   int onPageChanged = 0;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     setState(() {
//       _posts = widget.posts;
//       images.add(_posts[4].toString().split(','));
//       print(images[0]);
//     });
//   }

//   Widget _image(BuildContext context) {
//     return FutureBuilder<List>(
//       // 이미지 크기를 비동기로 가져오기
//       future: getImageSize(images[0]),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // 크기를 가져오는 중이면 로딩 인디케이터를 표시
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           // 에러가 발생하면 에러 메시지를 표시
//           return Text('Error: ${snapshot.error}');
//         } else {
//           // 크기를 성공적으로 가져오면 AspectRatio로 이미지 표시
//           return _buildAspectRatio(context, snapshot.data!);
//         }
//       },
//     );
//   }

//   Widget _buildAspectRatio(BuildContext context, List data) {
//     // 이미지의 가로와 세로 크기에 따라 AspectRatio 조정
//     return AspectRatio(
//       aspectRatio: data[onPageChanged] ? 4 / 3 : 3 / 4,
//       child: Stack(
//         alignment: Alignment.topRight,
//         children: [
//           PageView(
//             controller: _pagecontroller,
//             onPageChanged: (value) {
//               setState(() {
//                 onPageChanged = value;
//                 print(data[onPageChanged]);
//                 print(onPageChanged);
//                 print(serverip + images[0][0]);
//               });
//             },
//             children: List.generate(
//               images[0].length,
//               (index) {
//                 return Image.network(
//                   serverip + images[0][index],
//                   fit: BoxFit.cover,
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//             margin: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.5),
//               borderRadius: BorderRadius.circular(50),
//             ),
//             child: Text(
//               ((onPageChanged + 1).toString() +
//                   "/" +
//                   images[0].length.toString()),
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<List> getImageSize(List url) async {
//     List state = [];
//     int imageWidth = 0;
//     int imageHeight = 0;
//     for (var i = 0; i < url.length; i++) {
//       final file = await DefaultCacheManager().getSingleFile(serverip + url[i]);
//       final image = img.decodeImage(file.readAsBytesSync());

//       if (image != null) {
//         imageWidth = image.width;
//         imageHeight = image.height;
//         if (imageWidth > imageHeight) {
//           state.add(true);
//         } else {
//           state.add(false);
//         }
//       }
//     }
//     print(state);
//     return state;
//   }

//   Widget _header() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Row(
//             children: [
//               Icon(Icons.account_circle_outlined),
//               SizedBox(
//                 width: 10,
//               ),
//               Text(
//                 _posts[3],
//                 style: textStyle(20, Colors.black, FontWeight.w600, 1.0),
//               ),
//             ],
//           ),
//         ),
//         // IconButton(
//         //   onPressed: () {},
//         //   icon: Icon(
//         //     Icons.bookmark_outlined,
//         //     color: Colors.blue[300],
//         //   ),
//         // ),
//       ],
//     );
//   }

//   // Widget _image(BuildContext context, bool Data) {
//   //   return AspectRatio(
//   //     aspectRatio: Data ? 4 / 3 : 3 / 4,
//   //     child: Stack(
//   //       alignment: Alignment.topRight,
//   //       children: [
//   //         PageView(
//   //           controller: _pagecontroller,
//   //           onPageChanged: (value) async {
//   //             setState(() {
//   //               print(serverip + images[0][value]);
//   //               onPageChanged = value;
//   //             });
//   //           },
//   //           children: List.generate(
//   //             images[0].length,
//   //             (index) {
//   //               return Container(
//   //                 child: Image.network(
//   //                   serverip + images[0][index],
//   //                   fit: BoxFit.cover,
//   //                 ),
//   //               );
//   //             },
//   //           ),
//   //         ),
//   //         Container(
//   //           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//   //           margin: EdgeInsets.all(10),
//   //           decoration: BoxDecoration(
//   //               color: Colors.black.withOpacity(0.5),
//   //               borderRadius: BorderRadius.circular(50)),
//   //           child: Text(
//   //             ((onPageChanged + 1).toString() +
//   //                 "/" +
//   //                 images[0].length.toString()),
//   //             style: TextStyle(color: Colors.white),
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   // Widget _infocount(BuildContext context) {
//   //   return Stack(
//   //     alignment: Alignment.center,
//   //     children: [
//   //       Row(
//   //         children: [
//   //           IconButton(
//   //             onPressed: () {},
//   //             icon: Icon(Icons.star_border),
//   //             iconSize: 30,
//   //           ),
//   //           IconButton(
//   //             onPressed: () {},
//   //             icon: Icon(Icons.chat_outlined),
//   //             iconSize: 30,
//   //           ),
//   //         ],
//   //       ),
//   //       // SmoothPageIndicator(
//   //       //   controller: _pagecontroller,
//   //       //   count: images.length,
//   //       //   effect: WormEffect(
//   //       //     dotColor: Colors.grey,
//   //       //     dotHeight: 10,
//   //       //     dotWidth: 10,
//   //       //     activeDotColor: Colors.black,
//   //       //     type: WormType.thinUnderground,
//   //       //   ),
//   //       // ),
//   //     ],
//   //   );
//   // }

//   // Widget _body(BuildContext context) {
//   //   return Padding(
//   //     padding: const EdgeInsets.all(10.0),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.stretch,
//   //       children: [
//   //         ExpandableText(
//   //           //3줄이상 작성시 접히는 부분
//   //           _posts[2], //내용
//   //           //prefixText: _posts[5], //내용앞에 작성되는 부분 ex)아이디 닉네임
//   //           prefixStyle: TextStyle(fontWeight: FontWeight.bold), //닉네임 스타일
//   //           expandText: '더보기', //접힐떄 텍스트
//   //           collapseText: '접기', //다시 필때 텍스트
//   //           maxLines: 3, //처음화면에 보이는 라인 개수 닉네임 포함
//   //           expandOnTextTap: true, //글 클릭시 더보기 확장
//   //           collapseOnTextTap: true, //글 클릭시 더보기 접기
//   //           linkColor: Colors.grey, //더보기 색상
//   //           // onPrefixTap: () {
//   //           //   print('test');
//   //           // }, //닉네임 클릭시 이동
//   //           style: textStyle(18, Colors.black, FontWeight.normal, 1.0),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: 1000,
//           height: 300,
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Colors.black, // 테두리 색상
//               width: 1.0, // 테두리 두께
//             ),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Column(
//             children: [
//               _header(),
//               // FutureBuilder<bool>(
//               //   future: getImageSize(
//               //       serverip + images[0][0]), // 비동기 작업을 수행하는 Future 객체
//               //   builder: (context, snapshot) {
//               //     if (snapshot.connectionState == ConnectionState.waiting) {
//               //       // 작업이 아직 완료되지 않았을 때 로딩 인디케이터를 표시
//               //       return CircularProgressIndicator();
//               //     } else if (snapshot.hasError) {
//               //       // 작업 중 오류가 발생한 경우 오류 메시지를 표시
//               //       return Text('Error: ${snapshot.error}');
//               //     } else {
//               //       // 작업이 성공적으로 완료된 경우 결과 데이터를 화면에 표시
//               //       return _image(context, snapshot.data!);
//               //     }
//               //   },
//               // ),
//               Flexible(
//                 child: SingleChildScrollView(
//                   child: _image(context),
//                 ),
//               ),
//               //_infocount(context),
//               //if (_posts[2] != " ") _body(context),
//             ],
//           ),
//         ),
//       ],
//     );
//     // FutureBuilder<String>(
//     //   future: getImageSize(), // 비동기 작업을 수행하는 Future 객체
//     //   builder: (context, snapshot) {
//     //     if (snapshot.connectionState == ConnectionState.waiting) {
//     //       // 작업이 아직 완료되지 않았을 때 로딩 인디케이터를 표시
//     //       return CircularProgressIndicator();
//     //     } else if (snapshot.hasError) {
//     //       // 작업 중 오류가 발생한 경우 오류 메시지를 표시
//     //       return Text('Error: ${snapshot.error}');
//     //     } else {
//     //       // 작업이 성공적으로 완료된 경우 결과 데이터를 화면에 표시
//     //       return _image(context);
//     //     }
//     //   },
//     // );
//   }
// }

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:my_fishing_log/Data/API.dart';
import 'package:my_fishing_log/components/MainPage/Post_Detail.dart';
import 'package:my_fishing_log/refector.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

import '../../Pages/MyPage.dart';

class My_Page extends StatefulWidget {
  const My_Page({
    super.key,
    required this.posts,
  });
  final List posts;
  @override
  State<My_Page> createState() => _My_PageState();
}

class _My_PageState extends State<My_Page> {
  String serverip = api_connect.image_serverip.toString() + "/images/";
  //String serverip = "http://10.101.244.47:8000/";
  late List _posts;
  List images = [];
  PageController _pagecontroller = PageController();
  int onPageChanged = 0;
  List state = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _posts = widget.posts;
      print(_posts);
      images.add(_posts[5].toString().split(','));

      getImageSize(images[0]);
    });
  }

  // Widget _image(BuildContext context) {
  //   return FutureBuilder<List>(
  //     // 이미지 크기를 비동기로 가져오기
  //     future: getImageSize(images[0]),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         // 크기를 가져오는 중이면 로딩 인디케이터를 표시
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       } else if (snapshot.hasError) {
  //         // 에러가 발생하면 에러 메시지를 표시
  //         return Text('Error: ${snapshot.error}');
  //       } else {
  //         // 크기를 성공적으로 가져오면 AspectRatio로 이미지 표시
  //         return _buildAspectRatio(context, snapshot.data!);
  //       }
  //     },
  //   );
  // }

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
                _posts[3],
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
                print(serverip + images[0][0]);
              });
            },
            children: List.generate(
              images[0].length,
              (index) {
                return Image.network(
                  serverip + images[0][index],
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
              ((onPageChanged + 1).toString() +
                  "/" +
                  images[0].length.toString()),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            print(_posts);
          },
          icon: Icon(Icons.star_border),
          iconSize: 30,
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Post_Detail(post: _posts),
              ),
            );
          },
          icon: Icon(Icons.chat_outlined),
          iconSize: 30,
        ),
      ],
    );
  }

  Widget _info_count(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
        children: [
          Text(
            "좋아요 : " + (_posts[4]),
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
            _posts[2], //내용
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
                      // _info(context),
                      _info_count(context),
                      Flexible(
                          child: SingleChildScrollView(child: _body(context))),
                      //_infocount(context),
                      //if (_posts[2] != " ") _body(context),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // ElevatedButton(onPressed: () {}, child: Text("수정하기")),
                    ElevatedButton(
                      onPressed: () async {
                        List post_detail = await api_connect.GetPost(
                            "POST", _posts[0].toString());
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
                        print(_posts);
                        String result =
                            await api_connect.delete_post(_posts[0].toString());
                        snackbar(context, result);

                        Navigator.pop(context);
                      },
                      child: Text(
                        "삭제하기",
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
