import 'package:flutter/material.dart';

class ManageAccountScreen extends StatefulWidget {
  const ManageAccountScreen({Key? key}) : super(key: key);

  @override
  State<ManageAccountScreen> createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  // Datos del usuario pasajero (simulados)
  final Map<String, dynamic> _userData = {
    'name': 'Kevin',
    'email': 'kevin@trueno.com',
    'phone': '+57 300 123 4567',
    'accountType': 'Usuario',
    'totalTrips': 47,
    'joinDate': 'Enero 2024',
    'accountStatus': 'Activa',
    'favoritePaymentMethod': 'Nequi',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      
      // AppBar
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Gestionar Cuenta',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      
      // Body
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface.withOpacity(0.5),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header del perfil
                    _buildProfileHeader(),
                    
                    const SizedBox(height: 30),
                    
                    // Estado de la cuenta
                    _buildAccountStatus(),
                    
                    const SizedBox(height: 30),
                    
                    // Sección: Información Personal
                    _buildSectionTitle('Información Personal'),
                    _buildInfoTile(
                      icon: Icons.person_outline,
                      label: 'Nombre',
                      value: _userData['name'] ?? 'Sin nombre',
                      onTap: () => _showEditDialog('Nombre', _userData['name'] ?? ''),
                    ),
                    _buildInfoTile(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: _userData['email'] ?? 'Sin email',
                      onTap: () => _showEditDialog('Email', _userData['email'] ?? ''),
                    ),
                    _buildInfoTile(
                      icon: Icons.phone_outlined,
                      label: 'Teléfono',
                      value: _userData['phone'] ?? 'Sin teléfono',
                      onTap: () => _showEditDialog('Teléfono', _userData['phone'] ?? ''),
                    ),

                    const SizedBox(height: 20),

                    // Sección: Seguridad
                    _buildSectionTitle('Seguridad'),
                    _buildActionTile(
                      icon: Icons.lock_outline,
                      title: 'Cambiar contraseña',
                      subtitle: 'Actualiza tu contraseña',
                      onTap: () => _showChangePasswordDialog(),
                    ),
                    _buildActionTile(
                      icon: Icons.security,
                      title: 'Autenticación de dos factores',
                      subtitle: 'Protege tu cuenta',
                      onTap: () => _show2FADialog(),
                    ),

                    const SizedBox(height: 20),

                    // Sección: Preferencias
                    _buildSectionTitle('Preferencias'),
                    _buildActionTile(
                      icon: Icons.location_on_outlined,
                      title: 'Direcciones guardadas',
                      subtitle: 'Casa, Trabajo, etc.',
                      onTap: () => _showSavedAddressesDialog(),
                    ),
                    _buildActionTile(
                      icon: Icons.payment_outlined,
                      title: 'Método de pago preferido',
                      subtitle: _userData['favoritePaymentMethod'] ?? 'No configurado',
                      onTap: () => _showPaymentMethodDialog(),
                    ),
                    _buildActionTile(
                      icon: Icons.favorite_outline,
                      title: 'Conductores favoritos',
                      subtitle: 'Gestiona tus conductores favoritos',
                      onTap: () => _showFavoriteDriversDialog(),
                    ),

                    const SizedBox(height: 20),

                    // Sección: Historial y Actividad
                    _buildSectionTitle('Historial y Actividad'),
                    _buildActionTile(
                      icon: Icons.history,
                      title: 'Historial de viajes',
                      subtitle: '${_userData['totalTrips'] ?? 0} viajes realizados',
                      onTap: () => _showTripHistoryDialog(),
                    ),
                    _buildActionTile(
                      icon: Icons.receipt_outlined,
                      title: 'Recibos y facturas',
                      subtitle: 'Ver todos tus recibos',
                      onTap: () => _showReceiptsDialog(),
                    ),
                    _buildActionTile(
                      icon: Icons.star_outline,
                      title: 'Mis calificaciones',
                      subtitle: 'Calificaciones que has dado',
                      onTap: () => _showMyRatingsDialog(),
                    ),

                    const SizedBox(height: 20),

                    // Sección: Opciones de Cuenta
                    _buildSectionTitle('Opciones de Cuenta'),
                    _buildActionTile(
                      icon: Icons.download_outlined,
                      title: 'Descargar datos',
                      subtitle: 'Exporta toda tu información',
                      onTap: () => _showDownloadDataDialog(),
                    ),
                    _buildActionTile(
                      icon: Icons.verified_user_outlined,
                      title: 'Verificación de cuenta',
                      subtitle: 'Verifica tu identidad para mayor seguridad',
                      onTap: () => _showVerificationDialog(),
                    ),

                    const SizedBox(height: 20),

                    // Sección: Zona de Peligro
                    _buildSectionTitle('Zona de Peligro'),
                    _buildActionTile(
                      icon: Icons.pause_circle_outline,
                      title: 'Suspender cuenta temporalmente',
                      titleColor: Colors.orange,
                      subtitle: 'Pausa tu cuenta por un tiempo',
                      onTap: () => _showSuspendAccountDialog(),
                    ),
                    _buildActionTile(
                      icon: Icons.delete_forever_outlined,
                      title: 'Eliminar cuenta',
                      titleColor: Colors.red,
                      subtitle: 'Esta acción no se puede deshacer',
                      onTap: () => _showDeleteAccountDialog(),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para el header del perfil
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(35),
            ),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 35,
            ),
          ),
          
          const SizedBox(width: 20),
          
          // Información del usuario
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userData['name'] ?? 'Usuario',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _userData['accountType'] ?? 'Usuario',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Miembro desde ${_userData['joinDate'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          
          // Botón de editar perfil
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => _showEditProfileDialog(),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar el estado de la cuenta
  Widget _buildAccountStatus() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estado de la cuenta: ${_userData['accountStatus'] ?? 'Desconocido'}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
                Text(
                  'Tu cuenta está verificada y activa',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para títulos de sección
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.titleMedium?.color,
        ),
      ),
    );
  }

  // Widget para elementos de información editables
  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        trailing: Icon(
          Icons.edit,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        onTap: onTap,
      ),
    );
  }

  // Widget para elementos de acción
  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: titleColor ?? Theme.of(context).primaryColor),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: titleColor ?? Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        onTap: onTap,
      ),
    );
  }

  // Métodos para mostrar diálogos
  void _showEditDialog(String field, String currentValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController(text: currentValue);
        
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Editar $field',
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          content: TextField(
            controller: controller,
            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
            decoration: InputDecoration(
              labelText: field,
              labelStyle: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Aquí iría la lógica para actualizar el campo
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$field actualizado correctamente')),
                );
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Editar Perfil',
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Funcionalidad de edición de perfil completa',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Cambiar Contraseña',
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Funcionalidad para cambiar contraseña',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _show2FADialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Autenticación de Dos Factores',
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Configurar autenticación de dos factores para mayor seguridad',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showSavedAddressesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Direcciones Guardadas',
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Gestiona tus direcciones favoritas: Casa, Trabajo, etc.',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showPaymentMethodDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Método de Pago Preferido',
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Configura tu método de pago predeterminado',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showFavoriteDriversDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Conductores Favoritos',
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Gestiona tu lista de conductores favoritos',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showTripHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Historial de Viajes',
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          content: Text(
            'Has realizado ${_userData['totalTrips'] ?? 0} viajes',
            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showReceiptsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Recibos y Facturas',
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Aquí puedes ver todos tus recibos de viajes',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showMyRatingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Mis Calificaciones',
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Revisa las calificaciones que has dado a conductores',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showDownloadDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Descargar Datos',
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Descarga toda tu información personal y historial',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Verificación de Cuenta',
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Verifica tu identidad para mayor seguridad',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showSuspendAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Row(
            children: [
              const Icon(Icons.warning, color: Colors.orange),
              const SizedBox(width: 10),
              Text(
                'Suspender Cuenta',
                style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿Estás seguro de que deseas suspender tu cuenta temporalmente?',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Suspender'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Row(
            children: [
              const Icon(Icons.delete_forever, color: Colors.red),
              const SizedBox(width: 10),
              Text(
                'Eliminar Cuenta',
                style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '⚠️ Esta acción no se puede deshacer. Se eliminará toda tu información permanentemente.',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}