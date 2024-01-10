import 'package:devil/models/study.dart';
import 'package:devil/pages/study_add_page.dart';
import 'package:devil/style/color.dart';
import 'package:devil/style/text.dart';
import 'package:devil/viewmodels/info_model.dart';
import 'package:devil/viewmodels/study_model.dart';
import 'package:devil/widgets/inkwell_btn.dart';
import 'package:devil/widgets/page_route_builder.dart';
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
  String searchText = "";
  String submitedText = "";
  FocusNode searchFocus = FocusNode();
  bool btnVisible = true;
  bool issumbit = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    searchFocus.addListener(() {
      setState(() {
        btnVisible = !searchFocus.hasFocus;
      });
    });
  }

  void resetSearch() {
    setState(() {
      searchText = "";
      submitedText = "";
      issumbit = false;
      searchController.clear();
      FocusScope.of(context).unfocus();
    });
  }

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
            issumbit
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            resetSearch();
                          },
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "전체 보기",
                        style: TextStyle(
                          color: DevilColor.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                : Container(),
            issumbit
                ? Container()
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextField(
                      focusNode: searchFocus,
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: '검색어를 입력해주세요.',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red), // Change the border color
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16), // Adjust content padding
                        // Add margin around the TextField
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  DevilColor.point), // Change the border color
                          borderRadius: BorderRadius.all(
                              Radius.circular(12)), // Adjust border radius
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  DevilColor.point), // Change the border color
                          borderRadius: BorderRadius.all(
                              Radius.circular(12)), // Adjust border radius
                        ),
                        prefixIcon: Icon(Icons.search, color: DevilColor.point),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      onSubmitted: (value) {
                        setState(() {
                          submitedText = searchText;
                          searchText = "";
                          searchController.clear();
                          issumbit = true;
                        });
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
            btnVisible && !issumbit
                ? Padding(
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
                      itemBuilder: (context, index) =>
                          _buildCategoryBtn(categories[index]),
                    ),
                  )
                : Container(),
            Expanded(
              child: FutureBuilder(
                future: context.watch<StudyModel>().studies,
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
        floatingActionButton: btnVisible
            ? FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: islogined
                    ? () {
                        Navigator.push(
                          context,
                          pageRouteBuilder(page: const StudyAddPage()),
                        );
                      }
                    : widget.navigateToLogin,
                backgroundColor: const Color(0xFFFFA8B1),
                child: const Icon(Icons.add),
              )
            : null,
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

    if (searchText.isNotEmpty) {
      filteredStudies = filteredStudies
          .where((study) =>
              study.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }

    if (issumbit) {
      filteredStudies = filteredStudies
          .where((study) =>
              study.name.toLowerCase().contains(submitedText.toLowerCase()))
          .toList();
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
