class Podcast {
  final String title;
  final String slug;
  final String imageUrl;

  Podcast({
    required this.title,
    required this.slug,
    required this.imageUrl,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      title: json['title'],
      slug: json['slug'],
      imageUrl: json['image_url'],
    );
  }
}

class PodcastEpisode {
  final String typeOf;
  final int id;
  final String path;
  final String imageUrl;
  final String title;
  final Podcast podcast;

  PodcastEpisode({
    required this.typeOf,
    required this.id,
    required this.path,
    required this.imageUrl,
    required this.title,
    required this.podcast,
  });

  factory PodcastEpisode.fromJson(Map<String, dynamic> json) {
    return PodcastEpisode(
      typeOf: json['type_of'],
      id: json['id'],
      path: json['path'],
      imageUrl: json['image_url'],
      title: json['title'],
      podcast: Podcast.fromJson(json['podcast']),
    );
  }
}
