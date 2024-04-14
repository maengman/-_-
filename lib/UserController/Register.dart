import 'package:flutter/material.dart';
import 'package:my_fishing_log/refector.dart';

import '../Data/API.dart';
import '../Data/UserInfo.dart';
import '../app.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isSignUpScreen = true;
  late String userId;
  late String userPw;
  late String userNick;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserInfo();
  }

  void checkUserInfo() async {
    final userID = await getUserID();
    final password = await getUserPw();
    if (userID!.isNotEmpty && password!.isNotEmpty) {
      await api_connect.UserLogin(userID, password);
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => App()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          FocusScope.of(context).unfocus();
          print(await getUserID());
          print(await getUserNick());
          print(await getUserPw());
          print(await getProfile_Image());
        },
        child: Stack(
          children: [
            Positioned(
              //배경
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.amber,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              top: MediaQuery.of(context).size.height * 0.15,
              left: 20,
              right: 20,
              child: AnimatedContainer(
                height: isSignUpScreen ? 320 : 250,
                // ? MediaQuery.of(context).size.height * 0.45
                // : MediaQuery.of(context).size.height * 0.36,
                curve: Curves.easeIn,
                padding: EdgeInsets.only(top: 10),
                duration: Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    //그림자 효과
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), //투명도 조절
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignUpScreen = false;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "로그인",
                                  style: textStyle(
                                      20,
                                      isSignUpScreen
                                          ? Colors.grey
                                          : Colors.black,
                                      FontWeight.bold,
                                      1.0),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                if (!isSignUpScreen)
                                  Container(
                                    width: 65,
                                    height: 2,
                                    color: Palette.activeColor,
                                  ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignUpScreen = true;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "회원가입",
                                  style: textStyle(
                                      20,
                                      isSignUpScreen
                                          ? Colors.black
                                          : Colors.grey,
                                      FontWeight.bold,
                                      1.0),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                if (isSignUpScreen)
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      body(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Form body() {
    return Form(
        key: _formkey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              if (isSignUpScreen)
                Container(
                  child: Column(
                    children: [
                      TextFormField(
                        key: ValueKey(1),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "빈칸은 불가능 합니다";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          userId = value;
                        },
                        decoration: textformfieldDecoration(
                            "ID", Icons.account_circle_rounded),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        key: ValueKey(2),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "빈칸은 불가능 합니다";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          userNick = value;
                        },
                        decoration: textformfieldDecoration(
                            "NickName", Icons.person_pin_outlined),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        key: ValueKey(3),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "빈칸은 불가능 합니다";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          userPw = value;
                        },
                        decoration: textformfieldDecoration(
                            "PW", Icons.password_rounded),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Palette.textformColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            _tryValidation();
                            String signup = await api_connect.UserSignup(
                                userId, userPw, userNick);
                            String nick =
                                await api_connect.UserLogin(userId, userPw);
                            if (nick.isNotEmpty && signup == "회원가입 되었습니다") {
                              print(signup);
                              print(nick);
                              // Navigator.pop(context);
                              // snackbar(context, signup);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => App(),
                              //   ),
                              // );
                              await saveUserID(userId);
                              await saveUserPw(userPw);
                              await saveUserNick(userNick);
                              snackbar(context, signup);

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => App()),
                                (route) => false,
                              );
                            } else {
                              snackbar(context, signup);
                            }
                            // if (await api_connect.UserSignup(id, pw, nickname) ==
                            //     "닉네임 혹은 아이디가 중복입니다") {
                            //   idCheck = await api_connect.CheckUserID(id);
                            //   nickCheck = await api_connect.CheckUserNick(nickname);
                            // }
                          },
                          child: Text(
                            "회원가입",
                            style: textStyle(
                                18, Colors.black87, FontWeight.w300, 1.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              if (!isSignUpScreen)
                Container(
                  child: Column(
                    children: [
                      TextFormField(
                        key: ValueKey(4),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "빈칸은 불가능 합니다";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          userId = value;
                        },
                        decoration: textformfieldDecoration(
                            "ID", Icons.account_circle_rounded),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        key: ValueKey(5),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "빈칸은 불가능 합니다";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          userPw = value;
                        },
                        decoration: textformfieldDecoration(
                            "PW", Icons.password_rounded),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Palette.textformColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            _tryValidation();

                            String nick =
                                await api_connect.UserLogin(userId, userPw);
                            if (nick.isNotEmpty && nick != "찾을수 없습니다") {
                              print(nick);
                              // Navigator.pop(context);
                              // snackbar(context, signup);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => App(),
                              //   ),
                              // );
                              await saveUserID(userId);
                              await saveUserPw(userPw);
                              await saveUserNick(nick);
                              snackbar(context, "로그인 되었습니다");
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => App()),
                                (route) => false,
                              );
                            } else {
                              snackbar(context, "아이디 혹은 비밀번호를 확인해주세요");
                            }
                          },
                          child: Text(
                            "로그인",
                            style: textStyle(
                                18, Colors.black87, FontWeight.w300, 1.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ));
  }

  void _tryValidation() {
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      _formkey.currentState!.save();
    }
  }
}
