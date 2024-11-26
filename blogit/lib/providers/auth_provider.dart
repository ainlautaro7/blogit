import 'package:flutter/material.dart';
import 'package:myapp2/models/user.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isGuest = false;
  User? _currentUser; // Instancia del usuario autenticado

  bool get isAuthenticated => _isAuthenticated;
  bool get isGuest => _isGuest;
  User? get currentUser => _currentUser;

  // Método para iniciar sesión con usuario autenticado
  void loginWithUser(User user) {
    _isGuest = false;
    _isAuthenticated = true;
    _currentUser = user;
    notifyListeners();
  }

  // Método para cerrar sesión
  void logout() {
    _isAuthenticated = false;
    _isGuest = false;
    _currentUser = null;
    notifyListeners();
  }

  // Método para iniciar sesión como invitado
  void loginAsGuest() {
    _isGuest = true;
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }
}
