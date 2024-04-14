import 'package:flutter/material.dart';
import 'package:my_fishing_log/refector.dart';

class WavePost_widget extends StatelessWidget {
  WavePost_widget({super.key, this.time2, this.wave2});

  final wave2;
  final time2;

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                wave2,
                style: textStyle(25, Colors.black, FontWeight.bold, 2.0),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                time2,
                style: textStyle(25, Colors.black, FontWeight.bold, 2.0),
              ),
            ],
          ),
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.bookmark_outlined,
              color: Colors.blue[300],
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(),
      ],
    );
  }
}
