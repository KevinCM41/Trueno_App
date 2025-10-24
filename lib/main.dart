import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/screen/drawer_trueno.dart';
import 'presentation/screen/simple_map_widget.dart';
import 'presentation/screen/payment_methods_screen.dart';
import 'presentation/screen/splash_screen.dart';
import 'presentation/screen/register_screen.dart';
import 'presentation/widgets/search_destination_widget.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';

// Función principal que inicia la aplicación
void main() {
  runApp(
    // Configurar múltiples providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const UberHomeApp(),
    ),
  );
}

// Widget principal de la aplicación (sin estado)
class UberHomeApp extends StatefulWidget {
  const UberHomeApp({Key? key}) : super(key: key);

  @override
  State<UberHomeApp> createState() => _UberHomeAppState();
}

class _UberHomeAppState extends State<UberHomeApp> {

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Trueno Home',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const AuthenticationWrapper(),
        );
      },
    );
  }
}

// Widget separado para manejar la autenticación
class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Esperar un frame
    await Future.delayed(Duration.zero);
    
    if (mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.checkAuthStatus();
      
      // Simular splash por 2 segundos
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return SplashScreen(onSplashFinished: () {});
    }

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return authProvider.isLoggedIn ? const HomePage() : const AuthScreen();
      },
    );
  }
}

// Widget de la página principal (con estado)
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// Estado de la página principal
class _HomePageState extends State<HomePage> {
  // Variables de estado
  bool _isStatisticsExpanded = false; // Estado de expansión de estadísticas
  final String nombreUsuario = "Kevin"; // Nombre del usuario
  final String nombreVista = "Inicio"; // Nombre de la vista actual

  // Lista de datos para las estadísticas
  final List<Map<String, dynamic>> statistics = [
    {
      'name': 'Javier Fernandez',
      'subtitle': 'Matrícula GMK-174',
      'amount': '20 m',
      'avatar': '👨',
      'showPayButton': false,
    },
    {
      'name': 'Miguel Ballesteros',
      'subtitle': 'Matrícula HJD-562',
      'amount': '27 m',
      'avatar': '👨‍💼',
      'showPayButton': false,
    },
    {
      'name': 'Alberto Ruiz',
      'subtitle': 'Matrícula XYZ-890',
      'amount': '12 m',
      'avatar': '👨‍🦱',
      'showPayButton': false,
    },
    {
      'name': 'Alex Martinez',
      'subtitle': 'Matrícula ADT-345',
      'amount': '7 m',
      'avatar': '👩',
      'showPayButton': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      // Agregar el drawer personalizado
      drawer: const DrawerTrueno(),

      // Barra de aplicación superior
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        // Botón de menú hamburguesa (se conecta automáticamente al drawer)
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu, 
              color: Theme.of(context).appBarTheme.foregroundColor, 
              size: 28
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        // Título de la barra
        title: Text(
          nombreVista,
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      // Cuerpo principal
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección de saludo personalizado
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna de saludo (lado izquierdo)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, $nombreUsuario',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge?.color,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '¿A dónde quieres ir hoy?',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Botón de métodos de pago (lado derecho)
                const SizedBox(width: 15),
                InkWell(
                  onTap: () {
                    // Navegar a la pantalla de métodos de pago
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentMethodsScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4CAF50),
                          Color(0xFF66BB6A),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4CAF50).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.payment,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Métodos de pago',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sección del mapa interactivo (ahora ocupa todo el espacio disponible)
          Expanded(
            child: Stack(
              children: [
                // Mapa de fondo (siempre del mismo tamaño)
                const SimpleMapWidget(),

                // Sección de solicitudes flotante (superpuesta al mapa)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    height: _isStatisticsExpanded ? 400 : 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.4)
                              : Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Encabezado de solicitudes (clickeable)
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isStatisticsExpanded = !_isStatisticsExpanded;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                            child: Column(
                              children: [
                                // Indicador visual de que es arrastrable
                                Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness == Brightness.dark 
                                        ? Colors.white38 
                                        : const Color(0xFF9CA3AF),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Título y botón de expansión
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Solicitudes',
                                      style: TextStyle(
                                        color: Theme.of(context).brightness == Brightness.dark 
                                            ? Colors.white 
                                            : const Color(0xFF2A3647),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          _isStatisticsExpanded ? 'Contraer' : 'Expandir',
                                          style: TextStyle(
                                            color: Theme.of(context).brightness == Brightness.dark 
                                                ? Colors.white70 
                                                : const Color(0xFF6B7280),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Icon(
                                          _isStatisticsExpanded
                                              ? Icons.keyboard_arrow_down
                                              : Icons.keyboard_arrow_up,
                                          color: Theme.of(context).brightness == Brightness.dark 
                                              ? Colors.white70 
                                              : const Color(0xFF6B7280),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Contenido expandible
                        if (_isStatisticsExpanded)
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 15),
                              child: Column(
                                children: [
                                  // Barra de búsqueda dentro del panel
                                  const SearchDestinationWidget(),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Subtítulos de la tabla de estadísticas
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Conductores & carreras',
                                          style: TextStyle(
                                            color: Theme.of(context).brightness == Brightness.dark 
                                                ? Colors.white54 
                                                : const Color(0xFF9CA3AF),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Distancia',
                                          style: TextStyle(
                                            color: Theme.of(context).brightness == Brightness.dark 
                                                ? Colors.white54 
                                                : const Color(0xFF9CA3AF),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Lista de elementos de estadísticas
                                  ...statistics.map((stat) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardTheme.color,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context).brightness == Brightness.dark 
                                                ? Colors.black.withOpacity(0.3)
                                                : Colors.black.withOpacity(0.05),
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Información del usuario (avatar y datos)
                                          Row(
                                            children: [
                                              // Avatar del usuario
                                              Container(
                                                width: 44,
                                                height: 44,
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Color(0xFFE5E7EB),
                                                      Color(0xFFD1D5DB),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(22),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    stat['avatar'],
                                                    style: const TextStyle(fontSize: 22),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              // Nombre y subtítulo del usuario
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    stat['name'],
                                                    style: TextStyle(
                                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    stat['subtitle'],
                                                    style: TextStyle(
                                                      color: Theme.of(context).brightness == Brightness.dark 
                                                          ? Colors.white54 
                                                          : const Color(0xFF9CA3AF),
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          // Cantidad mostrada
                                          Text(
                                            stat['amount'],
                                            style: TextStyle(
                                              color: Theme.of(context).textTheme.bodyLarge?.color,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}