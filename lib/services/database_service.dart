import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseService {
  static DatabaseService? _instance;
  static Database? _database;

  DatabaseService._internal();

  static DatabaseService get instance {
    _instance ??= DatabaseService._internal();
    return _instance!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, 'trueno_users.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        created_at TEXT NOT NULL,
        is_logged_in INTEGER DEFAULT 0
      )
    ''');
  }

  // Función para encriptar contraseñas
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Registrar nuevo usuario
  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final db = await database;
      
      // Verificar si el usuario ya existe
      final existingUser = await db.query(
        'users',
        where: 'username = ? OR email = ?',
        whereArgs: [username, email],
      );

      if (existingUser.isNotEmpty) {
        return {
          'success': false,
          'message': 'El usuario o email ya existe',
        };
      }

      // Crear nuevo usuario
      final hashedPassword = _hashPassword(password);
      final userId = await db.insert('users', {
        'username': username,
        'email': email,
        'password_hash': hashedPassword,
        'created_at': DateTime.now().toIso8601String(),
        'is_logged_in': 1, // Marcar como logueado al registrarse
      });

      return {
        'success': true,
        'message': 'Usuario registrado exitosamente',
        'userId': userId,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al registrar usuario: $e',
      };
    }
  }

  // Iniciar sesión
  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      final db = await database;
      final hashedPassword = _hashPassword(password);
      
      final user = await db.query(
        'users',
        where: 'username = ? AND password_hash = ?',
        whereArgs: [username, hashedPassword],
      );

      if (user.isEmpty) {
        return {
          'success': false,
          'message': 'Usuario o contraseña incorrectos',
        };
      }

      // Marcar como logueado
      await db.update(
        'users',
        {'is_logged_in': 1},
        where: 'id = ?',
        whereArgs: [user.first['id']],
      );

      return {
        'success': true,
        'message': 'Inicio de sesión exitoso',
        'user': user.first,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al iniciar sesión: $e',
      };
    }
  }

  // Cerrar sesión
  Future<bool> logoutUser() async {
    try {
      final db = await database;
      await db.update(
        'users',
        {'is_logged_in': 0},
        where: 'is_logged_in = ?',
        whereArgs: [1],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Verificar si hay usuario logueado
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final db = await database;
      final users = await db.query(
        'users',
        where: 'is_logged_in = ?',
        whereArgs: [1],
      );

      if (users.isNotEmpty) {
        return users.first;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtener todos los usuarios (para debugging)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }
}
