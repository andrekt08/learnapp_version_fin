import 'package:education_app_ui/models/video_model.dart';
import 'package:flutter/material.dart';

class VideoSection extends StatelessWidget {
  final List<Video> videos;
  final List<String> completedVideos;
  final Function(String, bool) onVideoTap;

  const VideoSection({
    super.key,
    required this.videos,
    required this.completedVideos,
    required this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        final bool isCompleted = completedVideos.contains(video.title);

        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            onTap: () => onVideoTap(video.title, isCompleted),
            leading: Icon(
              Icons.play_circle_fill,
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            ),
            title: Text(video.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(video.duration),
            trailing: Icon(
              isCompleted ? Icons.check_circle : Icons.check_circle_outline,
              color: isCompleted ? Colors.green : Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
