import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignIn = true;
  bool _agreeTerms = false;
  bool _isLoading = false;
  
  // Controladores de texto
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Función para validar email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Función para manejar autenticación
  void _handleAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (_isSignIn) {
      // Validación para login
      if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
        _showErrorMessage('Por favor, completa todos los campos');
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Realizar login
      final result = await authProvider.login(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        _showSuccessMessage('¡Bienvenido de vuelta!');
        // La navegación se hará automáticamente por el estado del provider
      } else {
        _showErrorMessage(result['message']);
      }
    } else {
      // Validación para registro
      if (_usernameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty) {
        _showErrorMessage('Por favor, completa todos los campos');
        return;
      }
      
      if (!_isValidEmail(_emailController.text.trim())) {
        _showErrorMessage('Por favor, ingresa un email válido');
        return;
      }
      
      if (_passwordController.text.length < 6) {
        _showErrorMessage('La contraseña debe tener al menos 6 caracteres');
        return;
      }
      
      if (_passwordController.text != _confirmPasswordController.text) {
        _showErrorMessage('Las contraseñas no coinciden');
        return;
      }
      
      if (!_agreeTerms) {
        _showErrorMessage('Debes aceptar los términos de uso');
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Realizar registro
      final result = await authProvider.register(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        _showSuccessMessage('¡Cuenta creada exitosamente!');
        // La navegación se hará automáticamente por el estado del provider
      } else {
        _showErrorMessage(result['message']);
      }
    }
  }

  // Función para mostrar mensajes de error
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Función para mostrar mensajes de éxito
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Si el usuario se logueó exitosamente, no mostramos esta pantalla
        // La navegación la maneja main.dart
        
        return Scaffold(
          backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.asset(
                    'lib/Logo_Trueno/LOGO_TRUENO.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.motorcycle,
                        color: Color(0xFF4CAF50),
                        size: 60,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Tabs
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSignIn = true;
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            'INICIAR',
                            style: TextStyle(
                              color: _isSignIn ? Colors.white : Colors.white54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: _isSignIn ? const Color(0xFF4CAF50) : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSignIn = false;
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            'REGISTRAR',
                            style: TextStyle(
                              color: !_isSignIn ? Colors.white : Colors.white54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: !_isSignIn ? const Color(0xFF4CAF50) : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Form
              if (_isSignIn) ...[
                // Sign In Form
                _buildTextField(
                  icon: Icons.person_outline,
                  hint: 'Nombre de usuario',
                  controller: _usernameController,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  icon: Icons.lock_outline,
                  hint: 'Contraseña',
                  isPassword: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: const TextSpan(
                      text: '¿Olvidaste tu contraseña? ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: 'Clickea aquí',
                          style: TextStyle(
                            color: Color(0xFF4CAF50),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Sign Up Form
                _buildTextField(
                  icon: Icons.person_outline,
                  hint: 'Nombre de usuario',
                  controller: _usernameController,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  icon: Icons.email_outlined,
                  hint: 'Correoeo electrónico',
                  controller: _emailController,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  icon: Icons.lock_outline,
                  hint: 'Contraseña',
                  isPassword: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  icon: Icons.lock_outline,
                  hint: 'Repetir contraseña',
                  isPassword: true,
                  controller: _confirmPasswordController,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _agreeTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreeTerms = value ?? false;
                          });
                        },
                        fillColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color(0xFF4CAF50);
                          }
                          return Colors.transparent;
                        }),
                        side: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    RichText(
                      text: const TextSpan(
                        text: 'Acepto los ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                        children: [
                          TextSpan(
                            text: 'términos de uso',
                            style: TextStyle(
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 40),

              // Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _isSignIn ? 'INICIAR' : 'REGISTRAR',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                ),
              ),

              if (_isSignIn) ...[
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.facebook, color: Colors.white, size: 20),
                        label: const Text(
                          'Facebook',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'O',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, color: Colors.white, size: 20),
                        label: const Text(
                          'Google +',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
        );
      },
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hint,
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white24,
            width: 1,
          ),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white54, size: 20),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}