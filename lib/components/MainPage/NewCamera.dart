import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_fishing_log/components/MainPage/NewPost.dart';
import 'package:my_fishing_log/refector.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:image_picker/image_picker.dart';

import '../../Data/Location.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    super.key,
  });

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  double? latitude;
  double? longitude;
  String? userPosition;
  bool spinner = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSpinner();
  }

  void checkSpinner() async {
    bool checkSpinner = await GetLocation();
    setState(() {
      spinner = checkSpinner;
    });
  }

  Future<bool> GetLocation() async {
    MyLocation myLocation = MyLocation();
    await myLocation.getMyCurrentLocation();
    latitude = myLocation.latitude;
    longitude = myLocation.longitude;
    userPosition = await SearchLocationName(LatLng(latitude!, longitude!));
    return false;
  }

  Future<void> _takePhoto() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );
    final bytes = await File(image!.path).readAsBytes();

    ImageFile imageFile = ImageFile(image.name,
        name: image.name,
        extension: image.path.split('.').last,
        bytes: bytes,
        path: image.path,
        readStream: image.openRead());

    print(imageFile);
    setState(() {
      controller.addImage(imageFile);
    });
  }

  final controller = MultiImagePickerController(
    images: <ImageFile>[],
    withData: true,
    maxImages: 6,
    withReadStream: true,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.images.length >= 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewPost(
                        images2: controller.images,
                        latitude: latitude!,
                        longitude: longitude!,
                        userPositon: userPosition!),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      content: Text("사진을 선택해주세요"),
                    );
                  },
                );
              }
            },
            child: Text(
              "다음",
              style: textStyle(15, Colors.black87, FontWeight.w600, 1.5),
            ),
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "사진을 선택해주세요",
                        style:
                            textStyle(30, Colors.black, FontWeight.w500, 1.2),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "처음 사진은 대표사진으로 업로드 됩니다.",
                        style:
                            textStyle(15, Colors.black, FontWeight.w500, 1.2),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "최대 6장까지 업로드 가능합니다",
                        style:
                            textStyle(15, Colors.black, FontWeight.w500, 1.2),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.black87,
                height: 15,
                thickness: 0.5,
              ),
              MultiImagePickerView(
                draggable: true,
                onChange: (list) {
                  debugPrint(list.toString());
                },
                controller: controller,
                padding: const EdgeInsets.all(10),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.black,
                      elevation: 1.0,
                      onPressed: () {
                        if (controller.images.length < 6) {
                          _takePhoto();
                        } else if (controller.images.length >= 6) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                content: Text("6장 선택되었습니다"),
                              );
                            },
                          );
                        }
                      },
                      child: Icon(Icons.camera_alt_outlined, size: 30),
                    ),
                  ],
                ),
              ),
            ],
          ),
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

/**
 * import 'dart:io';
import 'package:my_fishing_log/components/NewPost.dart';
import 'package:my_fishing_log/refector.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:image_picker/image_picker.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  Future<void> _takePhoto() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: MediaQuery.of(context).size.height,
    );
    final bytes = await File(image!.path).readAsBytes();

    if (image != null) {
      ImageFile imageFile = ImageFile(image.path,
          name: image.name,
          extension: image.path.split('.').last,
          bytes: bytes,
          path: image.path,
          readStream: image.openRead());

      print(imageFile);
      setState(() {
        controller.addImage(imageFile);
        //_images.add(File(image.path));
      });
    }
  }

  final controller = MultiImagePickerController(
    images: <ImageFile>[],
    withData: true,
    maxImages: 6,
    withReadStream: true,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
  );
  // final controller = MultiImagePickerController(
  //   images: <ImageFile>[],
  //   withData: true,
  //   maxImages: 6,
  //   withReadStream: true,
  //   allowedImageTypes: ['png', 'jpg', 'jpeg'],
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => NewPost(images2: controller.images),
              //   ),
              // );
            },
            child: Text(
              "다음",
              style: textStyle(15, Colors.black87, FontWeight.w600, 1.5),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "사진을 선택해주세요",
                        style:
                            textStyle(30, Colors.black, FontWeight.w500, 1.2),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "처음 사진은 대표사진으로 업로드 됩니다.",
                        style:
                            textStyle(15, Colors.black, FontWeight.w500, 1.2),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "최대 6장까지 업로드 가능합니다",
                        style:
                            textStyle(15, Colors.black, FontWeight.w500, 1.2),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.black87,
                height: 15,
                thickness: 0.5,
              ),
              MultiImagePickerView(
                draggable: true,
                onChange: (list) {
                  debugPrint(list.toString());
                },
                controller: controller,
                padding: const EdgeInsets.all(10),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.black,
                      elevation: 1.0,
                      onPressed: () {
                        _takePhoto();
                      },
                      child: Icon(Icons.camera_alt_outlined, size: 30),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 * 
 */

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }

// // class PictureWiget extends StatelessWidget {
// //   const PictureWiget({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         centerTitle: true,
// //         elevation: 0.0,
// //         backgroundColor: Colors.white,
// //         iconTheme: IconThemeData(color: Colors.black),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => NewPost(),
// //                 ),
// //               );
// //             },
// //             child: Text(
// //               "다음",
// //               style: textStyle(15, Colors.black87, FontWeight.w600, 1.5),
// //             ),
// //           ),
// //         ],
// //       ),
// //       body: Container(
// //         width: MediaQuery.of(context).size.width * 1.0,
// //         height: MediaQuery.of(context).size.height * 1.0,
// //         color: Colors.amber,
// //         child: Column(),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:gallery_saver/files.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// import '../refector.dart';
// import 'NewPost.dart';

// class CameraGalleryDemo extends StatefulWidget {
//   @override
//   _CameraGalleryDemoState createState() => _CameraGalleryDemoState();
// }

// class _CameraGalleryDemoState extends State<CameraGalleryDemo> {
//   // 이미지를 저장할 리스트
//   List<File> _images = [];
//   // var _images = List<int>.filled(6,null);

//   // 카메라로 촬영한 이미지를 가져와서 _images 리스트에 추가하는 함수
//   Future<void> _takePhoto() async {
//     XFile? image = await ImagePicker().pickImage(
//       source: ImageSource.camera,
//       imageQuality: 100,
//       maxWidth: MediaQuery.of(context).size.width,
//       maxHeight: MediaQuery.of(context).size.height,
//     );

//     if (image != null) {
//       setState(() {
//         _images.add(File(image.path));
//       });
//     }
//   }

//   // 갤러리에서 이미지를 가져와서 _images 리스트에 추가하는 함수
//   Future<void> _pickImage() async {
//     XFile? image = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 80,
//       maxWidth: 800,
//     );

//     if (image != null) {
//       setState(() {
//         _images.add(File(image.path));
//       });
//     }
//   }

//   bool _isMax() {
//     if (_images.length < 6) {
//       return true;
//     } else
//       return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0.0,
//         backgroundColor: Colors.white,
//         iconTheme: IconThemeData(color: Colors.black),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => NewPost(),
//                 ),
//               );
//             },
//             child: Text(
//               "다음",
//               style: textStyle(15, Colors.black87, FontWeight.w600, 1.5),
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         color: Colors.white,
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             children: [
//               Text(
//                 "사진을 선택해주세요",
//                 style: textStyle(30, Colors.black, FontWeight.w500, 1.2),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Text(
//                 "처음 사진은 대표사진으로 업로드 됩니다.",
//                 style: textStyle(15, Colors.black, FontWeight.w500, 1.2),
//               ),
//               SizedBox(
//                 height: 3,
//               ),
//               Text(
//                 "최대 6장까지 업로드 가능합니다",
//                 style: textStyle(15, Colors.black, FontWeight.w500, 1.2),
//               ),
//               SizedBox(
//                 height: 3,
//               ),
//               Divider(
//                 color: Colors.black87,
//                 height: 15,
//                 thickness: 0.5,
//               ),
//               GridView.builder(
//                 shrinkWrap: true,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   mainAxisSpacing: 4,
//                   crossAxisSpacing: 4,
//                 ),
//                 itemCount: _images.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Image.file(_images[index]);
//                 },
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Visibility(
//                 visible: _isMax(),
//                 child: SizedBox(
//                   width: 150,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // 버튼을 눌렀을 때 수행할 동작
//                       _pickImage();
//                     },
//                     child: Text("갤러리"),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: Visibility(
//         visible: _isMax(),
//         child: FloatingActionButton(
//           onPressed: () {
//             _takePhoto();
//           },
//           child: Icon(Icons.add),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   File? _image;

//   // 갤러리에서 이미지를 선택하는 함수
//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: source);
//     if (pickedImage != null) {
//       setState(() {
//         _image = File(pickedImage.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Image Picker Example')),
//       body: Center(
//         child: _image == null ? Text('No image selected') : Image.file(_image!),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showModalBottomSheet(
//               context: context,
//               builder: (BuildContext context) {
//                 return SafeArea(
//                   child: Container(
//                     child: Wrap(
//                       children: <Widget>[
//                         ListTile(
//                             leading: Icon(Icons.photo_library),
//                             title: Text('갤러리에서 가져오기'),
//                             onTap: () {
//                               _pickImage(ImageSource.gallery);
//                               Navigator.of(context).pop();
//                             }),
//                         ListTile(
//                           leading: Icon(Icons.photo_camera),
//                           title: Text('카메라로 촬영하기'),
//                           onTap: () {
//                             _pickImage(ImageSource.camera);
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               });
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
