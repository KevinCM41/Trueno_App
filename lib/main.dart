import 'package:flutter/material.dart';

// Función principal que inicia la aplicación
void main() {
  runApp(const UberHomeApp());
}

// Widget principal de la aplicación (sin estado)
class UberHomeApp extends StatelessWidget {
  const UberHomeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Configuración de la aplicación Material
    return MaterialApp(
      title: 'RideApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
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
  int _selectedIndex = 0; // Índice seleccionado en la navegación inferior
  bool _isStatisticsExpanded = false; // Estado de expansión de estadísticas
  final String nombreUsuario = "Alexandra"; // Nombre del usuario
  final String nombreVista = "Home"; // Nombre de la vista actual

  // Lista de datos para las estadísticas
  final List<Map<String, dynamic>> statistics = [
    {
      'name': 'Henry Alex',
      'subtitle': 'Registered 1993',
      'amount': '\$230.50',
      'avatar': '👨',
      'showPayButton': false,
    },
    {
      'name': 'Cody Fisher',
      'subtitle': 'Requested 1000',
      'amount': '\$4408',
      'avatar': '👨‍💼',
      'showPayButton': false,
    },
    {
      'name': 'Guy Hawkins',
      'subtitle': 'Registered 1993',
      'amount': '\$395.64',
      'avatar': '👨‍🦱',
      'showPayButton': false,
    },
    {
      'name': 'Devon Lane',
      'subtitle': 'Registered 1500',
      'amount': '\$132.00',
      'avatar': '👩',
      'showPayButton': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2332), // Color de fondo oscuro

      // Barra de aplicación superior
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2332),
        elevation: 0,
        // Botón de menú hamburguesa
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 28),
          onPressed: () {},
        ),
        // Título de la barra
        title: Text(
          nombreVista,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        // Botón de perfil en la parte derecha
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),

      // Cuerpo principal
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección de saludo personalizado
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola, $nombreUsuario',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '¿A dónde quieres ir hoy?',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Sección del mapa interactivo expandido
          Expanded(
            flex: _isStatisticsExpanded ? 2 : 4,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF2A3647),
              ),
              child: Stack(
                children: [
                  // Fondo con gradiente para simular mapa
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF2A3647),
                          Color(0xFF1A2332),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.map_outlined,
                        size: 120,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                  // Botón para ver el mapa completo
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.navigation, size: 18),
                      label: const Text('Ver Mapa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A9DFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sección de estadísticas con expansión dinámica
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            height: _isStatisticsExpanded ? 450 : 120,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8EAF0),
                  Color(0xFFD5D9E5),
                ],
              ),
            ),
            child: Column(
              children: [
                // Encabezado de estadísticas (clickeable)
                InkWell(
                  onTap: () {
                    setState(() {
                      _isStatisticsExpanded = !_isStatisticsExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Statistics',
                          style: TextStyle(
                            color: Color(0xFF2A3647),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'View All',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              _isStatisticsExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: const Color(0xFF6B7280),
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
                          left: 20, right: 20, bottom: 20),
                      child: Column(
                        children: [
                          // Subtítulos de la tabla de estadísticas
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Senders & Receivers',
                                  style: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Amount',
                                  style: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Lista de elementos de estadísticas
                          ...statistics.map((stat) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
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
                                        width: 48,
                                        height: 48,
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
                                              BorderRadius.circular(24),
                                        ),
                                        child: Center(
                                          child: Text(
                                            stat['avatar'],
                                            style: const TextStyle(fontSize: 24),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Nombre y subtítulo del usuario
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            stat['name'],
                                            style: const TextStyle(
                                              color: Color(0xFF2A3647),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            stat['subtitle'],
                                            style: const TextStyle(
                                              color: Color(0xFF9CA3AF),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Botón de pago o cantidad mostrada
                                  stat['showPayButton']
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFFB923C),
                                                Color(0xFFFBBF24),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFFFB923C)
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Text(
                                            'Pay Now',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          stat['amount'],
                                          style: const TextStyle(
                                            color: Color(0xFF2A3647),
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
        ],
      ),

      // Barra de navegación inferior
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A2332),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: const Color(0xFF1A2332),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF4A9DFF),
          unselectedItemColor: Colors.white.withOpacity(0.5),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          // Elementos de navegación
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Buscar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Historial',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}