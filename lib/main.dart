import 'package:flutter/material.dart';
import 'package:my_diary/screens/dairy_home_page.dart';
import 'package:my_diary/utils/colors.dart';

void main() {
  runApp(MyDiaryApp());
}

class MyDiaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: DiaryHomePage(),
    );
  }
}
