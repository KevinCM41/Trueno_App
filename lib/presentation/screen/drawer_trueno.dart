import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import 'administracion_cuentas.dart';

class DrawerTrueno extends StatefulWidget {
  const DrawerTrueno({Key? key}) : super(key: key);

  @override
  State<DrawerTrueno> createState() => _DrawerTruenoState();
}

class _DrawerTruenoState extends State<DrawerTrueno> {
  // Variables para el estado del drawer
  String _selectedLanguage = 'Español';
  final List<String> _languages = ['Español', 'English', 'Français'];
  bool _notificationNovedades = true;
  bool _notificationActualizaciones = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
      child: Column(
        children: [
          // Header del drawer con diseño personalizado
          _buildDrawerHeader(),

          // Lista de opciones del drawer
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Sección de Apariencia
                _buildSectionTitle('Apariencia'),
                _buildThemeToggle(),

                // Sección de Idioma
                _buildSectionTitle('Idioma'),
                _buildLanguageDropdown(),

                // Sección de Notificaciones
                _buildSectionTitle('Notificaciones'),
                _buildNotificationTile('Novedades de la App', Icons.notifications_active),
                _buildNotificationTile('Actualizaciones', Icons.system_update),

                // Sección de Comunicación
                _buildSectionTitle('Comunicación'),
                _buildCommunicationTile('Chat', Icons.chat_bubble_outline),
                _buildCommunicationTile('Llamada con el conductor', Icons.phone),

                // Divisor
                _buildDivider(),

                // Sección de Cuenta
                _buildMenuTile('Gestionar Cuenta', Icons.account_circle, () {
                  // Navegar a gestión de cuenta
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageAccountScreen(),
                    ),
                  );
                }),
                _buildMenuTile('Ayuda & Soporte', Icons.help_outline, () {}),
                _buildMenuTile('Acerca de', Icons.info_outline, () {}),

                // Divisor
                _buildDivider(),

                // Opción de cerrar sesión
                _buildMenuTile(
                  'Cerrar Sesión',
                  Icons.logout,
                  () => _showLogoutDialog(),
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para construir el header del drawer
  Widget _buildDrawerHeader() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        
        return Container(
          height: 220,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4CAF50),
                Color(0xFF2A3647),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Avatar del usuario
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Nombre del usuario
                  Text(
                    user != null ? user['username'] ?? 'Usuario' : 'Usuario',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Email o información adicional
                  Text(
                    user != null ? user['email'] ?? 'email@trueno.com' : 'email@trueno.com',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget para títulos de sección
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.6),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // Widget para el toggle de tema
  Widget _buildThemeToggle() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ListTile(
          leading: Icon(
            themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(
            'Modo oscuro',
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          trailing: Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
              // Mostrar SnackBar de confirmación
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    value ? 'Modo oscuro activado' : 'Modo claro activado',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            activeColor: const Color(0xFF4CAF50),
          ),
        );
      },
    );
  }

  // Widget para el dropdown de idiomas
  Widget _buildLanguageDropdown() {
    return ListTile(
      leading: Icon(
        Icons.language,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        'Idioma',
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
      trailing: DropdownButton<String>(
        value: _selectedLanguage,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        items: _languages.map((String language) {
          return DropdownMenuItem<String>(
            value: language,
            child: Text(language),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedLanguage = newValue!;
          });
        },
      ),
    );
  }

  // Widget para notificaciones
  Widget _buildNotificationTile(String title, IconData icon) {
    bool currentValue = title == 'Novedades de la App' 
        ? _notificationNovedades 
        : _notificationActualizaciones;
    
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
      trailing: Switch(
        value: currentValue,
        onChanged: (bool value) {
          setState(() {
            if (title == 'Novedades de la App') {
              _notificationNovedades = value;
            } else {
              _notificationActualizaciones = value;
            }
          });
        },
        activeColor: const Color(0xFF4CAF50),
      ),
    );
  }

  // Widget para tiles de comunicación
  Widget _buildCommunicationTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).iconTheme.color,
        size: 16,
      ),
      onTap: () => _handleCommunicationTap(title),
    );
  }

  // Widget para tiles de menú generales
  Widget _buildMenuTile(String title, IconData icon, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: isDestructive ? Colors.red : Theme.of(context).iconTheme.color,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  // Widget para el divisor
  Widget _buildDivider() {
    return Divider(
      color: Theme.of(context).dividerColor,
      thickness: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  // Manejar taps de comunicación
  void _handleCommunicationTap(String option) {
    if (option == 'Chat') {
      _showChatDialog();
    } else if (option == 'Llamada con el conductor') {
      _showCallDialog();
    }
  }

  // Mostrar diálogo de chat
  void _showChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          title: Row(
            children: [
              Icon(Icons.chat_bubble_outline, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                'Chat',
                style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
              ),
            ],
          ),
          content: Text(
            'Función de chat en desarrollo. Pronto podrás comunicarte directamente con tu conductor.',
            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Entendido',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  // Mostrar diálogo de llamada
  void _showCallDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          title: Row(
            children: [
              Icon(Icons.phone, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                'Llamada',
                style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
              ),
            ],
          ),
          content: Text(
            'Función de llamadas en desarrollo. Pronto podrás llamar directamente a tu conductor.',
            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Entendido',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  // Mostrar diálogo de cerrar sesión
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          title: Text(
            'Cerrar Sesión',
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          content: Text(
            '¿Estás seguro de que quieres cerrar sesión?',
            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar el diálogo
                Navigator.of(context).pop(); // Cerrar el drawer
                
                // Cerrar sesión usando AuthProvider
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final success = await authProvider.logout();
                
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sesión cerrada exitosamente'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                // La navegación se hará automáticamente por el estado del provider
              },
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}