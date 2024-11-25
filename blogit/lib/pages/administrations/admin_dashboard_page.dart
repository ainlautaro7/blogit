import 'package:flutter/material.dart';
import 'package:myapp2/pages/administrations/create_article_page.dart';
import 'package:myapp2/pages/administrations/edit_article_page.dart'; // Nueva página de edición
import 'package:myapp2/providers/auth_provider.dart';
import 'package:myapp2/services/news_article_services.dart';
import 'package:myapp2/models/news_article.dart';
import 'package:provider/provider.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final NewsArticleServices _articleService = NewsArticleServices();
  late Future<List<NewsArticle>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserArticles();
  }

  void _fetchUserArticles() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user != null) {
      _articlesFuture = _articleService.getArticlesByUser(user.id).then((response) {
        // Extrae la lista de artículos de la respuesta
        final articlesList = response;
        if (articlesList.isNotEmpty) {
          return articlesList;
        } else {
          throw Exception('No se encontraron artículos en la respuesta.');
        }
      });
    } else {
      _articlesFuture = Future.error('Usuario no autenticado');
    }
  }

  void _activateArticle(NewsArticle article) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      // Llamar al servicio para activar el artículo
      final result = await _articleService.activateNewsArticle(article, authProvider.currentUser!.id);

      if (result['error'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al activar el artículo: ${result['message']}')),
        );
      } else {
        setState(() {
          _fetchUserArticles();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artículo activado correctamente')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.green : Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _navigateToCreateArticlePage,
              child: const Text('Crear Nuevo', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<NewsArticle>>(
                future: _articlesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error al cargar los artículos: ${snapshot.error}'),
                    );
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No tienes artículos disponibles.'));
                  }

                  var articles = snapshot.data!;
                  // Filtrar artículos publicados
                  var publishedArticles = articles.where((article) => article.hide == 0).toList();
                  var draftArticles = articles.where((article) => article.hide == 1).toList();

                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,  // Alinea a la izquierda
                        child: const Text(
                          'Artículos publicados',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: publishedArticles.length,
                          itemBuilder: (context, index) {
                            final article = publishedArticles[index];
                            return _buildArticleCard(article);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,  // Alinea a la izquierda
                        child: const Text(
                          'Artículos en borrador',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: draftArticles.length,
                          itemBuilder: (context, index) {
                            final article = draftArticles[index];
                            return _buildArticleCard(article);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(NewsArticle article) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: ListTile(
        leading: article.coverImage != null
            ? Image.network(
          article.coverImage!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        )
            : const Icon(Icons.article, size: 50),
        title: Text(article.title),
        subtitle: Text(article.description ?? 'Sin descripción'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _editArticle(article);
            } else if (value == 'activate') {
              _activateArticle(article);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Editar')),
            const PopupMenuItem(value: 'activate', child: Text('Activar')),
          ],
        ),
      ),
    );
  }

  void _navigateToCreateArticlePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateArticlePage()),
    ).then((_) {
      setState(() {
        _fetchUserArticles();
      });
    });
  }

  void _editArticle(NewsArticle article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditArticlePage(article: article),
      ),
    ).then((_) {
      setState(() {
        _fetchUserArticles();
      });
    });
  }
}