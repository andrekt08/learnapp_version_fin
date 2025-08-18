import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app_ui/models/category_model.dart';
import 'package:education_app_ui/models/course_model.dart';
import 'package:education_app_ui/models/video_model.dart';
import 'package:education_app_ui/screens/course_screen.dart';
import 'package:education_app_ui/services/database_service.dart';
import 'package:education_app_ui/widgets/recommendation_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return MultiProvider(
      providers: [
        StreamProvider<List<Category>>.value(
          value: DatabaseService().categories,
          initialData: const [],
        ),
        StreamProvider<List<Course>>.value(
          value: DatabaseService().courses,
          initialData: const [],
        ),
        StreamProvider<DocumentSnapshot?>.value(
          value: DatabaseService(uid: user?.uid).userProgress,
          initialData: null,
        ),
      ],
      child: const _HomePageView(),
    );
  }
}

class _HomePageView extends StatelessWidget {
  const _HomePageView();

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<List<Category>>(context);
    final courses = Provider.of<List<Course>>(context);
    final userProgress = Provider.of<DocumentSnapshot?>(context);

    Video? recommendedVideo;
    Course? recommendedCourse;

    if (userProgress != null && userProgress.exists && courses.isNotEmpty) {
      final progressData = userProgress.data() as Map<String, dynamic>;
      final progressMap =
          progressData['progress'] as Map<String, dynamic>? ?? {};

      for (var course in courses) {
        if (progressMap.containsKey(course.name)) {
          final completedVideos = progressMap[course.name] as List<dynamic>;
          final nextVideo = course.videos.firstWhere(
            (video) => !completedVideos.contains(video.title),
            orElse: () =>
                Video(title: 'null', duration: 'null'), // Workaround for orElse
          );

          if (nextVideo.title != 'null') {
            recommendedVideo = nextVideo;
            recommendedCourse = course;
            break;
          }
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Hi, Programmer",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.upload, size: 30),
                      tooltip: 'Upload Mock Data',
                      onPressed: () async {
                        await DatabaseService().uploadMockData();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Mock data uploaded to Firestore!'),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_outlined,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            if (recommendedVideo != null && recommendedCourse != null)
              RecommendationWidget(
                nextVideo: recommendedVideo,
                courseName: recommendedCourse.name,
                onWatchNow: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseScreen(recommendedCourse!),
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search for courses...",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Categories",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Color(int.parse(category.colorHex)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            IconData(
                              category.iconCodepoint,
                              fontFamily: 'MaterialIcons',
                            ),
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Courses",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseScreen(course),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Center(
                              child: Hero(
                                tag: course.name,
                                child: Image.asset(
                                  course.image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            course.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${course.videoCount} Videos",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        showUnselectedLabels: true,
        iconSize: 32,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        selectedFontSize: 16,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
