import 'package:flutter/material.dart';
import 'request_ride_screen.dart';

/// Widget de mapa alternativo sin API Key para demostración
/// Simula un mapa interactivo con marcadores y ubicación
class SimpleMapWidget extends StatefulWidget {
  const SimpleMapWidget({Key? key}) : super(key: key);

  @override
  State<SimpleMapWidget> createState() => _SimpleMapWidgetState();
}

class _SimpleMapWidgetState extends State<SimpleMapWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  // Posiciones de marcadores (coordenadas simuladas)
  final List<Map<String, dynamic>> _markers = [
    {
      'name': 'Tu ubicación',
      'x': 0.5,
      'y': 0.5,
      'color': Colors.blue,
      'icon': Icons.my_location,
      'isUser': true,
    },
    {
      'name': 'Javier Fernandez',
      'subtitle': '20m',
      'x': 0.6,
      'y': 0.4,
      'color': Colors.orange,
      'icon': Icons.motorcycle,
      'isUser': false,
    },
    {
      'name': 'Miguel Ballesteros',
      'subtitle': '27m',
      'x': 0.3,
      'y': 0.6,
      'color': Colors.orange,
      'icon': Icons.motorcycle,
      'isUser': false,
    },
    {
      'name': 'Alberto Ruiz',
      'subtitle': '12m',
      'x': 0.7,
      'y': 0.3,
      'color': Colors.orange,
      'icon': Icons.motorcycle,
      'isUser': false,
    },
    {
      'name': 'Alex Martinez',
      'subtitle': '7m',
      'x': 0.4,
      'y': 0.7,
      'color': Colors.orange,
      'icon': Icons.motorcycle,
      'isUser': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF2A3647),
      ),
      child: Stack(
        children: [
          // Fondo del mapa simulado
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
            child: CustomPaint(
              painter: MapPainter(),
              size: Size.infinite,
            ),
          ),
          
          // Marcadores en el mapa
          ..._markers.map((marker) => _buildMarker(marker)).toList(),
          
          // Botón de ubicación actual (separado y movido a la derecha)
          Positioned(
            bottom: 210,
            right: 20,
            child: FloatingActionButton(
              mini: false,
              backgroundColor: const Color(0xFF4CAF50),
              onPressed: _centerOnUser,
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          
          // Botón para ver el mapa completo (en su posición original)
          Positioned(
            bottom: 140,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () => _showFullScreenMap(context),
              icon: const Icon(Icons.navigation, size: 18),
              label: const Text('Ver Mapa'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
              ),
            ),
          ),
          
          // Indicador de "Demo Map"
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                'Demo Map - Sin API Key',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarker(Map<String, dynamic> marker) {
    return Positioned(
      left: MediaQuery.of(context).size.width * marker['x'] - 20,
      top: MediaQuery.of(context).size.height * marker['y'] - 40,
      child: GestureDetector(
        onTap: () => _showMarkerInfo(marker),
        child: Column(
          children: [
            // Marcador principal
            AnimatedBuilder(
              animation: marker['isUser'] ? _pulseAnimation : 
                         AlwaysStoppedAnimation(1.0),
              builder: (context, child) {
                return Transform.scale(
                  scale: marker['isUser'] ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: marker['color'],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: marker['color'].withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      marker['icon'],
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                );
              },
            ),
            
            // Texto del marcador (solo para conductores)
            if (!marker['isUser'])
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  marker['subtitle'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _centerOnUser() {
    // Simular centrado en ubicación del usuario
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Centrando en tu ubicación...'),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  void _showMarkerInfo(Map<String, dynamic> marker) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A3647),
        title: Text(
          marker['name'],
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          marker['isUser'] 
            ? 'Esta es tu ubicación actual'
            : 'Conductor disponible - ${marker['subtitle']}',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cerrar',
              style: TextStyle(color: Color(0xFF4CAF50)),
            ),
          ),
          if (!marker['isUser'])
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RequestRideScreen(
                      driverName: marker['name'],
                      driverSubtitle: marker['subtitle'],
                      estimatedTime: marker['subtitle'], // Usando el subtítulo como tiempo estimado
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
              ),
              child: const Text('Solicitar'),
            ),
        ],
      ),
    );
  }

  void _showFullScreenMap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: const Color(0xFF1A2332),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1A2332),
            title: const Text(
              'Mapa Completo',
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: const SimpleMapWidget(),
        ),
      ),
    );
  }
}

/// Painter para dibujar calles y elementos del mapa
class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2;

    // Dibujar líneas que simulan calles
    _drawStreet(canvas, size, 0.2, 0.0, 0.2, 1.0, paint);
    _drawStreet(canvas, size, 0.5, 0.0, 0.5, 1.0, paint);
    _drawStreet(canvas, size, 0.8, 0.0, 0.8, 1.0, paint);
    
    _drawStreet(canvas, size, 0.0, 0.3, 1.0, 0.3, paint);
    _drawStreet(canvas, size, 0.0, 0.6, 1.0, 0.6, paint);
    _drawStreet(canvas, size, 0.0, 0.8, 1.0, 0.8, paint);

    // Dibujar algunos "edificios"
    final buildingPaint = Paint()
      ..color = Colors.white.withOpacity(0.05);
    
    _drawBuilding(canvas, size, 0.1, 0.1, 0.15, 0.2, buildingPaint);
    _drawBuilding(canvas, size, 0.6, 0.15, 0.75, 0.25, buildingPaint);
    _drawBuilding(canvas, size, 0.3, 0.7, 0.4, 0.85, buildingPaint);
  }

  void _drawStreet(Canvas canvas, Size size, double x1, double y1, 
                   double x2, double y2, Paint paint) {
    canvas.drawLine(
      Offset(size.width * x1, size.height * y1),
      Offset(size.width * x2, size.height * y2),
      paint,
    );
  }

  void _drawBuilding(Canvas canvas, Size size, double x1, double y1,
                     double x2, double y2, Paint paint) {
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * x1,
        size.height * y1,
        size.width * (x2 - x1),
        size.height * (y2 - y1),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
