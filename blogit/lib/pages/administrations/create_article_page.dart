import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp2/providers/auth_provider.dart';
import 'package:myapp2/services/news_article_services.dart';
import 'package:myapp2/models/news_article.dart';
import 'package:myapp2/providers/theme_provider.dart';
import 'dart:io';

class CreateArticlePage extends StatefulWidget {
  const CreateArticlePage({super.key});

  @override
  _CreateArticlePageState createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends State<CreateArticlePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _slugController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  final NewsArticleServices _newsArticleServices = NewsArticleServices();

  final DateTime _selectedPublishDate = DateTime.now();
  File? _coverImage; // Variable para la imagen seleccionada

  final List<String> _tags = []; // Lista para almacenar las etiquetas

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor =
        themeProvider.isDarkMode ? Colors.grey[950] : Colors.white;
    final appBarColor = themeProvider.isDarkMode ? Colors.green : Colors.black;
    final titleColor = themeProvider.isDarkMode ? Colors.white : Colors.black;
    final authProvider =
        Provider.of<AuthProvider>(context); // Accede al AuthProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text('BLOGIT',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25)),
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // Descripcion del articulo
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripcion del articulo',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: 10,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Botón para guardar o enviar el artículo
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String title = _titleController.text;
                    String description = _descriptionController.text;
                    String content = _contentController.text;
                    String coverImage =
                        _coverImage != null ? _coverImage!.path : '';
                    String tags = _tags.join(', ');
                    String slug = _slugController.text;
                    String url = _urlController.text;

                    if (title.isNotEmpty && content.isNotEmpty) {
                      // Crear un objeto NewsArticle
                      NewsArticle article = NewsArticle(
                        id: 0,
                        userId: authProvider.currentUser!.id,
                        title: title,
                        description: description,
                        coverImage: coverImage.isEmpty ? '' : coverImage,
                        readablePublishDate:
                            _selectedPublishDate.toIso8601String(),
                        socialImage: '',
                        tagList: _tags,
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
                        bodyHtml:
                            content, // Puedes almacenar el contenido en HTML si es necesario
                        bodyMarkdown: content, // O en Markdown
                      );

                      // Llamar al servicio para crear el artículo
                      Map<String, dynamic> result =
                          await _newsArticleServices.createNewsArticle(article);

                      if (result.containsKey('error') && result['error']) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Error: ${result['message']}')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Artículo creado exitosamente!')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Por favor, complete todos los campos')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  child: const Text(
                    'Guardar Artículo',
                    style: TextStyle(color: Colors.white),
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
