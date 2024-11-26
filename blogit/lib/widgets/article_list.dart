// blogit/lib/widgets/article_list.dart
import 'package:flutter/material.dart';
import 'package:myapp2/models/news_article.dart';
import 'package:myapp2/pages/articles/news_detail_page.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:myapp2/widgets/generic_card.dart';

class ArticleList extends StatelessWidget {
  final Future<List<NewsArticle>> listArticles;

  const ArticleList({Key? key, required this.listArticles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsArticle>>(
      future: listArticles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildSkeletonLoader();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No articles found.'));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final article = snapshot.data![index];
              return GenericCard(
                title: article.title,
                imageUrl: article.coverImage ?? article.socialImage ?? '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NewsDetailPage(articleId: article.id),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 0,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Skeletonizer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
              margin: const EdgeInsets.symmetric(vertical: 5.0),
            ),
          );
        },
      ),
    );
  }
}
