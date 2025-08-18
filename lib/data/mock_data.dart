import 'package:education_app_ui/models/category_model.dart';
import 'package:education_app_ui/models/course_model.dart';
import 'package:education_app_ui/models/video_model.dart';
import 'package:flutter/material.dart';

final List<Category> mockCategories = [
  Category(
    name: "Classes",
    iconCodepoint: Icons.video_library.codePoint,
    colorHex: "0xFF6FE08D",
  ),
  Category(
    name: "Free Course",
    iconCodepoint: Icons.assignment.codePoint,
    colorHex: "0xFF61BDFD",
  ),
  Category(
    name: "BookStore",
    iconCodepoint: Icons.store.codePoint,
    colorHex: "0xFFFC7F7F",
  ),
  Category(
    name: "Live Course",
    iconCodepoint: Icons.play_circle_fill.codePoint,
    colorHex: "0xFFCB84FB",
  ),
  Category(
    name: "LeaderBoard",
    iconCodepoint: Icons.emoji_events.codePoint,
    colorHex: "0xFF78E667",
  ),
];

final List<Course> mockCourses = [
  Course(
    name: "Flutter",
    image: "images/Flutter.png",
    description:
        "Learn to build beautiful, fast, and native-quality apps with Flutter. This course covers everything from the basics of Dart to advanced Flutter concepts.",
    rating: 4.8,
    videoCount: 55,
    videos: [
      Video(title: 'Introduction to Flutter', duration: '10:30'),
      Video(title: 'Installing Flutter on Windows', duration: '15:45'),
      Video(title: 'Setup Emulator on Windows', duration: '12:20'),
      Video(title: 'Creating our First App', duration: '20:00'),
    ],
  ),
  Course(
    name: "React Native",
    image: "images/React Native.png",
    description:
        "Build native mobile apps for iOS and Android using React Native. This course will take you from a beginner to an advanced React Native developer.",
    rating: 4.7,
    videoCount: 55,
    videos: [
      Video(title: 'Introduction to React Native', duration: '11:00'),
      Video(title: 'Setting up your environment', duration: '18:30'),
      Video(title: 'Creating your first component', duration: '22:10'),
    ],
  ),
  Course(
    name: "Python",
    image: "images/Python.png",
    description:
        "A comprehensive course on Python programming. Learn about variables, data types, loops, functions, and object-oriented programming.",
    rating: 4.9,
    videoCount: 55,
    videos: [
      Video(title: 'Introduction to Python', duration: '8:00'),
      Video(title: 'Variables and Data Types', duration: '14:25'),
      Video(title: 'Your first Python program', duration: '19:50'),
    ],
  ),
  Course(
    name: "C#",
    image: "images/C#.png",
    description:
        "Master the C# language and the .NET framework with this course. You'll learn how to build powerful applications for Windows, web, and mobile.",
    rating: 4.6,
    videoCount: 55,
    videos: [
      Video(title: 'Introduction to C# and .NET', duration: '12:15'),
      Video(title: 'Understanding the .NET Ecosystem', duration: '16:00'),
      Video(title: 'Building a Console Application', duration: '21:40'),
    ],
  ),
];
