import 'package:education_app_ui/models/video_model.dart';
import 'package:flutter/material.dart';

class RecommendationWidget extends StatelessWidget {
  final Video nextVideo;
  final String courseName;
  final VoidCallback onWatchNow;

  const RecommendationWidget({
    super.key,
    required this.nextVideo,
    required this.courseName,
    required this.onWatchNow,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recommended for you",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Continue your journey in $courseName"),
            const SizedBox(height: 15),
            ListTile(
              leading: Icon(Icons.play_circle_outline, size: 40, color: Theme.of(context).colorScheme.primary),
              title: Text(nextVideo.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Next up: ${nextVideo.duration}"),
              trailing: ElevatedButton(
                onPressed: onWatchNow,
                child: const Text("Watch Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
