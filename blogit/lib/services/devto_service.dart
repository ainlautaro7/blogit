import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp2/models/news_article.dart';
import 'package:myapp2/models/podcast_episode.dart';

class DevToService {
  static const _baseUrl = 'https://dev.to/api';

  Future<List<NewsArticle>> fetchArticles(
      {String? tag, int? page, int? perPage}) async {
    String url = '$_baseUrl/articles?tag=$tag&page=$page&per_page=$perPage';
    if (tag != null && tag.isNotEmpty) {
      url += '?tag=$tag';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return (jsonResponse as List)
          .map((article) => NewsArticle.fromJson(article))
          .toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<List<String>> fetchTags() async {
    final response = await http.get(Uri.parse('$_baseUrl/tags'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return (jsonResponse as List)
          .map((tag) => tag['name'] as String)
          .toList();
    } else {
      throw Exception('Failed to load tags');
    }
  }

  Future<NewsArticle> fetchArticle(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/articles/$id'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return NewsArticle(
        id: jsonResponse["id"],
        userId: jsonResponse["userId"],
        title: jsonResponse["title"],
        coverImage: jsonResponse["cover_image"],
        socialImage: jsonResponse["social_image"],
        bodyHtml: jsonResponse["body_html"],
      );
    } else {
      throw Exception('Failed to load article');
    }
  }

  Future<List<PodcastEpisode>> fetchPodcasts() async {
    final response = await http.get(Uri.parse('$_baseUrl/podcast_episodes'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return (jsonResponse as List)
          .map((episode) => PodcastEpisode.fromJson(episode))
          .toList();
    } else {
      throw Exception('Failed to load podcasts');
    }
  }
}
