import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/news_article.dart';

class NewsArticleServices {
  final String baseUrl = "http://0.0.0.0:3000";

  Future<Map<String, dynamic>> createNewsArticle(NewsArticle article) async {
    final url = Uri.parse('$baseUrl/articles');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': article.userId,
          'title': article.title,
          'description': article.description,
          'coverImage': article.coverImage,
          'readablePublishDate': article.readablePublishDate,
          'socialImage': article.socialImage,
          'tagList': article.tagList,
          'tags': article.tags,
          'slug': article.slug,
          'path': article.path,
          'url': article.url,
          'canonicalUrl': article.canonicalUrl,
          'commentsCount': article.commentsCount,
          'positiveReactionsCount': article.positiveReactionsCount,
          'publicReactionsCount': article.publicReactionsCount,
          'collectionId': article.collectionId,
          'createdAt': article.createdAt?.toIso8601String(),
          'editedAt': article.editedAt?.toIso8601String(),
          'crosspostedAt': article.crosspostedAt?.toIso8601String(),
          'publishedAt': article.publishedAt?.toIso8601String(),
          'lastCommentAt': article.lastCommentAt?.toIso8601String(),
          'publishedTimestamp': article.publishedTimestamp?.toIso8601String(),
          'readingTimeMinutes': article.readingTimeMinutes,
          'bodyHtml': article.bodyHtml,
          'bodyMarkdown': article.bodyMarkdown,
        }),
      );

      if (response.statusCode == 201) {
        // Artículo creado exitosamente
        return json.decode(response.body);
      } else {
        // Error al crear el artículo
        return {
          'error': true,
          'message':
              json.decode(response.body)['message'] ?? 'Error desconocido',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Error al conectar con el servidor',
      };
    }
  }

  Future<Map<String, dynamic>> getNewsArticle(int id) async {
    final url = Uri.parse('$baseUrl/articles/$id');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Artículo obtenido exitosamente
        return json.decode(response.body);
      } else {
        // Error al obtener el artículo
        return {
          'error': true,
          'message': 'Error al obtener el artículo',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Error al conectar con el servidor',
      };
    }
  }

  Future<Map<String, dynamic>> updateNewsArticle(NewsArticle article) async {
    final url = Uri.parse('$baseUrl/articles/update/${article.id}');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': article.userId,
          'title': article.title,
          'description': article.description,
          'cover_image': article.coverImage,
          'readable_publish_date': article.readablePublishDate,
          'social_image': article.socialImage,
          'tag_list': article.tagList,
          'tags': article.tags,
          'slug': article.slug,
          'path': article.path,
          'url': article.url,
          'canonical_url': article.canonicalUrl,
          'comments_count': article.commentsCount,
          'positive_reactions_count': article.positiveReactionsCount,
          'public_reactions_count': article.publicReactionsCount,
          'collection_id': article.collectionId,
          'created_at': article.createdAt?.toIso8601String(),
          'edited_at': article.editedAt?.toIso8601String(),
          'crossposted_at': article.crosspostedAt?.toIso8601String(),
          'published_at': article.publishedAt?.toIso8601String(),
          'last_comment_at': article.lastCommentAt?.toIso8601String(),
          'published_timestamp': article.publishedTimestamp?.toIso8601String(),
          'reading_time_minutes': article.readingTimeMinutes,
          'body_html': article.bodyHtml,
          'body_markdown': article.bodyMarkdown,
          'hide': article.hide
        }),
      );

      if (response.statusCode == 200) {
        // Artículo actualizado exitosamente
        return json.decode(response.body);
      } else {
        // Error al actualizar el artículo
        return {
          'error': true,
          'message': 'Error al actualizar el artículo',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Error al conectar con el servidor',
      };
    }
  }

  Future<Map<String, dynamic>> desactiveNewsArticle(
      NewsArticle article, int id) async {
    final url = Uri.parse('$baseUrl/articles/${article.id}');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': id,
          'title': article.title,
          'description': article.description,
          'cover_image': article.coverImage,
          'readable_publish_date': article.readablePublishDate,
          'social_image': article.socialImage,
          'tag_list': article.tagList,
          'tags': article.tags,
          'slug': article.slug,
          'path': article.path,
          'url': article.url,
          'canonical_url': article.canonicalUrl,
          'comments_count': article.commentsCount,
          'positive_reactions_count': article.positiveReactionsCount,
          'public_reactions_count': article.publicReactionsCount,
          'collection_id': article.collectionId,
          'created_at': article.createdAt?.toIso8601String(),
          'edited_at': article.editedAt?.toIso8601String(),
          'crossposted_at': article.crosspostedAt?.toIso8601String(),
          'published_at': article.publishedAt?.toIso8601String(),
          'last_comment_at': article.lastCommentAt?.toIso8601String(),
          'published_timestamp': article.publishedTimestamp?.toIso8601String(),
          'reading_time_minutes': article.readingTimeMinutes,
          'body_html': article.bodyHtml,
          'body_markdown': article.bodyMarkdown,
          'hide': 1
        }),
      );

      if (response.statusCode == 200) {
        // Artículo actualizado exitosamente
        return json.decode(response.body);
      } else {
        // Error al actualizar el artículo
        return {
          'error': true,
          'message': 'Error al actualizar el artículo',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Error al conectar con el servidor',
      };
    }
  }

  Future<Map<String, dynamic>> activateNewsArticle(
      NewsArticle article, int id) async {
    final url = Uri.parse('$baseUrl/articles/${article.id}');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': id,
          'title': article.title,
          'description': article.description,
          'cover_image': article.coverImage,
          'readable_publish_date': article.readablePublishDate,
          'social_image': article.socialImage,
          'tag_list': article.tagList,
          'tags': article.tags,
          'slug': article.slug,
          'path': article.path,
          'url': article.url,
          'canonical_url': article.canonicalUrl,
          'comments_count': article.commentsCount,
          'positive_reactions_count': article.positiveReactionsCount,
          'public_reactions_count': article.publicReactionsCount,
          'collection_id': article.collectionId,
          'created_at': article.createdAt?.toIso8601String(),
          'edited_at': article.editedAt?.toIso8601String(),
          'crossposted_at': article.crosspostedAt?.toIso8601String(),
          'published_at': article.publishedAt?.toIso8601String(),
          'last_comment_at': article.lastCommentAt?.toIso8601String(),
          'published_timestamp': article.publishedTimestamp?.toIso8601String(),
          'reading_time_minutes': article.readingTimeMinutes,
          'body_html': article.bodyHtml,
          'body_markdown': article.bodyMarkdown,
          'hide': 0
        }),
      );

      if (response.statusCode == 200) {
        // Artículo actualizado exitosamente
        return json.decode(response.body);
      } else {
        // Error al actualizar el artículo
        return {
          'error': true,
          'message': 'Error al actualizar el artículo',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Error al conectar con el servidor',
      };
    }
  }

  Future<Map<String, dynamic>> deleteNewsArticle(int id) async {
    final url = Uri.parse('$baseUrl/articles/delete/$id');
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Artículo eliminado exitosamente
        return {
          'success': true,
          'message': 'Artículo eliminado correctamente',
        };
      } else {
        // Error al eliminar el artículo
        return {
          'error': true,
          'message': 'Error al eliminar el artículo',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Error al conectar con el servidor',
      };
    }
  }

  Future<List<NewsArticle>> getAllNewsArticles() async {
    final url = Uri.parse('$baseUrl/articles');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Lista de artículos obtenida exitosamente
        List<dynamic> data = json.decode(response.body);
        return data.map((article) => NewsArticle.fromJson(article)).toList();
      } else {
        // Error al obtener la lista de artículos
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<NewsArticle>> getArticlesByUser(int userId) async {
    final url = Uri.parse('$baseUrl/articles/user/$userId');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body)["articles"];
      return (jsonResponse as List)
          .map((article) => NewsArticle.fromJson(article))
          .toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
