import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_fishing_log/components/MainPage/NewCamera.dart';

import '../../Data/Location.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  double longitude = 0.0;
  double latitude = 0.0;
  String userPosition = "???";
  @override
  void initState() {
    super.initState();
    GetLocation();
  }

  void GetLocation() async {
    MyLocation myLocation = MyLocation();
    await myLocation.getMyCurrentLocation();
    latitude = myLocation.latitude;
    longitude = myLocation.longitude;
    userPosition = await SearchLocationName(LatLng(latitude, longitude));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CameraPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 111, 238, 255),
              Color.fromARGB(255, 7, 91, 160)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitDoubleBounce(
                color: Colors.white,
                size: 80.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
