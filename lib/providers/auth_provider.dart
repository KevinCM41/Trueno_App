import 'package:flutter/foundation.dart';
import '../services/database_service.dart';

class AuthProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  
  bool _isLoggedIn = false;
  Map<String, dynamic>? _currentUser;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // Verificar si hay usuario logueado al iniciar la app
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _databaseService.getCurrentUser();
      if (user != null) {
        _isLoggedIn = true;
        _currentUser = user;
      } else {
        _isLoggedIn = false;
        _currentUser = null;
      }
    } catch (e) {
      _isLoggedIn = false;
      _currentUser = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Registrar usuario
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _databaseService.registerUser(
        username: username,
        email: email,
        password: password,
      );

      if (result['success']) {
        _isLoggedIn = true;
        _currentUser = {
          'id': result['userId'],
          'username': username,
          'email': email,
        };
      }

      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Error inesperado: $e',
      };
    }
  }

  // Iniciar sesión
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _databaseService.loginUser(
        username: username,
        password: password,
      );

      if (result['success']) {
        _isLoggedIn = true;
        _currentUser = result['user'];
      }

      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Error inesperado: $e',
      };
    }
  }

  // Cerrar sesión
  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _databaseService.logoutUser();
      if (success) {
        _isLoggedIn = false;
        _currentUser = null;
      }
      
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
