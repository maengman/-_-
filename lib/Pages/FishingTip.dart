// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// // import 'package:image/image.dart' as img;
// // import 'package:my_fishing_log/Data/API.dart';
// // import 'package:my_fishing_log/components/Fishing_Tip/Fishing_tip.dart';
// // import 'package:webview_flutter/webview_flutter.dart';

// // final homeUrl = Uri.parse('https://slds2.tistory.com/3379');
// // final homeUrl2 = Uri.parse('https://www.youtube.com/watch?v=tGeHscDlKMo');

// // class WebApp extends StatefulWidget {
// //   WebApp({super.key});

// //   @override
// //   State<WebApp> createState() => _WebAppState();
// // }

// // class _WebAppState extends State<WebApp> {
// //   late List Fishing_Tip;
// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //   }

// //   Future<String> Fishing_Tip_Data() async {
// //     Fishing_Tip = await api_connect.Fishing_Tip("GET");
// //     print(Fishing_Tip);
// //     return "";
// //   }

// //   Widget _postlist() {
// //     return Column(
// //       children: List.generate(Fishing_Tip.length,
// //           (index) => Fishing_Tip_Post(posts: Fishing_Tip[index])).toList(),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('낚시 팁'),
// //         centerTitle: true,
// //         actions: [],
// //       ),
// //       body: SafeArea(
// //         child: FutureBuilder<String>(
// //           future: Fishing_Tip_Data(), // 비동기 작업을 수행하는 Future 객체
// //           builder: (context, snapshot) {
// //             if (snapshot.connectionState == ConnectionState.waiting) {
// //               // 작업이 아직 완료되지 않았을 때 로딩 인디케이터를 표시
// //               return CircularProgressIndicator();
// //             } else if (snapshot.hasError) {
// //               // 작업 중 오류가 발생한 경우 오류 메시지를 표시
// //               return Text('Error: ${snapshot.error}');
// //             } else {
// //               // 작업이 성공적으로 완료된 경우 결과 데이터를 화면에 표시
// //               return SingleChildScrollView(
// //                   child: Column(
// //                 children: [
// //                   _postlist(),
// //                 ],
// //               ));
// //             }
// //           },
// //         ),
// //       ),

// //       // body: Column(
// //       //   children: [
// //       //     TextButton(
// //       //       onPressed: () {
// //       //         setState(() {
// //       //           controller.loadRequest(homeUrl);
// //       //         });
// //       //         Navigator.push(
// //       //           context,
// //       //           MaterialPageRoute(
// //       //             builder: (context) => WebViewWidget(
// //       //               controller: controller,
// //       //             ),
// //       //           ),
// //       //         );
// //       //         controller.clearCache();
// //       //       },
// //       //       child: Text("asdf"),
// //       //     ),
// //       //     TextButton(
// //       //       onPressed: () {
// //       //         setState(() {
// //       //           controller.loadRequest(homeUrl2);
// //       //         });
// //       //         Navigator.push(
// //       //           context,
// //       //           MaterialPageRoute(
// //       //             builder: (context) => WebViewWidget(
// //       //               controller: controller,
// //       //             ),
// //       //           ),
// //       //         );
// //       //         controller.clearCache();
// //       //       },
// //       //       child: Text("asdf2222"),
// //       //     ),
// //       //   ],
// //       // ),
// //     );
// //   }
// // }

// import 'package:expandable/expandable.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class WebApp extends StatefulWidget {
//   const WebApp({super.key});

//   @override
//   State<WebApp> createState() => _WebAppState();
// }

// class _WebAppState extends State<WebApp> {
//   // WebViewController? controller0;
//   // WebViewController? controller1;
//   // WebViewController? controller;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   Future<String> fetchData() async {
//     // 비동기 작업을 수행 (예: 네트워크 호출)
//     // await Future.delayed(Duration(seconds: 2)); // 시뮬레이션을 위한 대기 시간
//     // return 'Hello, Flutter!';
//     // test = await api_connect.GetPost();s
//     // print(test);
//     // for (var i = 0; i < webView.length; i++) {
//     //   controller = WebViewController()
//     //     ..canGoBack()
//     //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     //     ..loadRequest(Uri.parse(webView[i][1]));
//     //   // await Future.delayed(Duration(milliseconds: 20));
//     //   // String? title = await controller!.getTitle();
//     //   // print(title! + " 123456789");
//     // }
//     return "";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("낚시팁"),
//       ),
//       body: Center(
//         child: FutureBuilder<String>(
//           future: fetchData(), // 비동기 작업을 수행하는 Future 객체
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               // 작업이 아직 완료되지 않았을 때 로딩 인디케이터를 표시
//               return CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               // 작업 중 오류가 발생한 경우 오류 메시지를 표시
//               return Text('Error: ${snapshot.error}');
//             } else {
//               // 작업이 성공적으로 완료된 경우 결과 데이터를 화면에 표시
//               return SafeArea(
//                 child: Container(
//                   margin: EdgeInsets.all(4),
//                   child: GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2, // 열의 개수
//                       crossAxisSpacing: 8.0, // 열 간의 간격
//                       mainAxisSpacing: 8.0, // 행 간의 간격
//                     ),
//                     itemCount: webView.length, // 아이템의 개수
//                     itemBuilder: (BuildContext context, int index) {
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             controller!.clearCache();
//                             controller!
//                                 .loadRequest(Uri.parse(webView[index][1]));
//                           });
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => WebViewWidget(
//                                 controller: controller!,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           width: 300,
//                           height: 140,
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.black, // 테두리 색상
//                               width: 1.0, // 테두리 두께
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Image.network(webView[index][2]),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }

//   List webView = [
//     [
//       "입질의 추억 블로그",
//       "https://slds2.tistory.com/category/%EB%82%9A%EC%8B%9C%ED%8C%81%20",
//       "https://i.namu.wiki/i/DyrwBbg8S-V0piXztSDsbe7UEVO4Dgww1gusqy6nna-WwLfauuIRIxk_6FO0rWhZ9t-Y3PFCKwqK5PeK2lY-ArERjJp7PC5cKZoM6qgiyfeqhxG-QkIAttrsskxQC6rqUyGaLtmvf1I6w9h6SIDHJw.webp"
//     ],
//     [
//       "입질의 추억 유튜브",
//       "https://www.youtube.com/watch?v=7N3NPCRVF7c",
//       "https://yt3.ggpht.com/WL9S50N8LJyXSNnsyMU7d7jAfrjvqKTPit3YLC9LxFONsp9-l7N9tXZAsYCATNfNfzPlhaAx=s176-c-k-c0x00ffffff-no-rj-mo"
//     ],
//     [
//       "박진철 프로 유튜브",
//       "https://www.youtube.com/watch?v=03e_XHt3IHI&t=1s",
//       "https://yt3.ggpht.com/4IcD1Fmw4-FvTV8roQyfucqK4krmWSO7UPe5B5OEj8_DBDHE4gdJGCyqAmi6ENJIFZ-HX1Ls5RY=s176-c-k-c0x00ffffff-no-rj-mo"
//     ],
//   ];
// }

import 'package:expandable/expandable.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../refector.dart';

class WebApp extends StatefulWidget {
  const WebApp({super.key});

  @override
  State<WebApp> createState() => _WebAppState();
}

class _WebAppState extends State<WebApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<String> fetchData() async {
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("낚시팁"),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: fetchData(), // 비동기 작업을 수행하는 Future 객체
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 작업이 아직 완료되지 않았을 때 로딩 인디케이터를 표시
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // 작업 중 오류가 발생한 경우 오류 메시지를 표시
              return Text('Error: ${snapshot.error}');
            } else {
              // 작업이 성공적으로 완료된 경우 결과 데이터를 화면에 표시
              return SafeArea(
                child: Container(
                  margin: EdgeInsets.all(4),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 열의 개수
                      crossAxisSpacing: 3.0, // 열 간의 간격
                      mainAxisSpacing: 3.0, // 행 간의 간격
                    ),
                    itemCount: webView.length, // 아이템의 개수
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          print(index);
                          Navigator.push(
                            context,
                            await MaterialPageRoute(
                              builder: (context) => InAppWebView(
                                initialUrlRequest: URLRequest(
                                  url: Uri.parse(webView[index][1]),
                                ),
                                initialOptions: InAppWebViewGroupOptions(
                                    android: AndroidInAppWebViewOptions(
                                        useHybridComposition: true)),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black, // 테두리 색상
                              width: 1.0, // 테두리 두께
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 100,
                                child: Image.network(webView[index][2]),
                              ),
                              Flexible(
                                child: SingleChildScrollView(
                                  child: ExpandableText(
                                    //3줄이상 작성시 접히는 부분
                                    webView[index][3], //내용
                                    prefixText: webView[index]
                                        [0], //내용앞에 작성되는 부분 ex)아이디 닉네임
                                    prefixStyle: TextStyle(
                                        fontWeight: FontWeight.bold), //닉네임 스타일
                                    expandText: '더보기', //접힐떄 텍스트
                                    collapseText: '접기', //다시 필때 텍스트
                                    maxLines: 1, //처음화면에 보이는 라인 개수 닉네임 포함
                                    expandOnTextTap: true, //글 클릭시 더보기 확장
                                    collapseOnTextTap: true, //글 클릭시 더보기 접기
                                    linkColor: Colors.grey, //더보기 색상
                                    // onPrefixTap: () {
                                    //   print('test');
                                    // }, //닉네임 클릭시 이동
                                    style: textStyle(20, Colors.black,
                                        FontWeight.normal, 1.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  List webView = [
    [
      "입질의 추억 블로그",
      "https://slds2.tistory.com/category/%EB%82%9A%EC%8B%9C%ED%8C%81%20",
      "https://yt3.ggpht.com/WL9S50N8LJyXSNnsyMU7d7jAfrjvqKTPit3YLC9LxFONsp9-l7N9tXZAsYCATNfNfzPlhaAx=s176-c-k-c0x00ffffff-no-rj-mo",
      "입질의 추억에 오신 여러분 환영합니다!"
    ],
    [
      "입질의 추억 유튜브",
      "https://www.youtube.com/watch?v=7N3NPCRVF7c",
      "https://yt3.ggpht.com/WL9S50N8LJyXSNnsyMU7d7jAfrjvqKTPit3YLC9LxFONsp9-l7N9tXZAsYCATNfNfzPlhaAx=s176-c-k-c0x00ffffff-no-rj-mo",
      "지금까지는 '어류 칼럼니스트'란 직업으로 글 활동을 했습니다. 저는 우리나라가 세계적인 수산 강국이 되었으면 하는 희망을 가지면서, 지금보다는 더 많은 사람이 제 영상을 통해 수산물을 쉽고 친근하게 접했으면 좋겠습니다. 앞으로도 몇 권의 수산물 서적을 집필할 예정이며, 책과 영상을 통해 다른 채널에선 볼 수 없는 쉽고 재미있는 수산물 이야기를 전해 드리겠습니다. 앞으로 많은 성원과 구독 부탁드리며, 항상 노력하는 입질의 추억이 되겠습니다."
    ],
    [
      "박진철 프로 유튜브",
      "https://www.youtube.com/watch?v=03e_XHt3IHI&t=1s",
      "https://yt3.ggpht.com/4IcD1Fmw4-FvTV8roQyfucqK4krmWSO7UPe5B5OEj8_DBDHE4gdJGCyqAmi6ENJIFZ-HX1Ls5RY=s176-c-k-c0x00ffffff-no-rj-mo",
      "도시어부 박진철프로 공식 유튜브 채널입니다."
    ],
  ];
}
