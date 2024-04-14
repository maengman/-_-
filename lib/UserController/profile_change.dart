import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:my_fishing_log/Data/API.dart';
import 'package:my_fishing_log/refector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;
import '../Data/UserInfo.dart';
import 'Register.dart';

class Profile_Change extends StatefulWidget {
  const Profile_Change({super.key});

  @override
  State<Profile_Change> createState() => _Profile_ChangeState();
}

class _Profile_ChangeState extends State<Profile_Change> {
  File? _image;
  ImageFile? _image2;
  List<ImageFile> imageFilesList = [];
  Iterable<ImageFile>? imageFilesIterable;

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

    setState(() {
      _image2 = imageFile;
      imageFilesList.add(imageFile);
      _image = File(pickedImage.path);
    });
  }

  Widget image() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (_image == null)
          CircleAvatar(
            radius: 50,
            child: Icon(
              Icons.account_circle_outlined,
              size: 100,
              color: Colors.white,
            ),
            backgroundColor: Colors.grey,
          ),
        if (_image != null)
          CircleAvatar(
            radius: 50,
            backgroundImage: FileImage(_image!),
            backgroundColor: Colors.grey,
          ),
        Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await _getImageFromGallery();
              },
              child: Text(
                "이미지 변경",
                style: textStyle(18, Colors.black, FontWeight.normal, 1.0),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(130, 40),
                  backgroundColor: Colors.grey[400]),
            ),
            ElevatedButton(
              onPressed: () async {
                String? profile =
                    await api_connect.upload_Pfrofile(imageFilesList);
                await saveProfile_Image(profile);
              },
              child: Text(
                "저장하기",
                style: textStyle(18, Colors.black, FontWeight.normal, 1.0),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(130, 40),
                  backgroundColor: Colors.grey[400]),
            ),
          ],
        ),
      ],
    );
  }

  Widget account() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            await api_connect.like_load();
          },
          child: Text(
            "닉네임 변경",
            style: textStyle(18, Colors.black, FontWeight.normal, 1.0),
          ),
          style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width, 40),
              backgroundColor: Colors.grey[400]),
        ),
        ElevatedButton(
          onPressed: () async {
            String? nick = await getUserNick();
            await api_connect.Select_Pfrofile(nick!);
          },
          child: Text(
            "비밀번호 변경",
            style: textStyle(18, Colors.black, FontWeight.normal, 1.0),
          ),
          style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width, 40),
              backgroundColor: Colors.grey[400]),
        ),
        ElevatedButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.remove('profile_image');
            prefs.clear();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SignUpScreen()),
                (route) => false);
          },
          child: Text(
            "로그아웃",
            style: textStyle(18, Colors.black, FontWeight.normal, 1.0),
          ),
          style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width, 40),
              backgroundColor: Colors.grey[400]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20), child: image()),
            Divider(
              height: 10,
              color: Colors.black,
              thickness: 0.4,
            ),
            Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 20), child: account()),
          ],
        ),
      ),
    );
  }
}
