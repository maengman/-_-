import 'package:flutter/material.dart';
import '../Data/API.dart';
import '../Data/UserInfo.dart';
import '../components/MainPage/MainPost.dart';
import '../components/MainPage/NewCamera.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

//여기서 뭔가 오류 있음 확인할것
class _MainScreenState extends State<MainScreen> {
  void initState() {
    // TODO: implement initState
    setState(() {
      loadItems();
    });
    super.initState();
  }

  List<String> likeList = [];
  SharedPreferences? preferences;
  List? posts;

  Future<String> fetchData() async {
    posts = await api_connect.GetPost("GET", "");

    return posts.toString();
  }

  Future<void> loadItems() async {
    preferences = await SharedPreferences.getInstance();
    List<String> test = await api_connect.like_load();
    print(test.toString() + " asdf");
    setState(() {
      likeList = test;
    });
    print(likeList);
    saveItems();
    print(likeList);
  }

  Future<void> saveItems() async {
    await preferences!.setStringList('post_like', likeList);
  }

  Widget _postlist() {
    return Column(
      children: List.generate(
          posts!.length, (index) => Post_widget(posts: posts![index])).toList(),
    );
  }

  Future<void> _onRefresh() async {
    // TODO: 데이터를 새로고침
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<void>(
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
              return Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView(
                      children: [
                        _postlist(),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.02,
                    right: MediaQuery.of(context).size.width * 0.02,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraPage(),
                          ),
                        );
                      },
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}



  // body: Center(
  //       child: FutureBuilder<void>(
  //         future: fetchData(), // 비동기 작업을 수행하는 Future 객체
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             // 작업이 아직 완료되지 않았을 때 로딩 인디케이터를 표시
  //             return CircularProgressIndicator();
  //           } else if (snapshot.hasError) {
  //             // 작업 중 오류가 발생한 경우 오류 메시지를 표시
  //             return Text('Error: ${snapshot.error}');
  //           } else {
  //             // 작업이 성공적으로 완료된 경우 결과 데이터를 화면에 표시
  //             return Stack(
  //               children: [
  //                 RefreshIndicator(
  //                   onRefresh: _onRefresh,
  //                   child: ListView(
  //                     children: [
  //                       _postlist(),
  //                     ],
  //                   ),
  //                 ),
  //                 Positioned(
  //                   bottom: MediaQuery.of(context).size.height * 0.02,
  //                   right: MediaQuery.of(context).size.width * 0.02,
  //                   child: FloatingActionButton(
  //                     onPressed: () {
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => CameraPage(),
  //                         ),
  //                       );
  //                     },
  //                     child: Icon(Icons.add),
  //                   ),
  //                 ),
  //               ],
  //             );
  //           }
  //         },
  //       ),
  //     ),

//   int _total = 5;
//   List? test;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     //loadPosts();
//   }

//   Future<void> loadPosts() async {
//     test = await api_connect.GetPost();
//   }

//   // Widget _postlist() {
//   //   return Column(
//   //     children: List.generate(_total, (index) => Post_widget()).toList(),
//   //   );
//   // }

//   Future<void> _onRefresh() async {
//     // TODO: 데이터를 새로고침
//     await Future.delayed(Duration(seconds: 1));
//     setState(() {
//       _total += 5;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         RefreshIndicator(
//           onRefresh: _onRefresh,
//           child: ListView(
//             children: [
//               //_postlist(),
//             ],
//           ),
//         ),
//         Positioned(
//           bottom: MediaQuery.of(context).size.height * 0.02,
//           right: MediaQuery.of(context).size.width * 0.02,
//           child: FloatingActionButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CameraPage(),
//                 ),
//               );
//             },
//             child: Icon(Icons.add),
//           ),
//         ),
//       ],
//     );
//   }
// }
