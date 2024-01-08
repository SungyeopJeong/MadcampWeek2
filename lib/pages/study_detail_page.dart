import 'package:devil/models/study.dart';
import 'package:flutter/material.dart';

class StudyDetailPage extends StatelessWidget {
  final Study study;
  const StudyDetailPage({super.key, required this.study});

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.all(16.0),
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
                        study.name,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        study.description,
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
                        study.category,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        '스터디 인원',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${study.max}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          //스터디 참여 버튼
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          minimumSize: const Size(double.infinity, 0),
                        ),
                        child: const Text(
                          '참여하기',
                          style: TextStyle(
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
