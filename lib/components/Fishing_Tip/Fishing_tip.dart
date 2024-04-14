import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

//final homeUrl = Uri.parse('https://slds2.tistory.com/3379');
late Uri url;

class Fishing_Tip_Post extends StatefulWidget {
  const Fishing_Tip_Post({super.key, required this.posts});
  final List posts;
  @override
  State<Fishing_Tip_Post> createState() => _Fishing_Tip_PostState();
}

class _Fishing_Tip_PostState extends State<Fishing_Tip_Post> {
  WebViewController? controller;
  late List _posts;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _posts = widget.posts;
      url = Uri.parse(_posts[1]);
    });
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(url);
  }

  Widget post_name() {
    return Text(_posts[2].toString());
  }

  Widget post_maker() {
    return Text(_posts[3].toString());
  }

  Widget post_type() {
    return Text(_posts[4].toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(_posts[1]);
        setState(() {
          controller!.loadRequest(Uri.parse(_posts[1]));
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewWidget(
              controller: controller!,
            ),
          ),
        );
        controller!.clearCache();
      },
      child: Container(
        margin: EdgeInsets.all(3),
        width: MediaQuery.of(context).size.width,
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
            post_name(),
            post_maker(),
            post_type(),
          ],
        ),
      ),
    );
  }
}
