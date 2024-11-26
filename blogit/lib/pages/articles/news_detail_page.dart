import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:provider/provider.dart'; // Importa Provider
import 'package:myapp2/services/devto_service.dart';
import 'package:myapp2/providers/theme_provider.dart';
import 'package:myapp2/models/news_article.dart';

class NewsDetailPage extends StatefulWidget {
  final int articleId;

  const NewsDetailPage({super.key, required this.articleId});

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  late Future<NewsArticle> futureArticle;
  final DevToService _service = DevToService();

  @override
  void initState() {
    super.initState();
    futureArticle = _service.fetchArticle(widget.articleId);
  }

  /// Función para convertir el contenido HTML en una lista de widgets Flutter
  List<Widget> _parseHtmlToWidgets(String htmlContent) {
    dom.Document document = html_parser.parse(htmlContent);
    List<Widget> widgets = [];
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final textColor =
        themeProvider.isDarkMode ? Colors.white70 : Colors.black87;

    document.body?.children.forEach((element) {
      if (element.localName == 'p') {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              element.text,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
        );
      } else if (element.localName == 'h1' || element.localName == 'h2') {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              element.text,
              style: TextStyle(
                fontSize: element.localName == 'h1' ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        );
      } else if (element.localName == 'img' &&
          element.attributes['src'] != null) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Image.network(
              element.attributes['src']!,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 220,
                  color: Colors.grey[300],
                  child: const Center(child: Text('Imagen no disponible')),
                );
              },
            ),
          ),
        );
      }
    });
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor =
        themeProvider.isDarkMode ? Colors.grey[950] : Colors.white;

    final appBarColor = themeProvider.isDarkMode ? Colors.green : Colors.black;
    final titleColor = themeProvider.isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BLOGIT',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25)),
        centerTitle: true,
        elevation: 5.0, // Sombra más pronunciada
        backgroundColor: backgroundColor, // Color de fondo
        titleTextStyle: TextStyle(
          color: titleColor, // Color del texto
          fontSize: 25, // Tamaño del texto
        ),
        iconTheme: IconThemeData(
          color: appBarColor, // Color de los íconos
        ),
      ),
      backgroundColor: backgroundColor,
      body: FutureBuilder<NewsArticle>(
        future: futureArticle,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final article = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: article.coverImage != null
                          ? Image.network(
                              article.coverImage!,
                              width: double.infinity,
                              height: 220,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 220,
                                  color: Colors.grey[300],
                                  child: const Center(
                                      child: Text('Imagen no disponible')),
                                );
                              },
                            )
                          : Image.network(
                              article.socialImage!,
                              width: double.infinity,
                              height: 220,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 220,
                                  color: Colors.grey[300],
                                  child: const Center(
                                      child: Text('Imagen no disponible')),
                                );
                              },
                            ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      article.title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      article.description ?? "",
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: themeProvider.isDarkMode
                            ? Colors.white60
                            : Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _parseHtmlToWidgets(article.bodyHtml ?? ""),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
