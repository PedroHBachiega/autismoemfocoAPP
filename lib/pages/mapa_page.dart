import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  // Coordenada central (São Paulo - Capital)
  final LatLng _center = const LatLng(-23.5505, -46.6333);

  // Lista mockada de clínicas/centros de apoio
  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'Clínica Harmonia - Neurodivergência',
      'position': const LatLng(-23.5605, -46.6433),
      'description': 'Atendimento especializado: Terapia Ocupacional e Psicologia.',
    },
    {
      'name': 'Centro de Apoio TEA SP',
      'position': const LatLng(-23.5405, -46.6233),
      'description': 'Grupos de apoio e atividades inclusivas.',
    },
    {
      'name': 'Clínica Desenvolvimento Pleno',
      'position': const LatLng(-23.5705, -46.6533),
      'description': 'Fonoaudiologia e Neuropediatria.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rede de Apoio - Mapa'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _center,
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.autismo_em_foco_flutter',
          ),
          MarkerLayer(
            markers: _locations.map((loc) {
              return Marker(
                point: loc['position'] as LatLng,
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => _buildLocationDetails(context, loc),
                    );
                  },
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              );
            }).toList(),
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDetails(BuildContext context, Map<String, dynamic> loc) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc['name'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 12),
          Text(
            loc['description'],
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Em um app real, poderia abrir Google Maps ou Waze usando url_launcher
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegação seria iniciada aqui.')),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.directions),
              label: const Text('Traçar Rota'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
