class Video {
  final String title;
  final String duration;
  bool isCompleted;

  Video({
    required this.title,
    required this.duration,
    this.isCompleted = false,
  });
}
