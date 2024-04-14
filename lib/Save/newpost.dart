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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  File? _imageFile;

  @override
  void initState() {
    super.initState();

    // 카메라 설정을 초기화합니다.
    _initializeCamera();
  }

  // 카메라 초기화
  void _initializeCamera() async {
    // 사용 가능한 카메라 목록을 가져옵니다.
    final cameras = await availableCameras();
    // 사용 가능한 첫 번째 카메라를 선택합니다.
    final firstCamera = cameras.first;

    // 선택한 카메라로 컨트롤러를 초기화합니다.
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    // 컨트롤러를 초기화합니다.
    _initializeControllerFuture = _controller?.initialize();
    setState(() {});
  }

  // 카메라를 토글합니다.
  void _toggleCamera() {
    setState(() {
      if (_controller?.value.isInitialized == true) {
        _controller?.dispose();
        _controller = null;
        _imageFile = null;
      } else {
        _initializeCamera();
      }
    });
  }

  // 갤러리에서 이미지를 선택합니다.
  void _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      setState(() {});
    }
  }

  // 카메라로 사진을 촬영합니다.
  void _takePicture() async {
    try {
      // 초기화가 완료될 때까지 기다립니다.
      await _initializeControllerFuture;

      // 사진을 촬영합니다.
      final image = await _controller?.takePicture();

      if (image != null) {
        // 이미지를 저장합니다.
        await GallerySaver.saveImage(image.path);

        // 파일을 생성합니다.
        _imageFile = File(image.path);

        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // 사용한 컨트롤러를 해제합니다.
    _controller?.dispose();
    super.dispose();
    _imageFile?.delete(); // 임시 파일 삭제
  }

  // 게시물을 업로드합니다.
  void _uploadPost() async {
    // 이미지 파일이 없으면 업로드하지 않습니다.
    if (_imageFile == null) return;

    // TODO: 게시물 업로드 코드 작성

    // 게시물을 업로드한 후, 이전 화면으로 이동합니다.
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        actions: [
          IconButton(
            onPressed: _uploadPost,
            icon: Icon(Icons.send),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _imageFile == null
                ? _buildCameraPreview()
                : _buildSelectedImagePreview(),
          ),
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(color: Colors.amber),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: _toggleCamera,
                icon: Icon(Icons.switch_camera),
              ),
              IconButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: Icon(Icons.photo),
              ),
              IconButton(
                onPressed: _takePicture,
                icon: Icon(Icons.camera),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 카메라 프리뷰를 생성합니다.
  Widget _buildCameraPreview() {
    return FutureBuilder(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_controller?.value.isInitialized == true) {
            return CameraPreview(_controller!);
          } else {
            return Text('Camera not available');
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // 선택한 이미지를 보여줍니다.
  Widget _buildSelectedImagePreview() {
    return Image.file(
      _imageFile!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
