import 'package:shared_preferences/shared_preferences.dart';

//**프로필 저장하기 */
Future<void> saveProfile_Image(String profile_image) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('profile_image', profile_image);
}

//**ID 저장하기 */
Future<void> saveUserID(String userID) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userID', userID);
}

//**비밀번호 저장하기 */
Future<void> saveUserPw(String password) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('password', password);
}

//**닉네임 저장하기 */
Future<void> saveUserNick(String nickname) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('nickname', nickname);
}

//**프로필 불러오기 */
Future<String?> getProfile_Image() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('profile_image');
}

//**ID 불러오기 */
Future<String?> getUserID() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userID');
}

//**비밀번호 불러오기 */
Future<String?> getUserPw() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('password');
}

//**닉네임 불러오기 */
Future<String?> getUserNick() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('nickname');
}

//**테스트용 */
Future<void> Test(List<String> test) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('like', test);
}
