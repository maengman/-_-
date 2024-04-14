// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:my_fishing_log/refector.dart';
// import 'package:multi_image_picker_view/multi_image_picker_view.dart';

// class NewPost extends StatefulWidget {
//   NewPost({super.key, required this.images2});
//   final Iterable<ImageFile> images2;

//   @override
//   State<NewPost> createState() => _NewPostState();
// }

// class _NewPostState extends State<NewPost> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _images = widget.images2;
//   }

//   Iterable<ImageFile> _images = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//         centerTitle: true,
//         actions: [
//           TextButton(
//             onPressed: () {},
//             child: Text(
//               "작성",
//               style: textStyle(15, Colors.black87, FontWeight.w600, 2.0),
//             ),
//           ),
//         ],
//         backgroundColor: Colors.white,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: Container(
//         margin: EdgeInsets.only(
//           top: MediaQuery.of(context).size.height * 0.02,
//         ),
//         padding: EdgeInsets.all(8),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _images.length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         width: 150,
//                         height: 150,
//                         child: Image.file(
//                           File(_images.elementAt(index).path!),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),

//               //사진 공간
//               // Container(
//               //   width: MediaQuery.of(context).size.width * 1.0,
//               //   height: MediaQuery.of(context).size.height * 0.3,
//               //   color: Colors.white,
//               //   child: ListView.builder(
//               //     itemCount: _images.length,
//               //     itemBuilder: (context, index) {
//               //       return Image.file(File(_images.elementAt(index).path!));
//               //     },
//               //   ),
//               // ), //사진 공간
//               // Divider(
//               //   color: Colors.black54,
//               //   height: 15,
//               //   thickness: 1.0,
//               // ),
//               // Container(
//               //   width: MediaQuery.of(context).size.width * 1.0,
//               //   height: MediaQuery.of(context).size.height * 0.2,
//               //   color: Colors.cyan,
//               // ),
//               // Divider(
//               //   color: Colors.black54,
//               //   height: 15,
//               //   thickness: 1.0,
//               // ),
//               // Container(
//               //   width: MediaQuery.of(context).size.width * 1.0,
//               //   height: MediaQuery.of(context).size.height * 0.8,
//               //   color: Colors.blue,
//               // ),
//             ],
//           ),
//         ),
//       ),
//       backgroundColor: Colors.amber,
//     );
//   }
// }

// //  Divider(
// //               height: 15.0,
// //               thickness: 1.0,
// //               color: Colors.white30,
// //             ),

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:my_fishing_log/Data/API.dart';
import 'package:my_fishing_log/Pages/MainScreen.dart';
import 'package:my_fishing_log/app.dart';
import '../../Data/Location.dart';
import '../../refector.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewPost extends StatefulWidget {
  const NewPost(
      {super.key,
      required this.images2,
      required this.latitude,
      required this.longitude,
      required this.userPositon});
  final Iterable<ImageFile> images2;
  final double latitude;
  final double longitude;
  final String userPositon;

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  Iterable<ImageFile> _images = [];
  Completer<GoogleMapController> _controller = Completer();

  String _userText = " ";
  DateTime? date;
  String? _PositionSearch;
  String? _userLocation;
  late LatLng _position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date = DateTime.now();
    _images = widget.images2;
    _position = LatLng(widget.latitude, widget.longitude);
    _userLocation = widget.userPositon;
  }

  void _goToSearchPosition(LatLng SearchPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: SearchPosition,
          zoom: 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              String serverDate =
                  "${date!.year.toString()}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}";
              api_connect.PostUpload(
                _images,
                _position.latitude.toString(),
                _position.longitude.toString(),
                serverDate,
                _userText,
                _userLocation!,
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => App()),
                (route) => false,
              );
              // print(_images);
            }, //서버 전송시 들어갈 것들 기타 아이디 등도 있음
            child: Text(
              "작성",
              style: textStyle(15, Colors.black87, FontWeight.w600, 2.0),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: EdgeInsets.all(8),
          color: Colors.white,
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //사진 나오는 곳 -> 사진 클릭시 확대 이벤트 만들기
                  Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            //클릭시 이미지 확대
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Container(
                                    child: Image.file(
                                      File(_images.elementAt(index).path!),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              child: Image.file(
                                File(_images.elementAt(index).path!),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black45,
                    height: MediaQuery.of(context).size.height * 0.01,
                    thickness: 1.0,
                  ),
                  //날짜,장소
                  Container(
                    width: MediaQuery.of(context).size.width * 1.0,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "날짜와 장소를 선택해주세요",
                          style: textStyle(
                              20, Colors.black87, FontWeight.normal, 1.8),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              //폰트별로 특징이 다를떄 사용
                              text: TextSpan(
                                //텍스트나 문단을 모아서 만들수 있음
                                text: "날짜 : ",
                                style: textStyle(
                                    15, Colors.black, FontWeight.normal, 1.2),
                                children: [
                                  TextSpan(
                                    text:
                                        "${date!.year.toString()}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
                                    style: textStyle(15, Colors.black,
                                        FontWeight.normal, 1.2),
                                  )
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: date!,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                  initialEntryMode:
                                      DatePickerEntryMode.calendarOnly,
                                );
                                if (selectedDate != null) {
                                  setState(() {
                                    date = selectedDate;
                                  });
                                }
                              },
                              child: Text("변경"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                textStyle: textStyle(
                                    15, Colors.black, FontWeight.normal, 1.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "장소 : ",
                              style: textStyle(
                                  15, Colors.black, FontWeight.normal, 1.2),
                            ),
                            Text(
                              // _userPosition!.split('/')[0] +
                              //     _userPosition!.split('/')[1],

                              _userLocation != null &&
                                      _userLocation!.split(' ')[0] != "???" &&
                                      _userLocation!.split(' ').length >= 2
                                  ? _userLocation!.split(' ')[1] +
                                      "/" +
                                      _userLocation!.split(' ')[2]
                                  : _userLocation!.split(" ")[0],
                              // _userPosition!,

                              style: textStyle(
                                  15, Colors.black, FontWeight.normal, 1.2),
                            ),
                            _sizedBox(0.01, null),
                            Icon(Icons.arrow_circle_down),
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.23,
                              child: GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(
                                  target: _position,
                                  zoom: 18,
                                ), //시작점
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },

                                gestureRecognizers:
                                    <Factory<OneSequenceGestureRecognizer>>[
                                  new Factory<OneSequenceGestureRecognizer>(
                                    () => new EagerGestureRecognizer(),
                                  ),
                                ].toSet(),

                                onTap: (argument) async {
                                  String _searchLocationName =
                                      await SearchLocationName(argument);
                                  _goToSearchPosition(argument);
                                  setState(() {
                                    _position = argument;
                                    _userLocation = _searchLocationName;
                                    print(_userLocation!.split(" ").length);
                                  });
                                },

                                zoomGesturesEnabled: true,
                                scrollGesturesEnabled: true,
                                markers: {
                                  Marker(
                                    markerId: const MarkerId(""),
                                    position: _position,
                                  ),
                                },
                              ),
                            ),
                            Positioned(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.17,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "장소를 입력해주세요",
                                                style: textStyle(
                                                    15,
                                                    Colors.black,
                                                    FontWeight.normal,
                                                    1.2),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: TextFormField(
                                                      onChanged: (value) {
                                                        _PositionSearch = value;
                                                      },
                                                    ),
                                                  ),
                                                  OutlinedButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      LatLng _SearchPosition =
                                                          await SearchLocation(
                                                              _PositionSearch!);
                                                      String
                                                          _searchLocationName =
                                                          await SearchLocationName(
                                                              _SearchPosition);
                                                      setState(() {
                                                        _position =
                                                            _SearchPosition;
                                                        _userLocation =
                                                            _searchLocationName;
                                                      });
                                                      _goToSearchPosition(
                                                          _SearchPosition);
                                                    },
                                                    child: Text(
                                                      "확인",
                                                      style: textStyle(
                                                          15,
                                                          Colors.white,
                                                          FontWeight.w500,
                                                          1.0),
                                                    ),
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.black,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text("검색"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    textStyle: textStyle(15, Colors.black,
                                        FontWeight.normal, 1.2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            "(지도를 클릭하시면 마커가 이동합니다)",
                            style: textStyle(
                                15, Colors.black38, FontWeight.normal, 1.2),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black45,
                    height: MediaQuery.of(context).size.height * 0.01,
                    thickness: 1.0,
                  ),
                  //조행기 쓰는곳
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "나의 조행기",
                              style: textStyle(
                                  20, Colors.black87, FontWeight.normal, 1.8),
                            ),
                            _sizedBox(0.01, null),
                            Icon(
                              Icons.arrow_circle_down,
                              size: 30,
                            ),
                          ],
                        ),
                        _sizedBox(null, 0.02),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.5,
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
                          child: TextFormField(
                            key: ValueKey(3),
                            maxLines: null,
                            onChanged: (newValue) {
                              _userText = newValue;
                            },
                            style: textStyle(
                                20, Colors.black, FontWeight.normal, 1.5),
                            decoration: InputDecoration(
                              hintText: '경험을 기록해주세요', //텍스트폼 안에 글자 힌트
                              hintStyle: textStyle(
                                  20, Colors.black26, FontWeight.normal, 1.5),
                              contentPadding: EdgeInsets.all(20),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _sizedBox(double? wid, double? hei) {
    if (wid == null) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * hei!,
      );
    } else if (hei == null) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * wid,
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width * wid,
        height: MediaQuery.of(context).size.height * hei,
      );
    }
  }
}

/**TextFormField(
                  key: ValueKey(1),
                  onSaved: (value) {
                    UserText = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "글을 작성해주세요";
                    }
                  },
                  decoration: InputDecoration(
                    hintText: '입력해주세요', //텍스트폼 안에 글자 힌트
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ), */