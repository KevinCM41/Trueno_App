import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'dart:math';

/// Widget del mapa interactivo para la aplicación Trueno
/// Muestra un mapa de Google Maps completamente interactivo con:
/// - Ubicación en tiempo real del usuario
/// - Marcadores de conductores cercanos animados
/// - Controles de zoom y navegación
/// - Tema oscuro personalizado
/// - Funciones de búsqueda y navegación
class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  // Controlador del mapa de Google
  GoogleMapController? _mapController;
  
  // Servicio de ubicación
  final Location _location = Location();
  
  // Ubicación actual del usuario
  LatLng _currentLocation = const LatLng(4.7110, -74.0721); // Bogotá por defecto
  
  // Marcadores en el mapa
  final Set<Marker> _markers = {};
  
  // Timer para actualizar ubicaciones de conductores
  Timer? _driversUpdateTimer;
  
  // Controlador de animación para marcadores
  late AnimationController _animationController;
  
  // Lista de conductores simulados
  final List<Map<String, dynamic>> _drivers = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _initializeLocation();
    _generateRandomDrivers();
    _startDriversAnimation();
  }

  @override
  void dispose() {
    _driversUpdateTimer?.cancel();
    _animationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  /// Inicializa la ubicación del usuario con permisos y configuración completa
  Future<void> _initializeLocation() async {
    try {
      // Verificar si el servicio de ubicación está habilitado
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          _showLocationServiceDialog();
          return;
        }
      }

      // Verificar y solicitar permisos
      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          _showPermissionDialog();
          return;
        }
      }

      // Obtener ubicación actual
      final LocationData locationData = await _location.getLocation();
      
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(
            locationData.latitude!,
            locationData.longitude!,
          );
        });

        // Mover la cámara a la ubicación actual
        if (_mapController != null) {
          await _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(_currentLocation, 15.0),
          );
        }
      }

      // Escuchar cambios de ubicación
      _location.onLocationChanged.listen((LocationData locationData) {
        if (mounted) {
          setState(() {
            _currentLocation = LatLng(
              locationData.latitude!,
              locationData.longitude!,
            );
          });
          _updateUserMarker();
        }
      });

    } catch (e) {
      debugPrint('Error al obtener ubicación: $e');
      _showLocationErrorDialog();
    }
  }

  /// Genera conductores aleatorios cerca de la ubicación actual
  void _generateRandomDrivers() {
    final Random random = Random();
    _drivers.clear();
    
    // Generar 8-12 conductores cerca
    final int driversCount = 8 + random.nextInt(5);
    
    for (int i = 0; i < driversCount; i++) {
      // Ubicación aleatoria en un radio de ~2km
      final double latOffset = (random.nextDouble() - 0.5) * 0.02;
      final double lngOffset = (random.nextDouble() - 0.5) * 0.02;
      
      final LatLng driverLocation = LatLng(
        _currentLocation.latitude + latOffset,
        _currentLocation.longitude + lngOffset,
      );
      
      _drivers.add({
        'id': 'driver_$i',
        'location': driverLocation,
        'originalLocation': driverLocation,
        'name': _getRandomDriverName(),
        'vehicle': _getRandomVehicle(),
        'rating': 4.0 + random.nextDouble(),
        'eta': 2 + random.nextInt(8), // 2-10 minutos
        'price': 8000 + random.nextInt(15000), // 8,000-23,000 COP
      });
    }
    
    _updateDriverMarkers();
  }

  /// Actualiza los marcadores de conductores en el mapa
  void _updateDriverMarkers() {
    if (mounted) {
      setState(() {
        _markers.clear();
        
        // Agregar marcador del usuario
        _updateUserMarker();
        
        // Agregar marcadores de conductores
        for (final driver in _drivers) {
          _markers.add(
            Marker(
              markerId: MarkerId(driver['id']),
              position: driver['location'],
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
              infoWindow: InfoWindow(
                title: driver['name'],
                snippet: '${driver['vehicle']} • ⭐${driver['rating'].toStringAsFixed(1)} • ${driver['eta']} min • \$${driver['price']}',
              ),
              onTap: () => _showDriverDetails(driver),
            ),
          );
        }
      });
    }
  }

  /// Actualiza el marcador del usuario
  void _updateUserMarker() {
    _markers.removeWhere((marker) => marker.markerId.value == 'user_location');
    _markers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: _currentLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
          title: 'Tu ubicación',
          snippet: 'Estás aquí',
        ),
      ),
    );
  }

  /// Inicia la animación de movimiento de conductores
  void _startDriversAnimation() {
    _driversUpdateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        _animateDrivers();
      }
    });
  }

  /// Anima el movimiento de los conductores
  void _animateDrivers() {
    final Random random = Random();
    
    for (final driver in _drivers) {
      // Movimiento aleatorio pequeño para simular conducción
      final double latChange = (random.nextDouble() - 0.5) * 0.001;
      final double lngChange = (random.nextDouble() - 0.5) * 0.001;
      
      driver['location'] = LatLng(
        driver['location'].latitude + latChange,
        driver['location'].longitude + lngChange,
      );
    }
    
    _updateDriverMarkers();
  }

  /// Muestra detalles del conductor seleccionado
  void _showDriverDetails(Map<String, dynamic> driver) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A2332),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barra superior
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            
            // Información del conductor
            Row(
              children: [
                // Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 15),
                
                // Detalles
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        driver['vehicle'],
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 16),
                          Text(
                            ' ${driver['rating'].toStringAsFixed(1)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            ' • ${driver['eta']} min',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Precio
                Column(
                  children: [
                    Text(
                      '\$${driver['price']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'COP',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Botón de solicitar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _requestRide(driver);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Solicitar Viaje',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Solicita un viaje con el conductor seleccionado
  void _requestRide(Map<String, dynamic> driver) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viaje solicitado con ${driver['name']}. Llegará en ${driver['eta']} minutos.'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Métodos de utilidad para nombres y vehículos aleatorios
  String _getRandomDriverName() {
    final names = [
      'Carlos Rodríguez', 'Ana María López', 'José Hernández', 'María González',
      'Luis Martínez', 'Carmen Pérez', 'Miguel Sánchez', 'Laura García',
      'David Ruiz', 'Sofía Jiménez', 'Pablo Moreno', 'Elena Vargas'
    ];
    return names[Random().nextInt(names.length)];
  }

  String _getRandomVehicle() {
    final vehicles = [
      'Toyota Corolla Blanco', 'Chevrolet Spark Azul', 'Renault Logan Gris',
      'Nissan March Rojo', 'Kia Picanto Negro', 'Hyundai i10 Plata',
      'Mazda 2 Blanco', 'Honda City Azul', 'Volkswagen Gol Negro'
    ];
    return vehicles[Random().nextInt(vehicles.length)];
  }

  // Diálogos de error y permisos
  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2332),
        title: const Text('Servicio de Ubicación', style: TextStyle(color: Colors.white)),
        content: const Text('Por favor, habilita el servicio de ubicación para usar el mapa.', 
                          style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2332),
        title: const Text('Permisos de Ubicación', style: TextStyle(color: Colors.white)),
        content: const Text('Se necesitan permisos de ubicación para mostrar tu posición en el mapa.',
                          style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showLocationErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2332),
        title: const Text('Error de Ubicación', style: TextStyle(color: Colors.white)),
        content: const Text('No se pudo obtener tu ubicación. Verifica la configuración del dispositivo.',
                          style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mapa principal
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentLocation,
            zoom: 14.0,
          ),
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            
            // Aplicar tema oscuro personalizado
            _mapController!.setMapStyle('''
              [
                {
                  "elementType": "geometry",
                  "stylers": [{"color": "#1d2c4d"}]
                },
                {
                  "elementType": "labels.text.fill",
                  "stylers": [{"color": "#8ec3b9"}]
                },
                {
                  "elementType": "labels.text.stroke",
                  "stylers": [{"color": "#1a3646"}]
                },
                {
                  "featureType": "administrative.country",
                  "elementType": "geometry.stroke",
                  "stylers": [{"color": "#4b6878"}]
                },
                {
                  "featureType": "administrative.land_parcel",
                  "elementType": "labels.text.fill",
                  "stylers": [{"color": "#64779e"}]
                },
                {
                  "featureType": "poi",
                  "elementType": "geometry",
                  "stylers": [{"color": "#283d6a"}]
                },
                {
                  "featureType": "poi",
                  "elementType": "labels.text.fill",
                  "stylers": [{"color": "#6f9ba4"}]
                },
                {
                  "featureType": "poi",
                  "elementType": "labels.text.stroke",
                  "stylers": [{"color": "#1d2c4d"}]
                },
                {
                  "featureType": "road",
                  "elementType": "geometry",
                  "stylers": [{"color": "#304a7d"}]
                },
                {
                  "featureType": "road",
                  "elementType": "labels.text.fill",
                  "stylers": [{"color": "#98a5be"}]
                },
                {
                  "featureType": "road",
                  "elementType": "labels.text.stroke",
                  "stylers": [{"color": "#1d2c4d"}]
                },
                {
                  "featureType": "road.highway",
                  "elementType": "geometry",
                  "stylers": [{"color": "#2c6675"}]
                },
                {
                  "featureType": "transit",
                  "elementType": "geometry",
                  "stylers": [{"color": "#2f3948"}]
                },
                {
                  "featureType": "water",
                  "elementType": "geometry",
                  "stylers": [{"color": "#0e1626"}]
                },
                {
                  "featureType": "water",
                  "elementType": "labels.text.fill",
                  "stylers": [{"color": "#4e6d70"}]
                }
              ]
            ''');
          },
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: true,
          trafficEnabled: false,
          buildingsEnabled: true,
        ),
        
        // Controles flotantes
        Positioned(
          top: 20,
          right: 20,
          child: Column(
            children: [
              // Botón de ubicación
              FloatingActionButton(
                mini: true,
                backgroundColor: const Color(0xFF1A2332),
                onPressed: () async {
                  if (_mapController != null) {
                    await _mapController!.animateCamera(
                      CameraUpdate.newLatLngZoom(_currentLocation, 15.0),
                    );
                  }
                },
                child: const Icon(Icons.my_location, color: Colors.orange),
              ),
              const SizedBox(height: 10),
              
              // Botón de zoom in
              FloatingActionButton(
                mini: true,
                backgroundColor: const Color(0xFF1A2332),
                onPressed: () async {
                  if (_mapController != null) {
                    await _mapController!.animateCamera(CameraUpdate.zoomIn());
                  }
                },
                child: const Icon(Icons.add, color: Colors.orange),
              ),
              const SizedBox(height: 10),
              
              // Botón de zoom out
              FloatingActionButton(
                mini: true,
                backgroundColor: const Color(0xFF1A2332),
                onPressed: () async {
                  if (_mapController != null) {
                    await _mapController!.animateCamera(CameraUpdate.zoomOut());
                  }
                },
                child: const Icon(Icons.remove, color: Colors.orange),
              ),
            ],
          ),
        ),
        
        // Información flotante superior
        Positioned(
          top: 20,
          left: 20,
          right: 100,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2332).withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.orange, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tu ubicación',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        '${_drivers.length} conductores cerca',
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
