import 'package:devil/models/study.dart';
import 'package:devil/pages/study_add_page.dart';
import 'package:devil/style/color.dart';
import 'package:devil/viewmodels/info_model.dart';
import 'package:devil/viewmodels/study_model.dart';
import 'package:flutter/material.dart';
import 'package:devil/widgets/study_block.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.navigateToLogin});

  final void Function() navigateToLogin;

  @override
  State<MainPage> createState() => _MainPageState();
}

StudyCategory? selectedCategory;

class _MainPageState extends State<MainPage> {
  StudyCategory? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final islogined = context.read<InfoModel>().isLogined;
    const categories = StudyCategory.values;
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 4,
                    ),
                    itemCount: 4,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final isSelected = selectedCategory == categories[index];
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (isSelected) {
                              selectedCategory = null;
                            } else {
                              selectedCategory = categories[index];
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isSelected ? Colors.black : DevilColor.point,
                          minimumSize: const Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
                          categories[index].locale,
                          style: TextStyle(
                              fontSize: 16,
                              color: isSelected
                                  ? DevilColor.point
                                  : DevilColor.black),
                        ),
                      );
                    },
                  ),
                ),
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
              onPressed: islogined
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StudyAddPage(),
                        ),
                      );
                    }
                  : widget.navigateToLogin,
              backgroundColor: const Color(0xFFFFA8B1),
              child: const Icon(Icons.add), // Change the color as needed
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyList(studies) {
    List<Study> filteredStudies = [];

    if (selectedCategory != null) {
      filteredStudies = studies
          .where((study) => study.category == selectedCategory?.locale)
          .toList();
    } else {
      filteredStudies = studies;
    }

    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: filteredStudies.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        var study = filteredStudies[index];
        return StudyBlock(study: study);
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 20,
      ),
    );
  }
}
