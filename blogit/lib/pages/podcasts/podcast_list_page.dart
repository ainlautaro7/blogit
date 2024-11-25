import 'package:flutter/material.dart';
import 'package:myapp2/models/podcast_episode.dart';
import 'package:myapp2/pages/podcasts/podcast_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../services/devto_service.dart'; // Asegúrate de que la ruta sea correcta
import '../articles/news_detail_page.dart'; // Cambia esto si el detalle del podcast es diferente
import '../../providers/theme_provider.dart';

class PodcastPage extends StatefulWidget {
  const PodcastPage({super.key});

  @override
  _PodcastPageState createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  late Future<List<PodcastEpisode>> _podcastEpisodes;
  late Future<List<String>> _tags;
  String? _selectedTag;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  void _fetchInitialData() async {
    _tags = DevToService().fetchTags();
    _podcastEpisodes = _tags.then((tags) {
      if (tags.isNotEmpty) {
        setState(() {
          _selectedTag = tags.first; // Seleccionar el primer tag por defecto
        });
      }
      return _fetchPodcasts(_selectedTag);
    });
  }

  Future<List<PodcastEpisode>> _fetchPodcasts(String? tag) {
    return DevToService().fetchPodcasts(); // Suponiendo que fetchPodcasts acepta un parámetro para filtrar
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _buildPodcastList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodcastList() {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return FutureBuilder<List<PodcastEpisode>>(
      future: _podcastEpisodes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildSkeletonLoader();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No podcast episodes found.'));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Dos columnas
              childAspectRatio: 1, // Relación de aspecto de los episodios
              crossAxisSpacing: 10.0, // Espacio horizontal entre episodios
              mainAxisSpacing: 10.0, // Espacio vertical entre episodios
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final episode = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PodcastDetailPage(episode: episode), // Pasando el episodio seleccionado
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white, // Color de fondo de la tarjeta
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode ? Colors.transparent : Colors.grey.withOpacity(0.3),
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
                        child: episode.imageUrl != null
                            ? Image.network(episode.imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover)
                            : Image.network(episode.imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          episode.title.length > 50 ? '${episode.title.substring(0, 50)}...' : episode.title,
                          style: const TextStyle(
                            color: Colors.black,
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
        itemCount: 12, // Número de elementos de esqueleto a mostrar
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

  void _filterEpisodes(String? tag) {
    setState(() {
      _selectedTag = tag;
      _podcastEpisodes = _fetchPodcasts(tag); // Actualiza los episodios con el tag seleccionado
    });
  }
}