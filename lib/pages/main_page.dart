import 'dart:convert';
import 'package:devil/pages/studyadd_page.dart';
import 'package:flutter/material.dart';
import 'package:devil/study_model.dart';
import 'package:devil/widgets/study_widget.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<dynamic> studyData;
  String selectedCategory = ""; // Added variable to store the selected category
  final List<String> categories = ["Frontend", "Backend", "App", "etc"];

  @override
  void initState() {
    super.initState();
    studyData = fetchStudyData(); //
  }

  Future fetchStudyData() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/api/study'));

    if (response.statusCode == 200) {
      final List<dynamic> studyListData = jsonDecode(response.body);
      List<StudyModel> resultList = [];

      for (var study in studyListData) {
        final instance = StudyModel.fromJson(study);
        resultList.add(instance);
      }

      resultList = resultList.reversed.toList(); //촤신순

      return resultList;
    } else {
      // API 호출이 실패하면 에러 메시지를 반환
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(
          Icons.home, // 집 모양의 아이콘
          color: Colors.black, // 아이콘의 색상
          size: 40,
        ),
        title: const Text(
          'STUDY',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 23,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: studyData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // 데이터가 있는 경우
                        return makeStudyList(snapshot.data);
                      } else if (snapshot.hasError) {
                        // 에러가 있는 경우
                        return Text('Error: ${snapshot.error}');
                      }

                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0, // Adjust the distance from the bottom
            right: 16.0, // Adjust the distance from the right
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudyAdd()),
                );
              },
              backgroundColor: const Color(0xFFFFA8B1),
              child: const Icon(Icons.add), // Change the color as needed
            ),
          ),
        ],
      ),
    );
  }

  ListView makeStudyList(studies) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: studies.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        var study = studies[index];
        return Study(
          id: study.id,
          name: study.name,
          category: study.category,
          description: study.description,
          max: int.parse(study.max),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 20,
      ),
    );
  }
}
