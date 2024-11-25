import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp2/pages/user/register_page.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';
import 'package:myapp2/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final username = _userController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final authService = AuthServices();

      final response = await authService.login(username: username, password: password);

      if (!response['error']) {
        final user = User.fromJson(response['user']); // Usuario deserializado del servidor
        Provider.of<AuthProvider>(context, listen: false).loginWithUser(user);

        // Redirigir al MainScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        _showErrorDialog(response['message']);
      }
    } catch (error) {
      _showErrorDialog('Error al conectar con el servidor');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.05,
                    child: Center(
                      child: Text(
                        "</> " * 1000,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '<BLOGIT/>',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              '"Donde la tecnología se encuentra con la inspiración."',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 50),
                            TextField(
                              controller: _userController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Usuario',
                                labelStyle: const TextStyle(color: Colors.black54),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.05),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                labelStyle: const TextStyle(color: Colors.black54),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.05),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.black54,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            _isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.black87,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Text(
                                  '<btn> Iniciar sesión </btn>',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                '¿No tienes cuenta? Regístrate',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}