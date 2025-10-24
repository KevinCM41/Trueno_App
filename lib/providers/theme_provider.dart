import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider para manejar el estado del tema de la aplicación
/// Permite cambiar entre modo claro y oscuro y persistir la preferencia
class ThemeProvider with ChangeNotifier {
  // Clave para SharedPreferences
  static const String _themeKey = 'theme_mode';
  
  // Estado interno del tema (por defecto oscuro)
  bool _isDarkMode = true;
  
  // Getter para obtener el estado actual del tema
  bool get isDarkMode => _isDarkMode;
  
  // Constructor que carga la preferencia guardada
  ThemeProvider() {
    _loadThemePreference();
  }
  
  /// Cambia el tema entre claro y oscuro
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemePreference();
    notifyListeners();
  }
  
  /// Establece el tema directamente
  void setTheme(bool isDarkMode) {
    if (_isDarkMode != isDarkMode) {
      _isDarkMode = isDarkMode;
      _saveThemePreference();
      notifyListeners();
    }
  }
  
  /// Carga la preferencia de tema desde SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_themeKey) ?? true; // Por defecto oscuro
      notifyListeners();
    } catch (e) {
      // Si hay error, mantener el valor por defecto
      debugPrint('Error cargando preferencia de tema: $e');
    }
  }
  
  /// Guarda la preferencia de tema en SharedPreferences
  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
    } catch (e) {
      debugPrint('Error guardando preferencia de tema: $e');
    }
  }
  
  /// Tema oscuro personalizado para la aplicación
  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Esquema de colores personalizado
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4CAF50),
      secondary: Color(0xFF66BB6A),
      surface: Color(0xFF1A2332),
      background: Color(0xFF0D1117),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
    ),
    
    // Configuración del AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A2332),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    
    // Configuración del Drawer
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF1A2332),
    ),
    
    // Configuración de cards
    cardTheme: CardThemeData(
      color: const Color(0xFF1A2332),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    // Configuración de botones elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Configuración de texto
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
    
    // Configuración de iconos
    iconTheme: const IconThemeData(color: Colors.white70),
    
    // Configuración de switches
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF4CAF50);
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF4CAF50).withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.3);
      }),
    ),
  );
  
  /// Tema claro personalizado para la aplicación
  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Esquema de colores personalizado para tema claro
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4CAF50),
      secondary: Color(0xFF66BB6A),
      surface: Colors.white,
      background: Color(0xFFF5F5F5),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
    ),
    
    // Configuración del AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    
    // Configuración del Drawer
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
    ),
    
    // Configuración de cards
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    // Configuración de botones elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Configuración de texto
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
    ),
    
    // Configuración de iconos
    iconTheme: const IconThemeData(color: Colors.black54),
    
    // Configuración de switches
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF4CAF50);
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF4CAF50).withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.3);
      }),
    ),
  );
  
  /// Retorna el tema actual basado en isDarkMode
  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;
}
