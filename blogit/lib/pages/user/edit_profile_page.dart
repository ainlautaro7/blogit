import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp2/models/user.dart';
import 'package:myapp2/providers/auth_provider.dart';
import 'package:myapp2/providers/theme_provider.dart';
import 'package:myapp2/services/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, User? user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _aboutMeController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final currentUser =
        Provider.of<AuthProvider>(context, listen: false).currentUser;

    // Inicializamos los controladores con los datos actuales del usuario
    _firstNameController = TextEditingController(text: currentUser?.firstName);
    _lastNameController = TextEditingController(text: currentUser?.lastName);
    _emailController = TextEditingController(text: currentUser?.email);
    _aboutMeController = TextEditingController(text: currentUser?.aboutMe);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _aboutMeController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final updatedUser = User(
      id: Provider.of<AuthProvider>(context, listen: false).currentUser!.id,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      username: Provider.of<AuthProvider>(context, listen: false)
          .currentUser!
          .username,
      email: _emailController.text,
      password: Provider.of<AuthProvider>(context, listen: false)
          .currentUser!
          .password,
      profilePhotoUrl: Provider.of<AuthProvider>(context, listen: false)
          .currentUser!
          .profilePhotoUrl,
      aboutMe: _aboutMeController.text,
    );

    final authService = AuthServices();
    final response = await authService.updateProfile(updatedUser);

    setState(() {
      _isLoading = false;
    });

    if (!response['error']) {
      // Actualizamos el usuario en el proveedor
      Provider.of<AuthProvider>(context, listen: false)
          .loginWithUser(updatedUser);

      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado con éxito')),
      );
      Navigator.pop(context); // Volver atrás
    } else {
      // Muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context).currentUser;
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
        elevation: 5.0,
        backgroundColor: backgroundColor,
        titleTextStyle: TextStyle(color: titleColor, fontSize: 25),
        iconTheme: IconThemeData(
          color: appBarColor, // Color de los íconos
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Avatar de perfil
              CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(
                      currentUser!.profilePhotoUrl.isNotEmpty
                          ? currentUser.profilePhotoUrl
                          : 'https://via.placeholder.com/150')),
              const SizedBox(height: 20),
              // Nombre y Apellido
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ingrese su nombre',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  hintText: 'Ingrese su apellido',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su apellido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Correo electrónico
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  hintText: 'Ingrese su correo electrónico',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su correo electrónico';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Acerca de mí
              TextFormField(
                controller: _aboutMeController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Acerca de mí',
                  hintText: 'Cuéntanos algo sobre ti',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Botón de guardar
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        minimumSize:
                            const Size(double.infinity, 0), // Ancho completo
                      ),
                      child: const Text('Guardar cambios')),
            ],
          ),
        ),
      ),
    );
  }
}
