class NewsArticle {
  final String? typeOf; // Cambiado a nullable
  final int id; // Cambiado a nullable
  final int? userId; // Cambiado a nullable
  final String title; // Cambiado a nullable
  final String? description; // Ya era nullable
  final String? coverImage; // Cambiado a nullable
  final String? readablePublishDate; // Cambiado a nullable
  final String? socialImage; // Cambiado a nullable
  final List<String>? tagList; // Cambiado a nullable
  final String? tags; // Cambiado a nullable
  final String? slug; // Cambiado a nullable
  final String? path; // Cambiado a nullable
  final String? url; // Cambiado a nullable
  final String? canonicalUrl; // Cambiado a nullable
  final int? commentsCount; // Cambiado a nullable
  final int? positiveReactionsCount; // Cambiado a nullable
  final int? publicReactionsCount; // Cambiado a nullable
  final int? collectionId; // Ya era nullable
  final DateTime? createdAt; // Cambiado a nullable
  final DateTime? editedAt; // Cambiado a nullable
  final DateTime? crosspostedAt; // Ya era nullable
  final DateTime? publishedAt; // Cambiado a nullable
  final DateTime? lastCommentAt; // Cambiado a nullable
  final DateTime? publishedTimestamp; // Cambiado a nullable
  final int? readingTimeMinutes; // Cambiado a nullable
  final String? bodyHtml; // Cambiado a nullable
  final String? bodyMarkdown; // Cambiado a nullable
  final User? user; // Cambiado a nullable
  final Organization? organization; // Cambiado a nullable
  late final int? hide; // Cambiado a nullable

  NewsArticle({
    this.typeOf,
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.coverImage,
    this.readablePublishDate,
    this.socialImage,
    this.tagList,
    this.tags,
    this.slug,
    this.path,
    this.url,
    this.canonicalUrl,
    this.commentsCount,
    this.positiveReactionsCount,
    this.publicReactionsCount,
    this.collectionId,
    this.createdAt,
    this.editedAt,
    this.crosspostedAt,
    this.publishedAt,
    this.lastCommentAt,
    this.publishedTimestamp,
    this.readingTimeMinutes,
    this.bodyHtml,
    this.bodyMarkdown,
    this.user,
    this.organization,
    this.hide
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      typeOf: json['type_of'],
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      coverImage: json['cover_image'],
      readablePublishDate: json['readable_publish_date'],
      socialImage: json['social_image'],
      tagList: List<String>.from(json['tag_list'] ?? []),
      tags: json['tags'],
      slug: json['slug'],
      path: json['path'],
      url: json['url'],
      canonicalUrl: json['canonical_url'],
      commentsCount: json['comments_count'],
      positiveReactionsCount: json['positive_reactions_count'],
      publicReactionsCount: json['public_reactions_count'],
      collectionId: json['collection_id'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      editedAt: json['edited_at'] != null ? DateTime.parse(json['edited_at']) : null,
      crosspostedAt: json['crossposted_at'] != null ? DateTime.parse(json['crossposted_at']) : null,
      publishedAt: json['published_at'] != null ? DateTime.parse(json['published_at']) : null,
      lastCommentAt: json['last_comment_at'] != null ? DateTime.parse(json['last_comment_at']) : null,
      publishedTimestamp: json['published_timestamp'] != null ? DateTime.parse(json['published_timestamp']) : null,
      readingTimeMinutes: json['reading_time_minutes'],
      bodyHtml: json['body_html'],
      bodyMarkdown: json['body_markdown'],
      hide: json['hide'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      organization: json['organization'] != null ? Organization.fromJson(json['organization']) : null,
    );
  }
}

class User {
  final int? id;
  final String? name; // Cambiado a nullable
  final String? username; // Cambiado a nullable
  final String? twitterUsername; // Ya era nullable
  final String? githubUsername; // Ya era nullable
  final String? websiteUrl; // Ya era nullable
  final String? profileImage; // Cambiado a nullable
  final String? profileImage90; // Cambiado a nullable

  User({
    this.id,
    this.name,
    this.username,
    this.twitterUsername,
    this.githubUsername,
    this.websiteUrl,
    this.profileImage,
    this.profileImage90,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      twitterUsername: json['twitter_username'],
      githubUsername: json['github_username'],
      websiteUrl: json['website_url'],
      profileImage: json['profile_image'],
      profileImage90: json['profile_image_90'],
    );
  }
}

class Organization {
  final String? name; // Cambiado a nullable
  final String? username; // Cambiado a nullable
  final String? slug; // Cambiado a nullable
  final String? profileImage; // Cambiado a nullable
  final String? profileImage90; // Cambiado a nullable

  Organization({
    this.name,
    this.username,
    this.slug,
    this.profileImage,
    this.profileImage90,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      name: json['name'],
      username: json['username'],
      slug: json['slug'],
      profileImage: json['profile_image'],
      profileImage90: json['profile_image_90'],
    );
  }
}
