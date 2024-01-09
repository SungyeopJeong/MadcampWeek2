// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:devil/models/study.dart';
import 'package:devil/pages/my_page.dart';
import 'package:devil/style/color.dart';
import 'package:devil/viewmodels/info_model.dart';
import 'package:devil/viewmodels/study_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class StudyDetailPage extends StatefulWidget {
  final Study study;

  const StudyDetailPage({
    super.key,
    required this.study,
  });

  @override
  State<StudyDetailPage> createState() => _StudyDetailPageState();
}

class _StudyDetailPageState extends State<StudyDetailPage> {
  List userList = [];
  bool isme = false;
  String creatorName = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> sendPostRequest(String userId, int studyId) async {
    try {
      Map<String, dynamic> data = {
        'userid': userId,
        'studyid': studyId.toString(),
      };

      final response = await http.post(
        Uri.parse("http://172.10.7.49/api/study/join"),
        body: data,
      );
      if (response.statusCode == 200) {
        print('POST request successful: ${response.body}');
      } else {
        print('POST request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error during POST request: $e');
    }
  }

  Future<void> getData() async {
    final islogined = context.read<InfoModel>().isLogined;

    if (islogined) {
      final user = context.read<InfoModel>().user;
      await getUserData(user.id, widget.study.id!);
    } else {
      getUserData("", widget.study.id!);
    }
  }

  Future<void> getUserData(userId, int studyId) async {
    try {
      Map<String, dynamic> data = {'id': userId};

      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/study/$studyId"),
        body: data,
      );
      if (response.statusCode == 200) {
        final users = json.decode(response.body);
        setState(() {
          userList = users;
          for (Map<String, dynamic> user in userList) {
            if (user['isme'] == 1) {
              isme = true;
            }
            if (user['iscreator'] == 1) {
              creatorName = user['username'];
            }
          }
        });
        print(userList);
        print(isme);
        print(creatorName);
      } else {
        print('POST request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error during POST request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final islogined = context.read<InfoModel>().isLogined;
    if (islogined) {
      final user = context.read<InfoModel>().user;
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height:
                MediaQuery.of(context).size.height * 10, // 50% of screen height
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/sample2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 200),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        widget.study.name,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.study.description,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '스터디장',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        creatorName.isNotEmpty ? creatorName : "(알수 없음)",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        '스터디 분야',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.study.category,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        '현재 참여 인원',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.study.now}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        '스터디 인원',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.study.max}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        onPressed: islogined && !isme
                            ? () {
                                sendPostRequest(
                                    context.read<InfoModel>().user.id,
                                    widget.study.id!);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext alertContext) {
                                    return AlertDialog(
                                      title: const Text("참여되었습니다"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(alertContext).pop();
                                            Navigator.pop(context);
                                          },
                                          style: TextButton.styleFrom(
                                            textStyle: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            backgroundColor: DevilColor.point,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text("확인"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            : () {
                                Navigator.pop(context);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: islogined
                              ? (isme ? DevilColor.grey : DevilColor.black)
                              : DevilColor.grey,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          minimumSize: const Size(double.infinity, 0),
                        ),
                        child: Text(
                          islogined
                              ? (isme ? '이미 참여중인 스터디입니다' : '참여하기')
                              : '로그인 후 이용하세요',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 9,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                // Navigate back to the previous screen
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 50,
            left: 2, // 오른쪽에 배치할 위치 조정
            child: Image.asset(
              'assets/images/logo.png', // 이미지 파일의 경로 또는 이미지 위젯 사용
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
