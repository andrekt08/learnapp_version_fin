import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app_ui/models/course_model.dart';
import 'package:education_app_ui/services/database_service.dart';
import 'package:education_app_ui/widgets/description_section.dart';
import 'package:education_app_ui/widgets/videos_section.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseScreen extends StatelessWidget {
  final Course course;
  const CourseScreen(this.course, {super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return StreamProvider<DocumentSnapshot?>.value(
      value: DatabaseService(uid: user?.uid).userProgress,
      initialData: null,
      child: _CourseScreenView(course: course),
    );
  }
}

class _CourseScreenView extends StatefulWidget {
  final Course course;
  const _CourseScreenView({required this.course});

  @override
  State<_CourseScreenView> createState() => _CourseScreenViewState();
}

class _CourseScreenViewState extends State<_CourseScreenView> {
  bool _isVideosSection = true;

  void _toggleVideoCompletion(String videoTitle, bool isCompleted) {
    final user = Provider.of<User?>(context, listen: false);
    DatabaseService(uid: user?.uid)
        .updateUserProgress(widget.course.name, videoTitle, !isCompleted);
  }

  @override
  Widget build(BuildContext context) {
    final userProgress = Provider.of<DocumentSnapshot?>(context);
    final progressData = userProgress?.data() as Map<String, dynamic>?;
    final completedVideos =
        progressData?['progress']?[widget.course.name] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Hero(
            tag: widget.course.name,
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(widget.course.image),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "${widget.course.name} Complete Course",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Created by Jules",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.videocam, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                "${widget.course.videoCount} Videos",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 5),
              Text(
                "${widget.course.rating} Rating",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ToggleButtons(
            isSelected: [_isVideosSection, !_isVideosSection],
            onPressed: (index) {
              setState(() {
                _isVideosSection = index == 0;
              });
            },
            borderRadius: BorderRadius.circular(10),
            selectedColor: Colors.white,
            fillColor: Theme.of(context).colorScheme.primary,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text("Videos", style: TextStyle(fontSize: 18)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text("Description", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _isVideosSection
              ? VideoSection(
                  videos: widget.course.videos,
                  completedVideos: completedVideos.cast<String>(),
                  onVideoTap: _toggleVideoCompletion,
                )
              : DescriptionSection(description: widget.course.description),
        ],
      ),
    );
  }
}
