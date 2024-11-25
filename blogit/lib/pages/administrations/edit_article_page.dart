import 'package:flutter/material.dart';
import 'package:myapp2/models/news_article.dart';
import 'package:myapp2/services/news_article_services.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../providers/theme_provider.dart';

class EditArticlePage extends StatefulWidget {
  final NewsArticle article;

  const EditArticlePage({super.key, required this.article});

  @override
  _EditArticlePageState createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  final NewsArticleServices _newsArticleServices = NewsArticleServices();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _contentController;
  late TextEditingController _coverImageController;
  late TextEditingController _tagsController;
  late TextEditingController _slugController;
  late TextEditingController _urlController;

  final DateTime _selectedPublishDate = DateTime.now();
  File? _coverImage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article.title);
    _descriptionController = TextEditingController(text: widget.article.description);
    _contentController = TextEditingController(text: widget.article.bodyMarkdown);
    _coverImageController = TextEditingController(text: widget.article.coverImage);
    _tagsController = TextEditingController(text: widget.article.tags);
    _slugController = TextEditingController(text: widget.article.slug);
    _urlController = TextEditingController(text: widget.article.url);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _coverImageController.dispose();
    _tagsController.dispose();
    _slugController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _updateArticle() async {
    String title = _titleController.text;
    String description = _descriptionController.text;
    String content = _contentController.text;
    String tags = _tagsController.text;
    String slug = _slugController.text;
    String url = _urlController.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      NewsArticle updatedArticle = NewsArticle(
        id: widget.article.id,
        userId: widget.article.userId,
        title: title,
        description: description,
        coverImage: "",
        readablePublishDate: _selectedPublishDate.toIso8601String(),
        socialImage: '',
        tagList: tags.split(' '),
        tags: tags,
        slug: slug.isEmpty ? '' : slug,
        path: '',
        url: url.isEmpty ? '' : url,
        canonicalUrl: url.isEmpty ? '' : url,
        commentsCount: 0,
        positiveReactionsCount: 0,
        publicReactionsCount: 0,
        collectionId: 1,
        createdAt: DateTime.now(),
        editedAt: DateTime.now(),
        crosspostedAt: DateTime.now(),
        publishedAt: DateTime.now(),
        lastCommentAt: DateTime.now(),
        publishedTimestamp: DateTime.now(),
        readingTimeMinutes: 5,
        bodyHtml: content,
        bodyMarkdown: content,
      );

      final result = await _newsArticleServices.updateNewsArticle(updatedArticle);

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artículo actualizado correctamente')),
        );
        Navigator.pop(context); // Volver a la página anterior.
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el artículo: ${result['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkMode ? Colors.grey[950] : Colors.white;
    final appBarColor = themeProvider.isDarkMode ? Colors.green : Colors.black;
    final titleColor = themeProvider.isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BLOGIT', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25)),
        centerTitle: true,
        elevation: 5.0,
        backgroundColor: backgroundColor,
        titleTextStyle: TextStyle(color: titleColor, fontSize: 25),
        iconTheme: IconThemeData(color: appBarColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Título del artículo
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título del Artículo',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Descripción del artículo
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción del Artículo',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Contenido del artículo
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Contenido del Artículo',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:const  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: 10,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              // Botón para guardar o enviar el artículo
              Center(
                  child: ElevatedButton(
                    onPressed: _updateArticle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('Actualizar Artículo', style: TextStyle(fontSize: 18,color: Colors.white)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
