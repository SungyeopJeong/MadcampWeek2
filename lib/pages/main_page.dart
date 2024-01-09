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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 4,
                  mainAxisExtent: 48,
                ),
                itemCount: 4,
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    _buildCategoryBtn(categories[index]),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: context.read<StudyModel>().studies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _buildStudyList(snapshot.data!);
                  } else if (snapshot.hasError) {
                    debugPrint(snapshot.error.toString());
                    return Column(
                      children: [
                        const Spacer(flex: 1),
                        const Icon(
                          Icons.error_rounded,
                          size: 40,
                          color: DevilColor.lightgrey,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '스터디 목록을 불러오지 못했습니다',
                          style: DevilText.bodyM
                              .copyWith(color: DevilColor.lightgrey),
                        ),
                        const Spacer(flex: 2),
                      ],
                    );
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

  Widget _buildCategoryBtn(StudyCategory category) {
    final values = {
      true: {
        'btnColor': DevilColor.black,
        'onTapValue': null,
        'decoration': null,
        'textColor': DevilColor.point,
      },
      false: {
        'btnColor': DevilColor.white,
        'onTapValue': category,
        'decoration': BoxDecoration(
          border: Border.all(color: DevilColor.point),
          borderRadius: BorderRadius.circular(12),
        ),
        'textColor': DevilColor.black,
      },
    };
    final isSelected = selectedCategory == category;
    return InkWellBtn(
      btnColor: values[isSelected]!['btnColor'] as Color,
      radius: 12,
      onTap: () {
        setState(() {
          selectedCategory =
              values[isSelected]!['onTapValue'] as StudyCategory?;
        });
      },
      child: Container(
        decoration: values[isSelected]!['decoration'] as Decoration?,
        alignment: Alignment.center,
        child: Text(
          category.locale,
          style: DevilText.bodyM
              .copyWith(color: values[isSelected]!['textColor'] as Color),
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
