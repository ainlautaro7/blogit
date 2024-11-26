import 'package:flutter/material.dart';
import '../../services/devto_service.dart';
import '../../widgets/article_slider.dart';
import '../../widgets/article_list.dart';
import '../../widgets/tag_filter.dart';
import '../../models/news_article.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  late Future<List<NewsArticle>> _sliderArticles;
  late Future<List<NewsArticle>> _listArticles;
  late Future<List<String>> _tags;
  String? _selectedTag;

  @override
  void initState() {
    super.initState();
    _sliderArticles = DevToService().fetchArticles(page: 1, perPage: 5);
    _listArticles = DevToService().fetchArticles(page: 2, perPage: 4);
    _tags = DevToService().fetchTags().then((tags) {
      if (tags.isNotEmpty) {
        setState(() {
          _selectedTag = tags.first;
          _listArticles = DevToService()
              .fetchArticles(tag: _selectedTag, page: 1, perPage: 4);
        });
      }
      return tags;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          ArticleSlider(sliderArticles: _sliderArticles),
          Expanded(
              child: Column(
            children: [
              const SizedBox(height: 20),
              TagFilter(
                tags: _tags,
                selectedTag: _selectedTag,
                onTagSelected: _filterArticles,
              ),
              const SizedBox(height: 20),
              Expanded(child: ArticleList(listArticles: _listArticles)),
            ],
          )),
        ],
      ),
    );
  }

  void _filterArticles(String? tag) {
    setState(() {
      _selectedTag = tag;
      _listArticles =
          DevToService().fetchArticles(tag: tag, page: 1, perPage: 4);
    });
  }
}
