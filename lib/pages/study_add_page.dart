// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:devil/models/study.dart';
import 'package:devil/pages/main_page.dart';
import 'package:devil/viewmodels/info_model.dart';
import 'package:devil/viewmodels/study_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudyAddPage extends StatefulWidget {
  const StudyAddPage({Key? key}) : super(key: key);

  @override
  State<StudyAddPage> createState() => _StudyAddState();
}

class _StudyAddState extends State<StudyAddPage> {
  final TextEditingController _studyNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _participantsController = TextEditingController();
  bool isEmpty = false;
  StudyCategory? selectedCategory;

  @override
  Widget build(BuildContext context) {
    const categories = StudyCategory.values;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 투명 배경
        elevation: 0, // 그림자 효과 제거

        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.black), // 뒤로가기 버튼 색상을 검은색으로 설정
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'STUDY 등록하기',
          style: TextStyle(
            fontSize: 23,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '스터디 분야',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18.0),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 2.3,
                ),
                itemCount: categories.length,
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
                        print(selectedCategory);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.black : Colors.white,
                      minimumSize: const Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12.0), // 원하는 테두리의 반지름 값을 지정하세요.
                        side: const BorderSide(
                            color: Color(0xFF1E1C1D)), // 테두리의 색상을 지정하세요.
                      ),
                    ),
                    child: Text(
                      categories[index].locale,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            isSelected ? Colors.white : const Color(0xFF1E1C1D),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24.0),
              const Text(
                '스터디 이름',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18.0),
              TextField(
                controller: _studyNameController,
                onChanged: (value) {
                  setState(() {
                    isEmpty = _studyNameController.text.isNotEmpty &&
                        selectedCategory != null &&
                        _descriptionController.text.isNotEmpty &&
                        _participantsController.text.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Study Name', // Use hintText instead of labelText
                  filled: true,
                  fillColor: const Color(0xFFE8E8E8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              const Text(
                '스터디 설명',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18.0),
              TextField(
                controller: _descriptionController,
                onChanged: (value) {
                  setState(() {
                    isEmpty = _studyNameController.text.isNotEmpty &&
                        selectedCategory != null &&
                        _descriptionController.text.isNotEmpty &&
                        _participantsController.text.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Study Description',
                  filled: true,
                  fillColor: const Color(0xFFE8E8E8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 24.0),
              const Text(
                '스터디 인원',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18.0),
              TextField(
                controller: _participantsController,
                onChanged: (value) {
                  setState(() {
                    isEmpty = _studyNameController.text.isNotEmpty &&
                        selectedCategory != null &&
                        _descriptionController.text.isNotEmpty &&
                        _participantsController.text.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Participants',
                  filled: true,
                  fillColor: const Color(0xFFE8E8E8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (isEmpty)
                        ? () async {
                            final study = Study(
                              name: _studyNameController.text,
                              category: selectedCategory?.locale ?? "",
                              description: _descriptionController.text,
                              max: int.tryParse(_participantsController.text) ??
                                  0,
                            );

                            _studyNameController.clear();
                            _descriptionController.clear();
                            _participantsController.clear();

                            if (await context.read<StudyModel>().addStudy(
                                study, context.read<InfoModel>().user.id)) {
                              debugPrint('study added');
                              context.read<StudyModel>().getStudies();
                              context.read<InfoModel>().getMyStudies();
                            }

                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (_studyNameController.text.isNotEmpty &&
                              selectedCategory != null &&
                              _descriptionController.text.isNotEmpty &&
                              _participantsController.text.isNotEmpty)
                          ? Colors.black
                          : Colors.grey,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        '스터디 등록하기',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
