import 'package:flutter/material.dart';
import 'package:myapp2/models/podcast_episode.dart';

class PodcastDetailPage extends StatelessWidget {
  final PodcastEpisode episode;

  const PodcastDetailPage({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(episode.podcast.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            child: Image.network(
              episode.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'by ${episode.title}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
