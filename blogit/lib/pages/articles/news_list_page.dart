import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../services/devto_service.dart';
import '../../../models/news_article.dart';
import '../../providers/theme_provider.dart'; // Asegúrate de que la ruta sea correcta
import 'news_detail_page.dart';

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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sliderArticles = DevToService().fetchArticles(page: 1, perPage: 5);
    _listArticles = DevToService().fetchArticles(page: 2, perPage: 4);
    _tags = DevToService().fetchTags().then((tags) {
      if (tags.isNotEmpty) {
        setState(() {
          _selectedTag = tags.first;
          _listArticles = DevToService().fetchArticles(tag: _selectedTag, page: 1, perPage: 4);
        });
      }
      return tags;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildArticleSlider(),
          Expanded(child: Column(
            children: [
              const SizedBox(height: 20),
              _buildTagFilter(),
              const SizedBox(height: 20),
              Expanded(child: _buildArticleList()),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildArticleSlider() {
    return FutureBuilder<List<NewsArticle>>(
      future: _sliderArticles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No articles found.'));
        }

        return SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final article = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailPage(articleId: article.id),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0), // Aumenta el margen para mostrar más
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(article.socialImage ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.black54, Colors.black38],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            // Establece la configuración de PageView para permitir que el siguiente artículo sea visible
            controller: PageController(viewportFraction: 0.85), // Ajusta el tamaño de la vista
          ),
        );
      },
    );
  }

  Widget _buildArticleList() {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return FutureBuilder<List<NewsArticle>>(
      future: _listArticles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //return const Center(child: CircularProgressIndicator());
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
                crossAxisCount: 2, // Dos columnas
                childAspectRatio: 1, // Relación de aspecto de los artículos
                crossAxisSpacing: 10.0, // Espacio horizontal entre artículos
                mainAxisSpacing: 10.0, // Espacio vertical entre artículos
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final article = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailPage(articleId: article.id),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white, // Color de fondo de la tarjeta
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode?Colors.transparent:Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 0), // Cambiar la posición de la sombra
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                          child: article.coverImage != null
                              ? Image.network(article.coverImage!, height: 120, width: double.infinity, fit: BoxFit.cover)
                              : Image.network(article.socialImage!, height: 120, width: double.infinity, fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            article.title.length > 50?'${article.title.substring(0, 40)}...':article.title,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        );
      },
    );
  }

  Widget _buildTagFilter() {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return FutureBuilder<List<String>>(
      future: _tags,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No tags found.'));
        }

        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final tag = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  _filterArticles(tag);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: _selectedTag == tag ? Colors.green : isDarkMode ? Colors.white : Colors.black87,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _selectedTag == tag ? Colors.green : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      tag,
                      style: TextStyle(color: isDarkMode? Colors.black87 : Colors.white),
                    ),
                  ),
                ),
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
          crossAxisCount: 2, // Dos columnas
          childAspectRatio: 1, // Relación de aspecto de los elementos
          crossAxisSpacing: 10.0, // Espacio horizontal entre elementos
          mainAxisSpacing: 0, // Espacio vertical entre elementos
        ),
        itemCount: 4, // Número de elementos de esqueleto a mostrar
        itemBuilder: (context, index) {
          return Skeletonizer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300], // Color de fondo del esqueleto
              ),
              margin: const EdgeInsets.symmetric(vertical: 5.0),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonSliderLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Dos columnas
          childAspectRatio: 1, // Relación de aspecto de los elementos
          crossAxisSpacing: 10.0, // Espacio horizontal entre elementos
          mainAxisSpacing: 0, // Espacio vertical entre elementos
        ),
        itemCount: 4, // Número de elementos de esqueleto a mostrar
        itemBuilder: (context, index) {
          return Skeletonizer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300], // Color de fondo del esqueleto
              ),
              margin: const EdgeInsets.symmetric(vertical: 5.0),
            ),
          );
        },
      ),
    );
  }

  void _filterArticles(String? tag) {
    setState(() {
      _selectedTag = tag;
      _listArticles = DevToService().fetchArticles(tag: tag, page: 1, perPage: 4);
    });
  }
}
