import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyLocation {
  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> getMyCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      longitude = position.longitude; //경도
      latitude = position.latitude; //위도
    } catch (e) {
      print('Internet Error');
    }
  }
}

Future<LatLng> SearchLocation(String address) async {
  late LatLng latLng;
  print(address);
  try {
    List<Location> locations = await locationFromAddress(address);

    latLng = LatLng(locations[0].latitude, locations[0].longitude);
    print(latLng);
    return latLng;
  } catch (e) {
    print("$e + eeeee");
    latLng = LatLng(89, 1);
    return latLng;
  }
}

Future<String> SearchLocationName(LatLng positon) async {
  print(positon);
  late String locationName;
  try {
    List<Placemark> placemark =
        await placemarkFromCoordinates(positon.latitude, positon.longitude);
    // locationName =
    //     "${placemark[2].administrativeArea}/${placemark[2].thoroughfare}";
    locationName = placemark[0].street.toString();
    if (locationName.split(" ").length <= 2) {
      locationName = locationName.split(" ")[0];
    } else if (locationName.split(" ").length <= 1) {
      locationName = locationName.split(" ")[0];
    }

    return locationName;
  } catch (e) {
    return "???";
  }
}
