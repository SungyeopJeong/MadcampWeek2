import 'dart:convert';
import 'package:devil/addstudy.dart';
import 'package:devil/study_model.dart';
import 'package:devil/study_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudyPage extends StatefulWidget {
  const StudyPage({Key? key}) : super(key: key);

  @override
  State<StudyPage> createState() => _StudyPage();
}

class _StudyPage extends State<StudyPage> {
  late Future studyData;

  @override
  void initState() {
    super.initState();
    studyData = fetchUserData(); // 데이터를 가져오는 비동기 함수 호출
  }

  Future fetchUserData() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/api/study'));

    if (response.statusCode == 200) {
      final List<dynamic> studyListdata = jsonDecode(response.body);
      for (var study in studyListdata) {
        final instance = StudyModel.fromJson(study);
        studyListdata.add(instance);
      }
      return studyListdata;
    } else {
      // API 호출이 실패하면 에러 메시지를 반환
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder(
                future: studyData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // 데이터가 있는 경우
                    return const Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    // 에러가 있는 경우
                    return Text('Error: ${snapshot.error}');
                  }

                  return const CircularProgressIndicator();
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudyAdd()),
                );
              },
              child: const Text('Go to Study Add Page'),
            ),
          ],
        ),
      ),
    );
  }

  ListView makeStudyList(List<StudyModel> studies) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: studies.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        var study = studies[index];
        return Study(
          name: study.name,
          category: study.category,
          description: study.description,
          max: study.max,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 20,
      ),
    );
  }
}
