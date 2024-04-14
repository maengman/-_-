import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_fishing_log/Data/API.dart';
import 'package:my_fishing_log/refector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarineScreen extends StatefulWidget {
  const MarineScreen({super.key});

  @override
  State<MarineScreen> createState() => _MarineScreenState();
}

class _MarineScreenState extends State<MarineScreen> {
  String? titleText;
  bool isDrawerOpen = false;
  var _Marine_Weather;
  DateTime? date;
  int? nowDate;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List searchedItems = [];
  SharedPreferences? preferences;
  List<String> likeList = [];
  //지역별 이름
  /**인천 */
  bool istoggleDropdown_Incheon = true;
  /**강원도 */
  bool istoggleDropdown_GWD = true;
  /**울산 */
  bool istoggleDropdown_Ulsan = true;
  /**부산 */
  bool istoggleDropdown_Busan = true;
  /**제주도 */
  bool istoggleDropdown_Jeju = true;
  /**경기도 */
  bool istoggleDropdown_GG = true;
  /**충청남도 */
  bool istoggleDropdown_CCND = true;
  /**전라남도 */
  bool istoggleDropdown_JN = true;
  /**전라북도 */
  bool istoggleDropdown_JB = true;
  /**경상남도 */
  bool istoggleDropdown_GN = true;
  /**경상북도 */
  bool istoggleDropdown_GB = true;
  /**좋아요 */
  bool istoggleDropdown_like = true;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      date = DateTime.now();
      // nowDate =
      //     Int("${date!.year.toString()}${date!.month.toString().padLeft(2, '0')}${date!.day.toString().padLeft(2, '0')}");
      nowDate = int.parse(
          "${date!.year.toString()}${date!.month.toString().padLeft(2, '0')}${date!.day.toString().padLeft(2, '0')}");
      //titleText = beachname_list[0];
      loadItems();
    });
    super.initState();
  }

  Future<void> fetchData(String title) async {
    // 여기에서 비동기 작업을 수행하고 값을 가져옵니다.
    _Marine_Weather = null;
    await Future.delayed(Duration(milliseconds: 40));
    _Marine_Weather = await Api_Connect().Get_Marine_Weather(title);
    // 가져온 값으로 상태를 업데이트합니다.
    setState(() {
      // 가져온 값으로 업데이트
      print(_Marine_Weather);
    });
  }

  Future<void> saveTitleText(String titleText) async {
    await preferences!.setString('titleText', titleText);
  }

  /**지역토글박스  */
  void toggleDropDown(String locate) {
    print(locate + " qwer");
    if (locate == location[0]) {
      setState(() {
        istoggleDropdown_Incheon = !istoggleDropdown_Incheon;
      });
    } else if (locate == location[1]) {
      setState(() {
        istoggleDropdown_GWD = !istoggleDropdown_GWD;
      });
    } else if (locate == location[2]) {
      setState(() {
        istoggleDropdown_Ulsan = !istoggleDropdown_Ulsan;
      });
    } else if (locate == location[3]) {
      setState(() {
        istoggleDropdown_Busan =
            !istoggleDropdown_Busan; // 변수를 토글하여 드롭다운 표시 상태 변경
      });
    } else if (locate == location[4]) {
      setState(() {
        istoggleDropdown_Jeju =
            !istoggleDropdown_Jeju; // 변수를 토글하여 드롭다운 표시 상태 변경
      });
    } else if (locate == location[5]) {
      setState(() {
        istoggleDropdown_GG = !istoggleDropdown_GG; // 변수를 토글하여 드롭다운 표시 상태 변경
      });
    } else if (locate == location[6]) {
      setState(() {
        istoggleDropdown_CCND =
            !istoggleDropdown_CCND; // 변수를 토글하여 드롭다운 표시 상태 변경
      });
    } else if (locate == location[7]) {
      setState(() {
        istoggleDropdown_JB = !istoggleDropdown_JB; // 변수를 토글하여 드롭다운 표시 상태 변경
      });
    } else if (locate == location[8]) {
      setState(() {
        istoggleDropdown_JN = !istoggleDropdown_JN; // 변수를 토글하여 드롭다운 표시 상태 변경
      });
    } else if (locate == location[9]) {
      setState(() {
        istoggleDropdown_GB = !istoggleDropdown_GB; // 변수를 토글하여 드롭다운 표시 상태 변경
      });
    } else if (locate == location[10]) {
      setState(() {
        istoggleDropdown_GN = !istoggleDropdown_GN; // 변수를 토글하여 드롭다운 표시 상태 변경
      });
    } else if (locate == "like") {
      setState(() {
        istoggleDropdown_like =
            !istoggleDropdown_like; // 변수를 토글하여 드롭다운 표시 상태 변경
      });
    }
  }

  void openDrawer() {
    setState(() {
      isDrawerOpen = true; // 드로어 메뉴를 열림 상태로 변경
    });

    // _scaffoldKey.currentState를 사용하여 Scaffold의 상태를 가져와 열린 드로어 메뉴를 보여줍니다.
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void closeDrawer() {
    setState(() {
      isDrawerOpen = false; // 드로어 메뉴를 닫힘 상태로 변경
    });

    // _scaffoldKey.currentState를 사용하여 Scaffold의 상태를 가져와 열린 드로어 메뉴를 보여줍니다.
    _scaffoldKey.currentState?.closeEndDrawer();
  }

  Future<void> loadItems() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      likeList = preferences!.getStringList('like') ?? [];

      String? set = preferences!.getString('titleText');
      if (set == null) {
        titleText = beachname_list[0];
      } else {
        titleText = preferences!.getString('titleText');
      }
      fetchData(titleText!);
    });
  }

  Future<void> saveItems() async {
    await preferences!.setStringList('like', likeList);
  }

  void addLike(String test) {
    if (test.isNotEmpty) {
      setState(() {
        likeList.add(test);
      });
      saveItems();
    }
  }

  void deleteLike(String test) {
    if (test.isNotEmpty) {
      setState(() {
        likeList.remove(test);
      });
      saveItems();
    }
  }

  Widget _make_Darwer(
      List<String> locate, String lo, List<String> filteredItems) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0), // 원하는 반지름 값으로 설정
        color: Color.fromARGB(31, 137, 137, 137), // 배경색 설정
      ),
      child: Column(
        children: List.generate(locate.length, (index) {
          final itemName = locate[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                titleText = itemName;
                saveTitleText(itemName);
                fetchData(titleText!);
                closeDrawer();
                toggleDropDown(lo);
              });
            },
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // 양쪽 끝으로 배치
                    children: [
                      Text(itemName),
                      if (filteredItems.contains(itemName))
                        IconButton(
                            onPressed: () {
                              setState(() {
                                deleteLike(itemName);
                              });
                            },
                            icon: Icon(Icons.star))
                      else if (!filteredItems.contains(itemName))
                        IconButton(
                            onPressed: () {
                              setState(() {
                                addLike(itemName);
                              });
                            },
                            icon: Icon(Icons.star_border))
                    ],
                  ),
                ),
                if (locate.length - 1 != index)
                  Divider(
                    height: 0.1,
                    color: Colors.black,
                  )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String searchText = '';
  List<String> searchLike(String text) {
    return likeList
        .where((item) => item.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  List<String> searchItems(String text) {
    return beachname_list
        .where((item) => item.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  void _updateFilteredItems(String text) {
    setState(() {
      searchedItems = searchItems(text);
    });
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.43,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (text) {
                    setState(() {
                      _updateFilteredItems(text);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: '검색어 입력',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                searchedItems.isEmpty
                    ? Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(16.0), // 원하는 반지름 값으로 설정
                            color: Color.fromARGB(31, 137, 137, 137), // 배경색 설정
                          ),
                          child: ListView.builder(
                            itemCount: beachname_list.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          titleText = beachname_list[index];
                                          saveTitleText(beachname_list[index]);
                                          fetchData(titleText!);
                                          Navigator.of(context).pop();
                                        });
                                        print(beachname_list[index]);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          beachname_list[index],
                                          style: textStyle(18, Colors.black,
                                              FontWeight.normal, 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (beachname_list.length - 1 != index)
                                    Divider(
                                      height: 0.1,
                                      color: Colors.black,
                                    )
                                ],
                              );
                            },
                          ),
                        ),
                      )
                    : Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(16.0), // 원하는 반지름 값으로 설정
                            color: Color.fromARGB(31, 137, 137, 137), // 배경색 설정
                          ),
                          child: ListView.builder(
                            itemCount: searchedItems.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          titleText = searchedItems[index];
                                          saveTitleText(searchedItems[index]);
                                          fetchData(titleText!);
                                          Navigator.of(context).pop();
                                        });
                                        print(beachname_list[index]);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          searchedItems[index],
                                          style: textStyle(18, Colors.black,
                                              FontWeight.normal, 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (searchedItems.length - 1 != index)
                                    Divider(
                                      height: 0.1,
                                      color: Colors.black,
                                    )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      // 다이얼로그가 닫힐 때 호출되는 콜백 함수
      setState(() {
        // filteredItems를 초기화하여 리셋
        searchedItems = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> likeItems = searchLike(searchText);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            if (_Marine_Weather == null) CircularProgressIndicator(),
            if (_Marine_Weather != null)
              Text(
                titleText!,
                style: textStyle(20, Colors.black, FontWeight.normal, 1.2),
              ),
            if (likeItems.contains(titleText))
              IconButton(
                onPressed: () {
                  setState(() {
                    deleteLike(titleText!);
                  });
                },
                icon: Icon(Icons.star),
              ),
            if (!likeItems.contains(titleText))
              IconButton(
                onPressed: () {
                  setState(() {
                    addLike(titleText!);
                  });
                },
                icon: Icon(Icons.star_border),
              ),
          ],
        ),
        backgroundColor: Colors.blue,
        elevation: 0.0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _showSearchDialog,
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                print(likeItems);
                openDrawer();
              });
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              tileColor: Colors.blue,
              title: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "즐겨찾기",
                          style: textStyle(
                              24, Colors.white, FontWeight.normal, 1.0),
                        ),
                        IconButton(
                          onPressed: () {
                            toggleDropDown("like");
                            print(likeItems);
                          },
                          icon: Icon(Icons.keyboard_arrow_down),
                          iconSize: 50,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (istoggleDropdown_like == false)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (likeItems.isNotEmpty)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                    _make_Darwer(likeItems, "like", likeItems),
                  ],
                ),
              ),
            ListTile(
              title: Text(location[0]),
              onTap: () {
                toggleDropDown(location[0]);
              },
            ),
            istoggleDropdown_Incheon
                ? Divider(
                    height: 1.0,
                    color: Colors.black,
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _make_Darwer(incheon, location[0], likeItems),
                      ],
                    ),
                  ),
            ListTile(
              title: Text(location[1]),
              onTap: () {
                toggleDropDown(location[1]);
              },
            ),
            istoggleDropdown_GWD
                ? Divider(
                    height: 1.0,
                    color: Colors.black,
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _make_Darwer(gwd, location[1], likeItems),
                      ],
                    ),
                  ),
            ListTile(
              title: Text(location[2]),
              onTap: () {
                toggleDropDown(location[2]);
              },
            ),
            istoggleDropdown_Ulsan
                ? Divider(
                    height: 1.0,
                    color: Colors.black,
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _make_Darwer(Ulsan, location[2], likeItems),
                      ],
                    ),
                  ),
            ListTile(
              title: Text(location[3]),
              onTap: () {
                toggleDropDown(location[3]);
              },
            ),
            istoggleDropdown_Busan
                ? Divider(
                    height: 1.0,
                    color: Colors.black,
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _make_Darwer(Busan, location[3], likeItems),
                      ],
                    ),
                  ),
            ListTile(
              title: Text(location[4]),
              onTap: () {
                toggleDropDown(location[4]);
              },
            ),
            istoggleDropdown_Jeju
                ? Divider(
                    height: 1.0,
                    color: Colors.black,
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _make_Darwer(Jeju, location[4], likeItems),
                      ],
                    ),
                  ),
            ListTile(
              title: Text(location[5]),
              onTap: () {
                toggleDropDown(location[5]);
              },
            ),
            istoggleDropdown_GG
                ? Divider(
                    height: 1.0,
                    color: Colors.black,
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _make_Darwer(GG, location[5], likeItems),
                      ],
                    ),
                  ),
            ListTile(
              title: Text(location[6]),
              onTap: () {
                toggleDropDown(location[6]);
              },
            ),
            istoggleDropdown_CCND
                ? Divider(
                    height: 1.0,
                    color: Colors.black,
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _make_Darwer(CCND, location[6], likeItems),
                      ],
                    ),
                  ),
            ListTile(
              title: Text(location[7]),
              onTap: () {
                toggleDropDown(location[7]);
              },
            ),
            istoggleDropdown_JB
                ? Divider(
                    height: 1.0,
                    color: Colors.black,
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _make_Darwer(JB, location[7], likeItems),
                      ],
                    ),
                  ),
            ListTile(
              title: Text(location[8]),
              onTap: () {
                toggleDropDown(location[8]);
              },
            ),
            istoggleDropdown_JN
                ? Divider(
                    height: 1.0,
                    color: Colors.black,
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _make_Darwer(JN, location[8], likeItems),
                      ],
                    ),
                  ),
            ListTile(
              title: Text(location[9]),
              onTap: () {
                toggleDropDown(location[9]);
              },
            ),
            istoggleDropdown_GB
                ? Divider(
                    height: 1.0,
                    color: Colors.black,
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _make_Darwer(GB, location[9], likeItems),
                      ],
                    ),
                  ),
            ListTile(
              title: Text(location[10]),
              onTap: () {
                toggleDropDown(location[10]);
              },
            ),
            istoggleDropdown_GN
                ? Divider(
                    height: 1.0,
                    color: Colors.black,
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _make_Darwer(GN, location[10], likeItems),
                      ],
                    ),
                  ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_Marine_Weather == null)
              Container(
                height: MediaQuery.of(context).size.height * 0.68,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Column(
                children: List.generate(_Marine_Weather.length, (index) {
                  final itemName = _Marine_Weather[index];
                  return Column(
                    children: [
                      if (nowDate.toString() == itemName[8] ||
                          (nowDate! + 1).toString() == itemName[8] ||
                          (nowDate! + 2).toString() == itemName[8])
                        Column(
                          children: [
                            if (itemName[9] == "00:00")
                              Column(
                                children: [
                                  Container(
                                    color: Colors.blue[100],
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.001,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: itemName[8],
                                                style: textStyle(
                                                  22,
                                                  Colors.black,
                                                  FontWeight.normal,
                                                  2.0,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: DateFormat(
                                                            ' EEEE', 'ko_KR')
                                                        .format(DateTime.parse(
                                                            itemName[8])),
                                                    style: textStyle(
                                                      22,
                                                      Colors.black,
                                                      FontWeight.normal,
                                                      2.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.001,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            child: Center(
                                                child: Text(
                                              "시간",
                                              style: TextStyle(fontSize: 18),
                                            )),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            child: Center(
                                                child: Text(
                                              "기온",
                                              style: TextStyle(fontSize: 18),
                                            )),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            child: Center(
                                                child: Text(
                                              "풍속",
                                              style: TextStyle(fontSize: 18),
                                            )),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            child: Center(
                                                child: Text(
                                              "파도",
                                              style: TextStyle(fontSize: 18),
                                            )),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            child: Center(
                                                child: Text(
                                              "날씨",
                                              style: TextStyle(fontSize: 18),
                                            )),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            child: Center(
                                                child: Text(
                                              "강수량",
                                              style: TextStyle(fontSize: 18),
                                            )),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            child: Center(
                                                child: Text(
                                              "습도",
                                              style: TextStyle(fontSize: 18),
                                            )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5)
                                    ],
                                  ),
                                ],
                              ),
                            Column(
                              children: [
                                Divider(
                                  height: 0.1,
                                  color: Colors.black,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.14,
                                      child: Center(
                                        child: Text(
                                          itemName[9],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.14,
                                      child: Center(
                                          child: Text(
                                        itemName[0] + " º",
                                      )),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.14,
                                      child: Center(
                                          child: Text(
                                        itemName[1] + "m/s",
                                      )),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.14,
                                      child: Center(
                                        child: Text(
                                          itemName[5] + "m",
                                        ),
                                      ),
                                    ),
                                    if (itemName[6] != "강수없음")
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        child: Center(
                                            child: Column(
                                          children: [
                                            Icon(
                                              Icons.beach_access_outlined,
                                            ),
                                            Text(
                                              itemName[4] + "%",
                                            ),
                                          ],
                                        )),
                                      ),
                                    if (itemName[6] == "강수없음" &&
                                        itemName[2] == "4")
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        child: Center(
                                            child: Column(
                                          children: [
                                            Icon(
                                              Icons.wb_cloudy,
                                              color: Colors.grey[700],
                                            ),
                                            Text(
                                              itemName[4] + "%",
                                            ),
                                          ],
                                        )),
                                      ),
                                    if (itemName[6] == "강수없음" &&
                                        itemName[2] == "3")
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        child: Center(
                                            child: Column(
                                          children: [
                                            Icon(
                                              Icons.wb_twilight,
                                              color: Colors.grey[700],
                                            ),
                                            Text(
                                              itemName[4] + "%",
                                            ),
                                          ],
                                        )),
                                      ),
                                    if (itemName[6] == "강수없음" &&
                                        itemName[2] == "1")
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        child: Center(
                                            child: Column(
                                          children: [
                                            Icon(Icons.wb_sunny),
                                            Text(
                                              itemName[4] + "%",
                                            ),
                                          ],
                                        )),
                                      ),
                                    if (itemName[6] == "강수없음")
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        child: Center(
                                          child: Text(
                                            "X",
                                          ),
                                        ),
                                      ),
                                    if (itemName[6] != "강수없음")
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        child: Center(
                                          child: Text(
                                            itemName[6],
                                          ),
                                        ),
                                      ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.14,
                                      child: Center(
                                        child: Text(
                                          itemName[7] + "%",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 0.1,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  );
                }).toList(),
              ),
          ],
        ),
      ),
      backgroundColor: Colors.white10,
    );
  }

  //**지역 */
  List<String> location = [
    "인천",
    "강원도",
    "울산",
    "부산",
    "제주도",
    "경기도",
    "충청남도",
    "전라북도",
    "전라남도",
    "경상북도",
    "경상남도"
  ];

  List<String> incheon = [
    '을왕리 해수욕장',
    '왕산 해수욕장',
    '하나개 해수욕장',
    '민머루 해수욕장',
    '장경리 해수욕장',
    '옹암 해수욕장',
    '수기 해수욕장',
    '동막 해수욕장',
    '서포리 해수욕장',
    '십리포 해수욕장',
    '굴업 해수욕장',
    '떼뿌루 해수욕장',
    '밧지름 해수욕장',
    '한들 해수욕장',
    '큰풀안 해수욕장',
    '장골 해수욕장',
    '벌안 해수욕장',
    '지두리 해수욕장',
    '모래울 해수욕장',
    '큰말 해수욕장',
    '진촌 해수욕장',
    '작은풀안 해수욕장',
    '이일레 해수욕장',
    '문갑 해수욕장',
    '계남 해수욕장',
    '노가리해수욕장',
    '낭하리해변',
    '용담리해변',
    '덕적도 능동자갈마당',
    '소청예동 해수욕장',
    '사곶 해수욕장',
    '구리동 해수욕장',
    '실미 해수욕장',
    '몽돌해수욕장 (옹진군)',
    '거잠포해변',
    '용유도 마시안해변',
    '선녀바위해수욕장',
    '용유도해변',
    '대청도 농여해변',
    '백령도 콩돌해변',
  ];

  List<String> gwd = [
    '원평 해수욕장',
    '강문 해수욕장',
    '송정 해수욕장',
    '안목 해수욕장',
    '남항진 해수욕장',
    '경포 해수욕장',
    '사근진 해수욕장',
    '순긋 해수욕장',
    '주문진 해수욕장',
    '안인 해수욕장',
    '정동진 해수욕장',
    '등명 해수욕장',
    '도직 해수욕장',
    '옥계 해수욕장',
    '금진 해수욕장',
    '하평해변',
    '사천 해수욕장',
    '영진 해수욕장',
    '연곡 해수욕장',
    '추암 해수욕장',
    '어달 해수욕장',
    '망상 해수욕장',
    '노봉 해수욕장',
    '등대 해수욕장',
    '속초 해수욕장',
    '외옹치 해수욕장',
    '삼척 해수욕장',
    '작은후진 해수욕장',
    '증산 해수욕장',
    '오분해변',
    '상맹방 해수욕장',
    '하맹방 해수욕장',
    '맹방 해수욕장',
    '덕산 해수욕장',
    '부남해변',
    '궁촌 해수욕장',
    '원평 해수욕장',
    '문암 해수욕장',
    '용화 해수욕장',
    '장호 해수욕장',
    '거진1리 해수욕장',
    '거진11리 해수욕장',
    '대진1리 해수욕장',
    '대진5리 해수욕장',
    '화진포 해수욕장',
    '초도리 해수욕장',
    '반암리 해수욕장',
    '마차진 해수욕장',
    '명파 해수욕장',
    '송지호 해수욕장',
    '봉수대 해수욕장',
    '가진리 해수욕장',
    '공현1리 해수욕장',
    '공현2리 해수욕장',
    '삼포 해수욕장',
    '삼포2리 해수욕장',
    '백도 해수욕장',
    '문암2리해변',
    '자작도 해수욕장',
    '천진 해수욕장',
    '청간 해수욕장',
    '아야진 해수욕장',
    '교암리 해수욕장',
    '봉포 해수욕장',
    '오산 해수욕장',
    '잔교리 해수욕장',
    '하조대 해수욕장',
    '죽도 해수욕장',
    '갯마을 해수욕장',
    '인구 해수욕장',
    '동산 해수욕장',
    '동산포구 해수욕장',
    '광진리 해수욕장',
    '원포리 해수욕장',
    '지경 해수욕장',
    '남애1리 해수욕장',
    '남애3리 해수욕장',
    '물치 해수욕장',
    '정암 해수욕장',
    '낙산 해수욕장',
    '설악 해수욕장',
    '사천진 해수욕장',
    '켄싱턴리조트 해수욕장',
    '송지호오토캠핑 해수욕장',
    '기사문 해수욕장',
    '월천해변',
    '임원해변',
    '신남해변',
    '초곡해수욕장',
    '한재밑해변',
    '감추해변',
    '한섬해변&한섬감성바닷길',
    '고불개해변',
    '하평해변(동해)',
    '염전해변',
    '북분리 해수욕장',
    '순포해변',
    '소돌해수욕장',
    '청시행비치',
    '중광정해변',
    '화진포콘도 해수욕장',
    '향호해수욕장',
    '애견전용해수욕장 멍비치',
    '38해변',
  ];

  List<String> Ulsan = [
    '나사해변(나사리해수욕장)',
    '솔개해수욕장',
    '주전몽돌해변',
    '강동몽돌해변',
    '신명·정자해변',
    '일산 해수욕장',
    '진하 해수욕장',
  ];

  List<String> Busan = [
    '몰운대',
    '감지해변',
    '송도 해수욕장(부산)',
    '해운대 해수욕장',
    '송정 해수욕장',
    '광안리 해수욕장',
    '임랑 해수욕장',
    '다대포 해수욕장',
    '일광 해수욕장',
  ];

  List<String> Jeju = [
    '사계해안',
    '하모해변',
    '논짓물',
    '한담해변',
    '알작지',
    '검멀레해변',
    '세화해변',
    '평대해변',
    '제주신흥해수욕장',
    '월정리해수욕장',
    '표선해비치',
    '화순금모래 해수욕장',
    '신양섭지코지 해수욕장',
    '곽지과물 해수욕장',
    '협재 해수욕장',
    '중문ㆍ색달 해수욕장',
    '이호테우 해수욕장',
    '삼양검은모래 해수욕장',
    '함덕서우봉 해수욕장',
    '하고수동 해수욕장',
    '김녕성세기 해수욕장',
    '금능으뜸원 해수욕장',
    '하도 해수욕장',
    '하효쇠소깍 해수욕장',
    '종달 해수욕장',
    '서빈백사 해수욕장',
    '추자모진이 해수욕장',
  ];

  List<String> GG = [
    '제부도 해수욕장',
    '궁평리 해수욕장',
    '구봉솔숲해수욕장',
    '방아머리해수욕장',
  ];

  List<String> CCND = [
    '대천 해수욕장',
    '벌천포 해수욕장',
    '춘장대 해수욕장',
    '꽃지 해수욕장',
    '구름포 해수욕장',
    '마검포 해수욕장',
    '용두 해수욕장',
    '독산(홀뫼) 해수욕장',
    '장안 해수욕장',
    '무창포 해수욕장',
    '밧개 해수욕장',
    '두여 해수욕장',
    '안면 해수욕장',
    '삼봉 해수욕장',
    '백사장 해수욕장',
    '방포 해수욕장',
    '기지포 해수욕장',
    '샛별 해수욕장',
    '장삼포 해수욕장',
    '바람아래 해수욕장',
    '몽산포 해수욕장',
    '달산포 해수욕장',
    '청포대 해수욕장',
    '갈음이 해수욕장',
    '연포 해수욕장',
    '천리포 해수욕장',
    '의항 해수욕장',
    '만리포 해수욕장',
    '어은돌 해수욕장',
    '파도리 해수욕장',
    '학암포 해수욕장',
    '구례포 해수욕장',
    '신두리 해수욕장',
    '꾸지나무골 해수욕장',
    '난지도 해수욕장',
    '원산도 해수욕장',
    '오봉산 해수욕장',
    '명장섬 해수욕장',
    '당산 해수욕장',
    '통개 해수욕장',
    '거멀너머 해수욕장',
    '진너머 해수욕장',
    '갈목해변',
    '비인해수욕장',
    '띠섬목해변',
    '사창해수욕장',
    '운여해변',
    '두에기해변',
    '원안해수욕장',
    '음포해수욕장',
    '먼동해수욕장',
    '사목해수욕장',
    '황금산몽돌해변',
    '밤섬 해수욕장',
    '당너머 해수욕장',
    '호도 해수욕장',
    '곰섬 해수욕장',
    '백리포(방주골) 해수욕장',
    '왜목마을 해수욕장',
    '고파도 해수욕장',
  ];

  List<String> JB = [
    '선유도 해수욕장',
    '동호 해수욕장',
    '모항 갯벌 해수욕장',
    '격포 해수욕장',
    '고사포 해수욕장',
    '변산 해수욕장',
    '위도 해수욕장',
    '상록해수욕장',
    '옥돌해수욕장',
    '몽돌해수욕장/몽돌해변',
    '동호 해수욕장',
    '구시포 해수욕장',
  ];

  List<String> JN = [
    '보옥리 공룡알해변',
    '진산리해수욕장',
    '미라리해수욕장',
    '지리해수욕장',
    '정도리해변',
    '오천몽돌해변',
    '송평해변',
    '남성리해수욕장',
    '띠밭넘어해변',
    '외달도 해수욕장',
    '안도 해수욕장',
    '장등 해수욕장',
    '모사금 해수욕장',
    '만성리검은모래 해수욕장',
    '신덕 해수욕장',
    '방죽포 해수욕장',
    '사도 해수욕장',
    '거문도(유림) 해수욕장',
    '용동 해수욕장',
    '익금 해수욕장',
    '연소 해수욕장',
    '발포 해수욕장',
    '염포 해수욕장',
    '나로우주 해수욕장',
    '풍류 해수욕장',
    '대전 해수욕장',
    '남열해돋이 해수욕장',
    '덕흥 해수욕장',
    '율포 해수욕장',
    '수문 해수욕장',
    '사구미 해수욕장',
    '하트해변(하누넘해수욕장)',
    '송호땅끝 해수욕장',
    '홀통 해수욕장',
    '톱머리 해수욕장',
    '돌머리 해수욕장',
    '가마미 해수욕장',
    '송이도 해수욕장',
    '금일해당화 해수욕장',
    '신지명사십리 해수욕장',
    '가사동백숲 해수욕장',
    '동고 해수욕장',
    '지리청송 해수욕장',
    '통리솔밭 해수욕장',
    '중리 해수욕장',
    '예송갯돌 해수욕장',
    '금곡 해수욕장',
    '가계 해수욕장',
    '금갑 해수욕장',
    '관매도 해수욕장',
    '신전 해수욕장',
    '분계 해수욕장',
    '우전 해수욕장',
    '대광 해수욕장',
    '백길 해수욕장',
    '하트 해수욕장',
    '시목 해수욕장',
    '돈목 해수욕장',
    '금장 해수욕장',
    '무술목 해수욕장',
    '화포해변',
    '둔장해변',
    '배알도해수욕장',
    '조금나루해수욕장',
    '안악해수욕장',
    '손죽 해수욕장',
    '신흥 해수욕장',
    '모래미 해변',
    '황성금리 해수욕장',
    '추포 해수욕장',
    '신도 해수욕장',
    '배낭기미 해수욕장',
    '홍도 해수욕장',
    '낭도 해수욕장',
    '정강 해수욕장',
    '대풍 해수욕장',
    '웅천 해수욕장',
    '서도 해수욕장',
    '설레미 해수욕장',
    '짱뚱어 해수욕장',
  ];

  List<String> GB = [
    '나아해변',
    '대진 해수욕장',
    '신창 간이 해수욕장',
    '흥환간이해수욕장',
    '송도해변(포항)',
    '구룡포 해수욕장',
    '도구 해수욕장',
    '영일대 해수욕장',
    '칠포 해수욕장',
    '월포 해수욕장',
    '화진 해수욕장',
    '용한1리해수욕장',
    '전촌솔밭해변',
    '나정고운모래해변',
    '오류고아라해변',
    '봉길대왕암해변',
    '관성솔밭해변',
    '남호 해수욕장',
    '오보 해수욕장',
    '장사 해수욕장',
    '경정 해수욕장',
    '대진 해수욕장',
    '하저리 해수욕장',
    '고래불 해수욕장',
    '나곡 해수욕장',
    '망양정 해수욕장',
    '기성망양 해수욕장',
    '구산 해수욕장',
    '봉평 해수욕장',
    '후정 해수욕장',
    '오도1리해수욕장',
    '조사리간이해수욕장',
    '오포해수욕장',
    '덕천해수욕장',
    '영리해수욕장',
    '두곡.월포 해수욕장',
    '하트해변',
    '후포 해수욕장',
  ];

  List<String> GN = [
    '덕동몽돌해수욕장',
    '유동해변',
    '흰작살해변',
    '천하몽돌해수욕장',
    '남해 가천 해변과 암수바위',
    '연대도 해수욕장',
    '선구몽돌해변',
    '항도몽돌해수욕장',
    '구미동해수욕장',
    '모상개해수욕장',
    '죽림해수욕장',
    '두모몽돌해변',
    '비진도 해수욕장',
    '덕포 해수욕장',
    '와현모래숲해변',
    '흥남 해수욕장',
    '황포 해수욕장',
    '농소몽돌 해수욕장',
    '구조라 해수욕장',
    '학동흑진주몽돌해변',
    '명사 해수욕장',
    '함목 해수욕장',
    '여차몽돌 해수욕장',
    '설리 해수욕장',
    '상주은모래비치',
    '송정솔바람해변',
    '사촌 해수욕장',
    '남일대 해수욕장',
    '덕동 해수욕장',
    '수륙 해수욕장',
    '봉암몽돌 해수욕장',
    '물안(옆개) 해수욕장',
    '덕원 해수욕장',
    '사량 대항 해수욕장',
    '사곡 해수욕장',
    '구영 해수욕장',
    '망치해변 해수욕장',
    '옥계 해수욕장',
    '광암 해수욕장',
  ];

  List<String> beachname_list = [
    '을왕리 해수욕장',
    '왕산 해수욕장',
    '하나개 해수욕장',
    '사계해안',
    '하모해변',
    '민머루 해수욕장',
    '장경리 해수욕장',
    '옹암 해수욕장',
    '논짓물',
    '수기 해수욕장',
    '동막 해수욕장',
    '서포리 해수욕장',
    '십리포 해수욕장',
    '굴업 해수욕장',
    '떼뿌루 해수욕장',
    '밧지름 해수욕장',
    '한담해변',
    '알작지',
    '한들 해수욕장',
    '큰풀안 해수욕장',
    '장골 해수욕장',
    '벌안 해수욕장',
    '지두리 해수욕장',
    '검멀레해변',
    '세화해변',
    '모래울 해수욕장',
    '평대해변',
    '제주신흥해수욕장',
    '월정리해수욕장',
    '큰말 해수욕장',
    '진촌 해수욕장',
    '보옥리 공룡알해변',
    '진산리해수욕장',
    '작은풀안 해수욕장',
    '이일레 해수욕장',
    '문갑 해수욕장',
    '계남 해수욕장',
    '미라리해수욕장',
    '제부도 해수욕장',
    '궁평리 해수욕장',
    '대천 해수욕장',
    '벌천포 해수욕장',
    '춘장대 해수욕장',
    '꽃지 해수욕장',
    '구름포 해수욕장',
    '마검포 해수욕장',
    '지리해수욕장',
    '용두 해수욕장',
    '독산(홀뫼) 해수욕장',
    '장안 해수욕장',
    '무창포 해수욕장',
    '밧개 해수욕장',
    '두여 해수욕장',
    '안면 해수욕장',
    '삼봉 해수욕장',
    '백사장 해수욕장',
    '방포 해수욕장',
    '기지포 해수욕장',
    '샛별 해수욕장',
    '정도리해변',
    '장삼포 해수욕장',
    '바람아래 해수욕장',
    '몽산포 해수욕장',
    '달산포 해수욕장',
    '청포대 해수욕장',
    '갈음이 해수욕장',
    '연포 해수욕장',
    '천리포 해수욕장',
    '의항 해수욕장',
    '만리포 해수욕장',
    '어은돌 해수욕장',
    '파도리 해수욕장',
    '학암포 해수욕장',
    '구례포 해수욕장',
    '신두리 해수욕장',
    '오천몽돌해변',
    '꾸지나무골 해수욕장',
    '난지도 해수욕장',
    '원산도 해수욕장',
    '송평해변',
    '남성리해수욕장',
    '오봉산 해수욕장',
    '명장섬 해수욕장',
    '덕동몽돌해수욕장',
    '유동해변',
    '당산 해수욕장',
    '통개 해수욕장',
    '띠밭넘어해변',
    '거멀너머 해수욕장',
    '진너머 해수욕장',
    '선유도 해수욕장',
    '동호 해수욕장',
    '모항 갯벌 해수욕장',
    '흰작살해변',
    '격포 해수욕장',
    '고사포 해수욕장',
    '변산 해수욕장',
    '위도 해수욕장',
    '외달도 해수욕장',
    '천하몽돌해수욕장',
    '안도 해수욕장',
    '장등 해수욕장',
    '모사금 해수욕장',
    '만성리검은모래 해수욕장',
    '신덕 해수욕장',
    '방죽포 해수욕장',
    '사도 해수욕장',
    '거문도(유림) 해수욕장',
    '남해 가천 해변과 암수바위',
    '연대도 해수욕장',
    '선구몽돌해변',
    '용동 해수욕장',
    '익금 해수욕장',
    '연소 해수욕장',
    '발포 해수욕장',
    '염포 해수욕장',
    '나로우주 해수욕장',
    '풍류 해수욕장',
    '대전 해수욕장',
    '남열해돋이 해수욕장',
    '덕흥 해수욕장',
    '율포 해수욕장',
    '수문 해수욕장',
    '항도몽돌해수욕장',
    '사구미 해수욕장',
    '하트해변(하누넘해수욕장)',
    '송호땅끝 해수욕장',
    '홀통 해수욕장',
    '톱머리 해수욕장',
    '구미동해수욕장',
    '돌머리 해수욕장',
    '모상개해수욕장',
    '가마미 해수욕장',
    '송이도 해수욕장',
    '금일해당화 해수욕장',
    '신지명사십리 해수욕장',
    '가사동백숲 해수욕장',
    '동고 해수욕장',
    '지리청송 해수욕장',
    '통리솔밭 해수욕장',
    '중리 해수욕장',
    '예송갯돌 해수욕장',
    '금곡 해수욕장',
    '가계 해수욕장',
    '금갑 해수욕장',
    '죽림해수욕장',
    '관매도 해수욕장',
    '신전 해수욕장',
    '분계 해수욕장',
    '우전 해수욕장',
    '대광 해수욕장',
    '백길 해수욕장',
    '원평 해수욕장',
    '하트 해수욕장',
    '시목 해수욕장',
    '돈목 해수욕장',
    '금장 해수욕장',
    '무술목 해수욕장',
    '화포해변',
    '둔장해변',
    '배알도해수욕장',
    '두모몽돌해변',
    '조금나루해수욕장',
    '몰운대',
    '감지해변',
    '안악해수욕장',
    '손죽 해수욕장',
    '신흥 해수욕장',
    '나사해변(나사리해수욕장)',
    '모래미 해변',
    '솔개해수욕장',
    '강문 해수욕장',
    '송정 해수욕장',
    '안목 해수욕장',
    '남항진 해수욕장',
    '경포 해수욕장',
    '사근진 해수욕장',
    '순긋 해수욕장',
    '주문진 해수욕장',
    '주전몽돌해변',
    '안인 해수욕장',
    '정동진 해수욕장',
    '등명 해수욕장',
    '도직 해수욕장',
    '옥계 해수욕장',
    '금진 해수욕장',
    '하평해변',
    '사천 해수욕장',
    '영진 해수욕장',
    '연곡 해수욕장',
    '상록해수욕장',
    '강동몽돌해변',
    '신명·정자해변',
    '나아해변',
    '추암 해수욕장',
    '어달 해수욕장',
    '대진 해수욕장',
    '망상 해수욕장',
    '노봉 해수욕장',
    '등대 해수욕장',
    '속초 해수욕장',
    '외옹치 해수욕장',
    '삼척 해수욕장',
    '작은후진 해수욕장',
    '증산 해수욕장',
    '오분해변',
    '옥돌해수욕장',
    '몽돌해수욕장/몽돌해변',
    '신창 간이 해수욕장',
    '흥환간이해수욕장',
    '송도해변(포항)',
    '상맹방 해수욕장',
    '하맹방 해수욕장',
    '맹방 해수욕장',
    '덕산 해수욕장',
    '부남해변',
    '궁촌 해수욕장',
    '원평 해수욕장',
    '문암 해수욕장',
    '용화 해수욕장',
    '장호 해수욕장',
    '거진1리 해수욕장',
    '거진11리 해수욕장',
    '대진1리 해수욕장',
    '대진5리 해수욕장',
    '화진포 해수욕장',
    '초도리 해수욕장',
    '반암리 해수욕장',
    '마차진 해수욕장',
    '명파 해수욕장',
    '송지호 해수욕장',
    '봉수대 해수욕장',
    '가진리 해수욕장',
    '공현1리 해수욕장',
    '공현2리 해수욕장',
    '삼포 해수욕장',
    '삼포2리 해수욕장',
    '백도 해수욕장',
    '문암2리해변',
    '자작도 해수욕장',
    '천진 해수욕장',
    '청간 해수욕장',
    '아야진 해수욕장',
    '교암리 해수욕장',
    '봉포 해수욕장',
    '동호 해수욕장',
    '오산 해수욕장',
    '잔교리 해수욕장',
    '하조대 해수욕장',
    '죽도 해수욕장',
    '갯마을 해수욕장',
    '인구 해수욕장',
    '동산 해수욕장',
    '동산포구 해수욕장',
    '광진리 해수욕장',
    '원포리 해수욕장',
    '지경 해수욕장',
    '남애1리 해수욕장',
    '남애3리 해수욕장',
    '물치 해수욕장',
    '정암 해수욕장',
    '낙산 해수욕장',
    '설악 해수욕장',
    '사천진 해수욕장',
    '켄싱턴리조트 해수욕장',
    '송지호오토캠핑 해수욕장',
    '기사문 해수욕장',
    '송도 해수욕장(부산)',
    '구룡포 해수욕장',
    '도구 해수욕장',
    '영일대 해수욕장',
    '칠포 해수욕장',
    '월포 해수욕장',
    '화진 해수욕장',
    '갈목해변',
    '용한1리해수욕장',
    '전촌솔밭해변',
    '나정고운모래해변',
    '오류고아라해변',
    '봉길대왕암해변',
    '관성솔밭해변',
    '남호 해수욕장',
    '오보 해수욕장',
    '장사 해수욕장',
    '경정 해수욕장',
    '대진 해수욕장',
    '하저리 해수욕장',
    '고래불 해수욕장',
    '나곡 해수욕장',
    '망양정 해수욕장',
    '기성망양 해수욕장',
    '구산 해수욕장',
    '봉평 해수욕장',
    '후정 해수욕장',
    '비인해수욕장',
    '띠섬목해변',
    '오도1리해수욕장',
    '조사리간이해수욕장',
    '오포해수욕장',
    '사창해수욕장',
    '운여해변',
    '두에기해변',
    '덕천해수욕장',
    '해운대 해수욕장',
    '송정 해수욕장',
    '광안리 해수욕장',
    '임랑 해수욕장',
    '다대포 해수욕장',
    '일광 해수욕장',
    '영리해수욕장',
    '일산 해수욕장',
    '원안해수욕장',
    '진하 해수욕장',
    '비진도 해수욕장',
    '덕포 해수욕장',
    '와현모래숲해변',
    '흥남 해수욕장',
    '음포해수욕장',
    '황포 해수욕장',
    '농소몽돌 해수욕장',
    '구조라 해수욕장',
    '학동흑진주몽돌해변',
    '명사 해수욕장',
    '함목 해수욕장',
    '여차몽돌 해수욕장',
    '설리 해수욕장',
    '상주은모래비치',
    '먼동해수욕장',
    '송정솔바람해변',
    '두곡.월포 해수욕장',
    '사촌 해수욕장',
    '남일대 해수욕장',
    '덕동 해수욕장',
    '수륙 해수욕장',
    '사목해수욕장',
    '황금산몽돌해변',
    '봉암몽돌 해수욕장',
    '하트해변',
    '월천해변',
    '물안(옆개) 해수욕장',
    '덕원 해수욕장',
    '표선해비치',
    '화순금모래 해수욕장',
    '신양섭지코지 해수욕장',
    '곽지과물 해수욕장',
    '협재 해수욕장',
    '중문ㆍ색달 해수욕장',
    '이호테우 해수욕장',
    '삼양검은모래 해수욕장',
    '임원해변',
    '노가리해수욕장',
    '함덕서우봉 해수욕장',
    '하고수동 해수욕장',
    '김녕성세기 해수욕장',
    '금능으뜸원 해수욕장',
    '낭하리해변',
    '하도 해수욕장',
    '용담리해변',
    '신남해변',
    '사량 대항 해수욕장',
    '덕적도 능동자갈마당',
    '구봉솔숲해수욕장',
    '후포 해수욕장',
    '소청예동 해수욕장',
    '사곶 해수욕장',
    '구리동 해수욕장',
    '실미 해수욕장',
    '황성금리 해수욕장',
    '추포 해수욕장',
    '신도 해수욕장',
    '배낭기미 해수욕장',
    '홍도 해수욕장',
    '낭도 해수욕장',
    '정강 해수욕장',
    '대풍 해수욕장',
    '구시포 해수욕장',
    '하효쇠소깍 해수욕장',
    '종달 해수욕장',
    '서빈백사 해수욕장',
    '추자모진이 해수욕장',
    '밤섬 해수욕장',
    '몽돌해수욕장 (옹진군)',
    '방아머리해수욕장',
    '당너머 해수욕장',
    '호도 해수욕장',
    '초곡해수욕장',
    '곰섬 해수욕장',
    '백리포(방주골) 해수욕장',
    '사곡 해수욕장',
    '구영 해수욕장',
    '망치해변 해수욕장',
    '옥계 해수욕장',
    '한재밑해변',
    '거잠포해변',
    '용유도 마시안해변',
    '선녀바위해수욕장',
    '용유도해변',
    '왜목마을 해수욕장',
    '감추해변',
    '한섬해변&한섬감성바닷길',
    '고불개해변',
    '하평해변(동해)',
    '염전해변',
    '북분리 해수욕장',
    '순포해변',
    '대청도 농여해변',
    '소돌해수욕장',
    '고파도 해수욕장',
    '광암 해수욕장',
    '청시행비치',
    '웅천 해수욕장',
    '중광정해변',
    '화진포콘도 해수욕장',
    '서도 해수욕장',
    '설레미 해수욕장',
    '짱뚱어 해수욕장',
    '향호해수욕장',
    '백령도 콩돌해변',
    '애견전용해수욕장 멍비치',
    '38해변',
  ];
}
