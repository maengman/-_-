import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:my_fishing_log/Data/API.dart';
import 'package:my_fishing_log/refector.dart';
import 'package:photo_view/photo_view.dart';
import 'package:expandable/expandable.dart';
import 'package:image/image.dart' as img;
import '../components/Fish_SpeciesPage/Fish_Post.dart';

class Fish_Species_Analysis extends StatefulWidget {
  @override
  Fish_Species_Analysis_State createState() => Fish_Species_Analysis_State();
}

class Fish_Species_Analysis_State extends State<Fish_Species_Analysis> {
  String serverip = api_connect.image_serverip.toString() + "/fishwiki/";

  ImageFile? _image;
  List<ImageFile> imageFilesList = [];
  Iterable<ImageFile>? imageFilesIterable;
  bool banned_date = true;
  List bannedfish = [];
  int? _image_Height;
  int? _image_Width;

  Widget _postlist() {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
              bannedfish.length,
              (index) => Fish_species(
                    posts: bannedfish[index],
                  )).toList(),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      Banned_Fish(banned_date);
    });
    super.initState();
  }

  Future<String> Banned_Fish(bool banned_date) async {
    if (banned_date == true) {
      bannedfish =
          await api_connect.GET_Banned_Fish("POST", "Search_Now_banned_fish");
      print(bannedfish);
      return "load Data";
    } else {
      bannedfish =
          await api_connect.GET_Banned_Fish("POST", "Search_CM_banned_fish");
      print("1234");
      return "load Data";
    }
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
    var image_area = img.decodeImage(Uint8List.fromList(bytes));
    setState(() {
      _image_Width = image_area!.width;
      _image_Height = image_area.height;
      _image = imageFile;
      imageFilesList.add(_image!);
    });
    print(_image_Width);
    print(_image_Height);
  }

  void _RemovePhoto() {
    setState(() {
      _image = null;
      imageFilesList = [];
      imageFilesIterable = null;
      _image_Height = null;
      _image_Width = null;
    });
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    final bytes = await File(pickedImage!.path).readAsBytes();

    ImageFile imageFile = ImageFile(pickedImage.name,
        name: pickedImage.name,
        extension: pickedImage.path.split('.').last,
        bytes: bytes,
        path: pickedImage.path,
        readStream: pickedImage.openRead());
    var image_area = img.decodeImage(Uint8List.fromList(bytes));
    setState(() {
      _image_Width = image_area!.width;
      _image_Height = image_area.height;
      _image = imageFile;
      imageFilesList.add(imageFile);
    });
  }

  Future<void> showCustomDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("분석중입니다. 잠시 기다려주세요"),
          content: CircularProgressIndicator(), // 로딩 스피너 또는 진행 상황을 나타내는 위젯
        );
      },
    );
  }

  Future<void> showResultDialog(BuildContext context, List resultData) async {
    if (resultData.length < 3)
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(resultData[0]),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    else
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: PhotoView(
                        imageProvider: NetworkImage(serverip + resultData[1]),
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, // 테두리 색상
                    width: 1.0, // 테두리 두께
                  ),
                ),
                child: Image.network(
                  serverip + resultData[1],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  _DecoContainer("예상 어종", resultData[2]),
                  _DecoContainer("위험도", resultData[3]),
                  _DecoContainer("유의사항", resultData[4]),
                  _DecoContainer("금어기", resultData[9]),
                  _DecoContainer("제철", resultData[5]),
                  _DecoContainer("추천요리", resultData[6]),
                  _DecoContainer("특징", resultData[7]),
                ],
              ),
            ),
            // 결과 정보를 표시
            actions: [
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: Text(resultData[8]),
                    ),
                  );
                },
                child: Text(
                  '이미지 출처',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: Text(
                  '확인',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
  }

  Widget _Analysis_Image() {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: _image_Width! > _image_Height! ? 4 / 3 : 3 / 4,
          child: Image.file(
            File(_image!.path!),
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black, // 테두리 색상
              width: 1.0, // 테두리 두께
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width,
          child: TextButton(
            onPressed: () {
              _RemovePhoto();
            },
            child: Text(
              "이미지 삭제",
              style: textStyle(22, Colors.black, FontWeight.normal, 1.0),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black, // 테두리 색상
              width: 1.0, // 테두리 두께
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width,
          child: TextButton.icon(
            onPressed: () async {
              showCustomDialog(context); // 다이얼로그 표시
              setState(() {
                imageFilesIterable = imageFilesList;
              });
              //print(imageFilesIterable);
              List resultData =
                  await api_connect.Fish_Species_Analysis(imageFilesIterable!);
              Navigator.of(context).pop(); // 다이얼로그 닫기
              print(serverip + resultData[1]);
              // 여기서 비동기 작업이 완료되면, 원하는 정보를 다이얼로그에 표시
              showResultDialog(context, resultData);
            },
            label: Text(
              "분석하기",
              style: textStyle(22, Colors.black, FontWeight.normal, 1.0),
            ),
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _PickImage() {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(
                color: Colors.black, // 테두리 색상
                width: 1.0, // 테두리 두께
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "이미지를 선택해주세요",
                style: textStyle(25, Colors.black, FontWeight.normal, 1.0),
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black, // 테두리 색상
              width: 1.0, // 테두리 두께
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width,
          child: TextButton.icon(
            onPressed: () {
              _takePhoto();
            },
            label: Text(
              "촬영하기",
              style: textStyle(22, Colors.black, FontWeight.normal, 1.0),
            ),
            icon: Icon(
              Icons.camera_alt,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 화면의 가로 및 세로 크기를 가져옵니다.
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_image == null)
              GestureDetector(
                onTap: () {
                  _getImageFromGallery();
                },
                child: _PickImage(),
              ),
            if (_image != null)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: Image.file(
                        File(_image!.path!),
                      ),
                    ),
                  );
                },
                child: _Analysis_Image(),
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.40,
              margin: EdgeInsets.fromLTRB(3, 0, 3, 0),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black, // 테두리 색상
                  width: 1.0, // 테두리 두께
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            banned_date = true;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              "현재 금어기",
                              style: textStyle(
                                  20,
                                  banned_date ? Colors.black : Colors.grey,
                                  FontWeight.bold,
                                  1.0),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            if (banned_date)
                              Container(
                                width: 85,
                                height: 2,
                                color: Palette.activeColor,
                              ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            banned_date = false;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              "금지체장",
                              style: textStyle(
                                  20,
                                  banned_date ? Colors.grey : Colors.black,
                                  FontWeight.bold,
                                  1.0),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            if (!banned_date)
                              Container(
                                width: 65,
                                height: 2,
                                color: Palette.activeColor,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[200],
                    thickness: 1,
                  ),
                  Flexible(
                    child: FutureBuilder<String>(
                      future: banned_date
                          ? Banned_Fish(banned_date)
                          : Banned_Fish(banned_date), // 비동기 작업을 수행하는 Future 객체
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // 작업이 아직 완료되지 않았을 때 로딩 인디케이터를 표시
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          // 작업 중 오류가 발생한 경우 오류 메시지를 표시
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // 작업이 성공적으로 완료된 경우 결과 데이터를 화면에 표시
                          return _postlist();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _DecoContainer(String fir, String text) {
    List a = [];
    if (text.contains('=')) {
      a = text.split('=');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fir,
          style: textStyle(18, Colors.black, FontWeight.normal, 1.0),
        ),
        if (a.length < 2)
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(
                  color: Colors.black, // 테두리 색상
                  width: 0.5, // 테두리 두께
                ),
                borderRadius: BorderRadius.circular(3)),
            child: Center(
              child: Text(
                text,
                style: textStyle(18, Colors.black, FontWeight.normal, 1.0),
              ),
            ),
          ),
        if (a.length >= 2)
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(
                  color: Colors.black, // 테두리 색상
                  width: 0.5, // 테두리 두께
                ),
                borderRadius: BorderRadius.circular(3)),
            child: Column(
              children: [
                Center(
                  child: ExpandablePanel(
                    header: Center(
                      child: Text(
                        a[0],
                        style:
                            textStyle(18, Colors.black, FontWeight.normal, 1.0),
                      ),
                    ),
                    collapsed: Text(
                      " " + a[1],
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Text(
                      " " + a[1],
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
