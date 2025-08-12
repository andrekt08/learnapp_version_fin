import 'package:education_app_ui/models/video_model.dart';

class Course {
  final String name;
  final String image;
  final String description;
  final double rating;
  final int videoCount;
  final List<Video> videos;

  Course({
    required this.name,
    required this.image,
    required this.description,
    required this.rating,
    required this.videoCount,
    required this.videos,
  });
}
