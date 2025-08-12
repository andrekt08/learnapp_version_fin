import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app_ui/data/mock_data.dart';
import 'package:education_app_ui/models/category_model.dart';
import 'package:education_app_ui/models/course_model.dart';
import 'package:education_app_ui/models/video_model.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection references
  final CollectionReference courseCollection =
      FirebaseFirestore.instance.collection('courses');
  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('categories');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // Get courses stream
  Stream<List<Course>> get courses {
    return courseCollection.snapshots().map(_courseListFromSnapshot);
  }

  // Get categories stream
  Stream<List<Category>> get categories {
    return categoryCollection.snapshots().map(_categoryListFromSnapshot);
  }

  // Get user progress stream
  Stream<DocumentSnapshot> get userProgress {
    return userCollection.doc(uid).snapshots();
  }

  // Update user data
  Future<void> updateUserData(String email) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'progress': {},
    });
  }

  // Update user progress
  Future<void> updateUserProgress(
      String courseName, String videoTitle, bool isCompleted) async {
    DocumentReference userDoc = userCollection.doc(uid);
    if (isCompleted) {
      return await userDoc.update({
        'progress.$courseName': FieldValue.arrayUnion([videoTitle])
      });
    } else {
      return await userDoc.update({
        'progress.$courseName': FieldValue.arrayRemove([videoTitle])
      });
    }
  }

  // course list from snapshot
  List<Course> _courseListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      var videosData = data['videos'] as List<dynamic>? ?? [];
      return Course(
        name: data['name'] ?? '',
        image: data['image'] ?? '',
        description: data['description'] ?? '',
        rating: (data['rating'] ?? 0.0).toDouble(),
        videoCount: data['videoCount'] ?? 0,
        videos: videosData.map((videoData) {
          return Video(
            title: videoData['title'] ?? '',
            duration: videoData['duration'] ?? '',
            isCompleted: videoData['isCompleted'] ?? false,
          );
        }).toList(),
      );
    }).toList();
  }

  // category list from snapshot
  List<Category> _categoryListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Category(
        name: data['name'] ?? '',
        iconCodepoint: data['iconCodepoint'] ?? 0,
        colorHex: data['colorHex'] ?? '0xFFFFFFFF',
      );
    }).toList();
  }

  // Function to upload the mock data
  Future<void> uploadMockData() async {
    WriteBatch batch = _db.batch();

    for (var category in mockCategories) {
      var docRef = categoryCollection.doc(category.name);
      batch.set(docRef, {
        'name': category.name,
        'iconCodepoint': category.iconCodepoint,
        'colorHex': category.colorHex,
      });
    }

    for (var course in mockCourses) {
      var docRef = courseCollection.doc(course.name);
      batch.set(docRef, {
        'name': course.name,
        'image': course.image,
        'description': course.description,
        'rating': course.rating,
        'videoCount': course.videoCount,
        'videos': course.videos
            .map((video) => {
                  'title': video.title,
                  'duration': video.duration,
                  'isCompleted': video.isCompleted,
                })
            .toList(),
      });
    }
    await batch.commit();
    print("Mock data uploaded successfully!");
  }
}
