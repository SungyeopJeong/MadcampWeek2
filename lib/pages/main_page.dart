import 'package:devil/pages/study_add_page.dart';
import 'package:devil/viewmodels/study_model.dart';
import 'package:flutter/material.dart';
import 'package:devil/widgets/study_block.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  StudyCategory?
      selectedCategory; // Added variable to store the selected category

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
                    future: context.read<StudyModel>().studies,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // 데이터가 있는 경우
                        return _buildStudyList(
                            snapshot.data!.reversed.toList());
                      } else if (snapshot.hasError) {
                        // 에러가 있는 경우
                        return Text('Error: ${snapshot.error}');
                      }

                      return const Center(child: CircularProgressIndicator());
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
                  MaterialPageRoute(builder: (context) => const StudyAddPage()),
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

  Widget _buildStudyList(studies) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: studies.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        var study = studies[index];
        return StudyBlock(study: study);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
  }
}
