import 'package:flutter/material.dart';
import 'package:myapp2/main.dart';
import 'package:myapp2/pages/articles/news_detail_page.dart';
import 'package:myapp2/pages/articles/news_list_page.dart';
import 'package:myapp2/pages/user/edit_profile_page.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            // Obtén los datos del usuario desde el AuthProvider
            const String profileImageUrl = 'https://via.placeholder.com/150'; // Imagen predeterminada
            final String name = authProvider.currentUser?.username ?? 'Guest User';
            final String email = authProvider.currentUser?.email ?? 'Sin mail registrado';
            final String aboutMe = authProvider.currentUser?.aboutMe ?? 'Sin bio registrada';

            return Column(
              children: [
                // Imagen de perfil
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(profileImageUrl),
                  ),
                ),
                // Botón de editar perfil
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(user: authProvider.currentUser),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: const Size(double.infinity, 0), // Ancho completo
                    ),
                    child: Text('Editar Perfil'),
                  ),
                ),
                const SizedBox(height: 20),
                // Información del usuario
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Acerca de mi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          aboutMe,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Botón de cerrar sesión
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () async {
                      authProvider.logout();  // Llamar a la función de logout del provider
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );  // Redirigir al login
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87, // Cambiar el color a rojo para indicar un cierre de sesión
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: const Size(double.infinity, 0) // Ancho completo
                    ),
                    child: Text('Cerrar Sesión',style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}