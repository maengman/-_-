import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import '../Data/UserInfo.dart' as userinfo;
import 'UserInfo.dart';

class Api_Connect {
  Uri serverip = Uri.parse("http://192.168.219.101:5000");
  Uri image_serverip = Uri.parse("http://192.168.219.101:5050");
  //Uri serverip2 = Uri.parse("http://10.101.244.47:8000");

  Future<void> Profile_image() async {
    var request =
        http.MultipartRequest('POST', Uri.parse("$serverip/select_profile"));

    String? user_nick = await userinfo.getUserNick();
    var data = {'user_Nick': user_nick};
    var jsonEncodedData = jsonEncode(data);
    request.fields['UploadJsonData'] = jsonEncodedData;
    var response = await request.send();

    var responseData = await response.stream.bytesToString();
    var jsonData = json.decode(utf8.decode(responseData.codeUnits));
    print(jsonData['result']);
    await saveProfile_Image(jsonData['result']);
  }

  Future<String> Select_Pfrofile(String nickname) async {
    late String return_value;
    var request =
        http.MultipartRequest('POST', Uri.parse("$serverip/select_profile"));
    // String? user_nick = await userinfo.getUserNick();
    var data = {'user_Nick': nickname};
    var jsonEncodedData = jsonEncode(data);
    request.fields['UploadJsonData'] = jsonEncodedData;
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(utf8.decode(responseData.codeUnits));
      return_value = jsonData['result'];

      return return_value;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> upload_Pfrofile(Iterable<ImageFile> _images) async {
    var request =
        http.MultipartRequest('POST', Uri.parse("$serverip/upload_Pfrofile"));
    String? user_nick = await userinfo.getUserNick();
    var data = {'user_Nick': user_nick};
    var jsonEncodedData = jsonEncode(data);
    request.fields['UploadJsonData'] = jsonEncodedData;

    for (var i = 0; i < _images.length; i++) {
      request.files.add(await http.MultipartFile.fromPath(
          'image_${i + 1}', _images.elementAt(i).path!));
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(utf8.decode(responseData.codeUnits));
      //print(jsonData['result']);

      print(jsonData['result']);
      // if (result.isEmpty) {
      //   resultData.add("다른 사진을 입력해주세요.");
      // } else {
      //   print(result);
      // }
      return jsonData['result'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<String>> like_load() async {
    var request =
        http.MultipartRequest('POST', Uri.parse("$serverip/Post_Like_Load"));
    String? user_nick = await userinfo.getUserNick();
    var data = {'user_nick': user_nick};
    var jsonEncodedData = jsonEncode(data);
    request.fields['UploadJsonData'] = jsonEncodedData;

    var response = await request.send();

    late var responseData;
    responseData = await response.stream.bytesToString();
    var jsonData = json.decode(utf8.decode(responseData.codeUnits));
    List<String> returndata = List<String>.from(jsonData['result']);
    print(jsonData['result']);
    return returndata;
  }

  Future<String> post_like(String post_id, String type) async {
    var request =
        http.MultipartRequest('POST', Uri.parse("$serverip/post_like"));
    String? user_nick = await userinfo.getUserNick();
    var data = {'post_id': post_id, "like_type": type, 'user_nick': user_nick};
    var jsonEncodedData = jsonEncode(data);
    request.fields['UploadJsonData'] = jsonEncodedData;

    var response = await request.send();

    late var responseData;
    responseData = await response.stream.bytesToString();
    var jsonData = json.decode(utf8.decode(responseData.codeUnits));
    print(jsonData['result']);
    return jsonData['result'];
  }

  Future<List> select_post_comment(String post_id) async {
    List result = [];
    var request = http.MultipartRequest(
        'POST', Uri.parse("$serverip/select_post_comment"));
    var data = {'post_id': post_id};
    var jsonEncodedData = jsonEncode(data);
    request.fields['UploadJsonData'] = jsonEncodedData;

    var response = await request.send();

    if (response.statusCode == 200) {
      late var responseData;
      responseData = await response.stream.bytesToString();
      var jsonData = json.decode(utf8.decode(responseData.codeUnits));
      print(jsonData['result']);
      return jsonData['result'];
    } else {
      print('${response.statusCode}');
    }
    return result;
  }

  Future<String> user_post_comment(
      String user_comment, String post_id, String user_nick) async {
    var request =
        http.MultipartRequest('POST', Uri.parse("$serverip/post_comment"));
    var data = {
      'user_comment': user_comment,
      'post_id': post_id,
      'user_nick': user_nick
    };
    var jsonEncodedData = jsonEncode(data);
    print(jsonEncodedData);
    request.fields['UploadJsonData'] = jsonEncodedData;

    var response = await request.send();

    if (response.statusCode == 200) {
      late var responseData;
      responseData = await response.stream.bytesToString();
      var jsonData = json.decode(utf8.decode(responseData.codeUnits));
      //print(jsonData['result']);
      return jsonData['result'];
    } else {
      print('${response.statusCode}');
    }
    return "다시 해주세요";
  }

  Future<String> delete_post(String post_id) async {
    var request =
        http.MultipartRequest('POST', Uri.parse("$serverip/delete_post"));
    var data = {
      'post_id': post_id,
    };
    var jsonEncodedData = jsonEncode(data);

    request.fields['UploadJsonData'] = jsonEncodedData;

    var response = await request.send();

    if (response.statusCode == 200) {
      late var responseData;
      responseData = await response.stream.bytesToString();
      var jsonData = json.decode(utf8.decode(responseData.codeUnits));
      //print(jsonData['result']);
      return jsonData['result'];
    } else {
      print('${response.statusCode}');
    }
    return "다시 해주세요";
  }

  Future<List> MyPage(String user_id, String type) async {
    String? user_nick = await userinfo.getUserNick();
    List Data = [];
    var request = http.MultipartRequest('POST', Uri.parse("$serverip/MyPage"));
    var data = {'user_id': user_id, 'user_nick': user_nick};
    var jsonEncodedData = jsonEncode(data);

    request.fields['UploadJsonData'] = jsonEncodedData;

    var response = await request.send();

    if (response.statusCode == 200) {
      late var responseData;
      responseData = await response.stream.bytesToString();
      var jsonData = json.decode(utf8.decode(responseData.codeUnits));
      //print(jsonData['result']);
      List test = [];
      test.add(jsonData['MyPage']);
      test.add(jsonData['post_like']);
      return test;
      // if (type == "post")
      //   return jsonData['MyPage'];
      // else
      //   return jsonData['post_like'];
    } else {
      print('${response.statusCode}');
    }
    return Data;
  }

  Future<List> Fishing_Tip(String state) async {
    switch (state) {
      case "GET":
        var url = Uri.parse('$serverip/Fishing_Tip');
        var response = await http.get(url);
        print(url);
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          return jsonData['result'];
        } else {
          throw Exception('Failed to load data');
        }

      default:
        throw Exception('Failed to load data');
    }
  }

  Future<List> GET_Banned_Fish(String state, String type) async {
    switch (state) {
      case "GET":
        var url = Uri.parse('$serverip/fish_banned');
        var response = await http.get(url);
        print(url);
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          return jsonData['result'];
        } else {
          throw Exception('Failed to load data');
        }

      case "POST":
        var jsonData;
        if (type == "Search_Now_banned_fish") {
          var request =
              http.MultipartRequest('POST', Uri.parse("$serverip/fish_banned"));
          var data = {
            'type': "Search_Now_banned_fish",
          };
          var jsonEncodedData = jsonEncode(data);

          request.fields['UploadJsonData'] = jsonEncodedData;

          var response = await request.send();
          late var responseData;
          responseData = await response.stream.bytesToString();
          jsonData = json.decode(utf8.decode(responseData.codeUnits));
        } else if (type == "Search_CM_banned_fish") {
          var request =
              http.MultipartRequest('POST', Uri.parse("$serverip/fish_banned"));
          var data = {
            'type': "Search_CM_banned_fish",
          };
          var jsonEncodedData = jsonEncode(data);

          request.fields['UploadJsonData'] = jsonEncodedData;

          var response = await request.send();
          late var responseData;
          responseData = await response.stream.bytesToString();
          jsonData = json.decode(utf8.decode(responseData.codeUnits));
        }

        return jsonData['result'];

      default:
        throw Exception('Failed to load data');
    }
    // if (state == "GET") {
    //   var url = Uri.parse('$serverip/fish_banned');
    //   var response = await http.get(url);
    //   print(url);
    //   if (response.statusCode == 200) {
    //     final jsonData = jsonDecode(response.body);
    //     return jsonData['result'];
    //   } else {
    //     throw Exception('Failed to load data');
    //   }
    // } else {
    //   throw Exception('Failed to load data');
    // }
  }

  Future<List> Fish_Species_Analysis(Iterable<ImageFile> _images) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("$serverip/Fish_Species_Analysis"));

    var data = {};
    var jsonEncodedData = jsonEncode(data);
    request.fields['UploadJsonData'] = jsonEncodedData;

    for (var i = 0; i < _images.length; i++) {
      request.files.add(await http.MultipartFile.fromPath(
          'image_${i + 1}', _images.elementAt(i).path!));
    }
    List resultData = [];
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(utf8.decode(responseData.codeUnits));
      //print(jsonData['result']);
      if (jsonData['result'] == null) {
        resultData.add("다른 사진을 입력해주세요.");
      } else {
        resultData = jsonData['result'];
      }
      print(resultData);
      // if (result.isEmpty) {
      //   resultData.add("다른 사진을 입력해주세요.");
      // } else {
      //   print(result);
      // }
      return resultData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List> GetPost(String type, String post_id) async {
    if (type == "GET") {
      var url = Uri.parse('$serverip/View_Post');
      var response = await http.get(url);
      print(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData['result']);
        return jsonData['result'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      var request =
          http.MultipartRequest('POST', Uri.parse("$serverip/View_Post"));
      var data = {
        'post_id': post_id,
      };
      var jsonEncodedData = jsonEncode(data);
      print(jsonEncodedData);
      request.fields['UploadJsonData'] = jsonEncodedData;

      var response = await request.send();

      if (response.statusCode == 200) {
        late var responseData;
        responseData = await response.stream.bytesToString();
        var jsonData = json.decode(utf8.decode(responseData.codeUnits));
        //print(jsonData['result']);
        return jsonData['result'];
      } else {
        throw Exception('Failed to load data');
      }
    }
  }

  Future<List> Get_Marine_Weather(String name) async {
    List<String> oceanData = [];
    var request =
        http.MultipartRequest('POST', Uri.parse("$serverip/Marine_Weather"));
    var data = {
      'beach_name': name,
    };
    var jsonEncodedData = jsonEncode(data);

    request.fields['UploadJsonData'] = jsonEncodedData;

    var response = await request.send();

    if (response.statusCode == 200) {
      late var responseData;
      responseData = await response.stream.bytesToString();
      var jsonData = json.decode(utf8.decode(responseData.codeUnits));
      //print(jsonData['result']);
      return jsonData['result'];
    } else {
      print('${response.statusCode}');
    }
    return oceanData;
  }

/**이미지,lat,lon,날짜,글,장소 */
  Future<String> PostUpload(Iterable<ImageFile> _images, String latitude,
      String longitude, String date, String text, String userLocation) async {
    late String test;
    String? user_Nick = await userinfo.getUserNick();
    var request =
        http.MultipartRequest('POST', Uri.parse("$serverip/upload_image"));

    var data = {
      'latitude': latitude,
      'longitude': longitude,
      'date': date,
      'text': text,
      'user_Location': userLocation,
      'user_Nick': user_Nick
    };
    var jsonEncodedData = jsonEncode(data);
    request.fields['UploadJsonData'] = jsonEncodedData;

    for (var i = 0; i < _images.length; i++) {
      print(i);
      request.files.add(await http.MultipartFile.fromPath(
          'image_${i + 1}', _images.elementAt(i).path!));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      test = response.statusCode.toString();
      print('Image uploaded successfully');
      print('$test');
      var responseData = await response.stream.bytesToString();
      print(responseData);
    } else {
      test = "error";
      print('$test + ${response.statusCode}');
    }

    return test;
  }

  Future<String> UserSignup(
      String userID, String userPW, String userNick) async {
    var request = http.MultipartRequest('POST', Uri.parse("$serverip/signup"));
    var data = {'ID': userID, 'PW': userPW, 'Nickname': userNick};
    var jsonEncodedData = jsonEncode(data);
    request.fields['UploadJsonData'] = jsonEncodedData;
    // request.files.add(
    //     await http.MultipartFile.fromPath('image', _images.elementAt(0).path!));
    var response = await request.send();
    late var responseData;
    try {
      if (response.statusCode == 200) {
        responseData = await response.stream.bytesToString();
      }
    } catch (e) {
      print(e);
    }
    return responseData;
  }

  Future<String> UserLogin(String userID, String userPW) async {
    var request = http.MultipartRequest('POST', Uri.parse("$serverip/login"));
    var data = {'ID': userID, 'PW': userPW};
    var jsonEncodedData = jsonEncode(data);
    request.fields['UploadJsonData'] = jsonEncodedData;
    // request.files.add(
    //     await http.MultipartFile.fromPath('image', _images.elementAt(0).path!));
    var response = await request.send();
    late var responseData;
    try {
      if (response.statusCode == 200) {
        responseData = await response.stream.bytesToString();
        print(response.stream.toStringStream());
        await saveUserNick(responseData.toString());
        String? nickname = await getUserNick();
        print(nickname! + "1234");
        await api_connect.Profile_image();
      }
    } catch (e) {
      print(e);
    }
    return responseData;
  }
}

Api_Connect api_connect = Api_Connect();
