import 'package:flutter/material.dart';
import 'package:myapp2/pages/administrations/admin_dashboard_page.dart';
import 'package:myapp2/pages/administrations/create_article_page.dart';
import 'package:myapp2/pages/user/login_page.dart';
import 'package:myapp2/pages/user/profile_page.dart';
import 'providers/auth_provider.dart';
import 'pages/articles/news_list_page.dart';
import 'pages/podcasts/podcast_list_page.dart';
import 'providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech News Blog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Provider.of<ThemeProvider>(context).isDarkMode ? Brightness.dark : Brightness.light,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Estado del índice seleccionado
  final PageController _pageController = PageController(); // Controlador de la página
  final NotchBottomBarController _controller = NotchBottomBarController(index: 0);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final authProvider = Provider.of<AuthProvider>(context);

    // Construir la lista de páginas según el estado de autenticación
    final List<Widget> pages = [
      const NewsListPage(), // Página de noticias
      const PodcastPage(), // Página de podcasts
      if (authProvider.isAuthenticated) const AdminDashboardPage(),
      authProvider.isAuthenticated ? ProfilePage() : const LoginPage(),
    ];

    // Si el índice seleccionado es mayor que el número de páginas, lo corregimos
    if (_selectedIndex >= pages.length) {
      _selectedIndex = 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('BLOGIT', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25)),
        centerTitle: true,
        elevation: 5.0,
        backgroundColor: isDarkMode ? Colors.grey[950] : Colors.white,
        titleTextStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
          fontSize: 20,
        ),
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController, // Vincula el PageController aquí
        children: pages, // Muestra la lista de páginas
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index; // Actualiza el índice seleccionado al cambiar de página
          });
        },
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: isDarkMode ? Colors.green : Colors.black87,
        showLabel: false,
        textOverflow: TextOverflow.visible,
        maxLine: 1,
        shadowElevation: 5,
        kBottomRadius: 28.0,
        notchColor: Colors.green,
        removeMargins: false,
        bottomBarWidth: 500,
        showShadow: false,
        durationInMilliSeconds: 300,
        itemLabelStyle: const TextStyle(fontSize: 10, color: Colors.white),
        elevation: 1,
        bottomBarItems: [
          const BottomBarItem(
            inActiveItem: Icon(Icons.article, color: Colors.white),
            activeItem: Icon(Icons.article, color: Colors.white),
            itemLabel: 'Artículos',
          ),
          const BottomBarItem(
            inActiveItem: Icon(Icons.podcasts, color: Colors.white),
            activeItem: Icon(Icons.podcasts, color: Colors.white),
            itemLabel: 'Podcasts',
          ),
          if (authProvider.isAuthenticated)
            const BottomBarItem(
              inActiveItem: Icon(Icons.add, color: Colors.white),
              activeItem: Icon(Icons.add, color: Colors.white),
              itemLabel: 'Add',
            ),
          const BottomBarItem(
            inActiveItem: Icon(Icons.person, color: Colors.white),
            activeItem: Icon(Icons.person, color: Colors.white),
            itemLabel: 'Perfil',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.jumpToPage(index); // Cambiar de página al hacer clic
        },
        kIconSize: 24.0,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose(); // Asegúrate de liberar el controlador
    super.dispose();
  }
}