import 'package:devil/models/study.dart';
import 'package:devil/pages/study_add_page.dart';
import 'package:devil/style/color.dart';
import 'package:devil/style/text.dart';
import 'package:devil/viewmodels/info_model.dart';
import 'package:devil/viewmodels/study_model.dart';
import 'package:devil/widgets/inkwell_btn.dart';
import 'package:devil/widgets/top_app_bar.dart';
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
    return RefreshIndicator(
      onRefresh: () async {
        context.read<StudyModel>().getStudies();
      },
      child: Scaffold(
        appBar: const TopAppBar(title: 'STUDY'),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 4,
                  mainAxisExtent: 48,
                ),
                itemCount: 4,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final isSelected =
                      selectedCategory == categories[index];
                  if (isSelected) {
                    return InkWellBtn(
                      btnColor: DevilColor.black,
                      radius: 12,
                      onTap: () {
                        setState(() {
                          selectedCategory = null;
                        });
                      },
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        child: Text(
                          categories[index].locale,
                          style: DevilText.bodyM
                              .copyWith(color: DevilColor.point),
                        ),
                      ),
                    );
                  }
                  return InkWellBtn(
                    btnColor: DevilColor.white,
                    radius: 12,
                    onTap: () {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: DevilColor.point),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        categories[index].locale,
                        style: DevilText.bodyM
                            .copyWith(color: DevilColor.black),
                      ),
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
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
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
          child: const Icon(Icons.add),
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      itemBuilder: (context, index) {
        var study = filteredStudies[index];
        return StudyBlock(study: study);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
  }
}
