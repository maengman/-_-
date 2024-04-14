import 'package:flutter/material.dart';
import 'package:my_fishing_log/refector.dart';
import 'package:photo_view/photo_view.dart';
import '../../Data/API.dart';

class Fish_species extends StatefulWidget {
  const Fish_species({
    super.key,
    required this.posts,
  });
  final List posts;

  @override
  State<Fish_species> createState() => _Fish_speciesState();
}

class _Fish_speciesState extends State<Fish_species> {
  late List posts;

  String serverip = api_connect.image_serverip.toString() + "/banned_fish/";
  //String serverip = "http://10.101.244.47:8000/";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      posts = widget.posts;
    });
  }

  Widget _name(
      BuildContext contex, String name, String banned_date, String banned_cm) {
    List banned_date_contain = [];
    if (banned_date.contains("=")) {
      banned_date_contain = banned_date.split("=");
    }
    return Column(
      children: [
        Text(
          "어종 : $name",
          style: textStyle(20, Colors.black, FontWeight.w600, 1.0),
        ),
        if (banned_date_contain.isNotEmpty)
          Column(
            children: [
              Text(
                "금어기 : " + banned_date_contain[0],
                style: textStyle(20, Colors.black, FontWeight.w600, 1.0),
              ),
              Text(
                banned_date_contain[1],
                style: textStyle(17, Colors.black, FontWeight.w600, 1.0),
              )
            ],
          ),
        if (banned_date_contain.isEmpty && banned_date != "X")
          Text(
            "금어기 : $banned_date",
            style: textStyle(20, Colors.black, FontWeight.w600, 1.0),
          ),
        if (banned_cm != "X")
          Text(
            "금지체장 : $banned_cm",
            style: textStyle(20, Colors.black, FontWeight.w600, 1.0),
          ),
      ],
    );
  }

  Widget _image(BuildContext contex, String image) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: PhotoView(
                imageProvider: NetworkImage(serverip + image),
              ),
            ),
          ),
        );
      },
      child: Image.network(
        serverip + image,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // 테두리 색상
          width: 1.0, // 테두리 두께
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _name(context, posts[2], posts[3], posts[4]),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 300,
            child: _image(context, posts[1]),
          ),
        ],
      ),
    );
  }
}
