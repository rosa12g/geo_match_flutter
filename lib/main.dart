import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'geo_match_flutter.dart';

void main() => runApp(const GeoMatchApp());

class GeoMatchApp extends StatelessWidget {
  const GeoMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoMatch Demo',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const GeoMatchDemo(),
    );
  }
}

class GeoMatchDemo extends StatefulWidget {
  const GeoMatchDemo({super.key});

  @override
  State<GeoMatchDemo> createState() => _GeoMatchDemoState();
}

class _GeoMatchDemoState extends State<GeoMatchDemo> {
  final _matcher = GeoMatcher(debugMode: true);
  final _assigner = GeoAssigner();
  final _random = Random();

  // Fixed request origin (NYC area)
  final _target = GeoUser(id: 'request_1', latitude: 40.7128, longitude: -74.0060);

  late StreamController<List<GeoUser>> _agentsController;
  late Stream<GeoUser?> _nearestStream;
  Timer? _simulationTimer;

  List<GeoUser> _currentAgents = [];
  GeoUser? _nearest;
  String? _assignedId;

  @override
  void initState() {
    super.initState();
    _agentsController = StreamController<List<GeoUser>>.broadcast();
    _nearestStream = _matcher.matchStream(_agentsController.stream, _target);
    _nearestStream.listen((agent) {
      setState(() => _nearest = agent);
    });
    _startSimulation();
  }

  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      final agents = List.generate(5, (i) {
        final latOffset = (_random.nextDouble() - 0.5) * 0.05;
        final lonOffset = (_random.nextDouble() - 0.5) * 0.05;
        return GeoUser(
          id: 'agent_${i + 1}',
          latitude: _target.latitude + latOffset,
          longitude: _target.longitude + lonOffset,
          available: _random.nextBool(),
          metadata: {'rating': (3.0 + _random.nextDouble() * 2).toStringAsFixed(1)},
        );
      });
      setState(() => _currentAgents = agents);
      _agentsController.add(agents);
    });
  }

  void _assignNearest() {
    if (_nearest == null) return;
    _assigner.assign('request_1', _nearest!);
    setState(() => _assignedId = _nearest!.id);
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _agentsController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GeoMatch — Live Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoCard(
              label: 'Request Origin',
              value: '${_target.latitude.toStringAsFixed(4)}, ${_target.longitude.toStringAsFixed(4)}',
              color: Colors.blue.shade50,
            ),
            const SizedBox(height: 12),
            Text('Agents (updating every 2s)',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _currentAgents.length,
                itemBuilder: (_, i) {
                  final agent = _currentAgents[i];
                  final dist = GeoUtils.calculateDistance(
                    _target.latitude, _target.longitude,
                    agent.latitude, agent.longitude,
                  );
                  final isNearest = agent.id == _nearest?.id;
                  return ListTile(
                    leading: Icon(
                      Icons.person_pin_circle,
                      color: isNearest
                          ? Colors.green
                          : agent.available
                              ? Colors.blue
                              : Colors.grey,
                    ),
                    title: Text(agent.id),
                    subtitle: Text(
                        '${dist.toStringAsFixed(3)} km • rating: ${agent.metadata?['rating'] ?? 'N/A'}'),
                    trailing: Chip(
                      label: Text(agent.available ? 'Available' : 'Busy'),
                      backgroundColor:
                          agent.available ? Colors.green.shade100 : Colors.red.shade100,
                    ),
                    tileColor: isNearest ? Colors.green.shade50 : null,
                  );
                },
              ),
            ),
            const Divider(),
            _InfoCard(
              label: 'Nearest Agent',
              value: _nearest != null
                  ? '${_nearest!.id} (${GeoUtils.calculateDistance(_target.latitude, _target.longitude, _nearest!.latitude, _nearest!.longitude).toStringAsFixed(3)} km)'
                  : 'None available',
              color: Colors.green.shade50,
            ),
            if (_assignedId != null) ...[
              const SizedBox(height: 8),
              _InfoCard(
                label: 'Assigned',
                value: _assignedId!,
                color: Colors.orange.shade50,
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _nearest != null ? _assignNearest : null,
                icon: const Icon(Icons.assignment_turned_in),
                label: const Text('Assign Nearest Agent'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
