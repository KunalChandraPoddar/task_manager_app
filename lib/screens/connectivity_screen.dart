import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';

class ConnectivityScreen extends StatefulWidget {
  const ConnectivityScreen({super.key});

  @override
  State<ConnectivityScreen> createState() => _ConnectivityScreenState();
}

class _ConnectivityScreenState extends State<ConnectivityScreen> {
  final ConnectivityService _connectivityService = ConnectivityService();

  IconData _icon = Icons.wifi;
  Color _color = Colors.green;
  String _label = 'Online';

  @override
  void initState() {
    super.initState();

    _connectivityService.stream.listen((status) {
      switch (status) {
        case ConnectionStatus.wifiOn:
          _updateUI(Icons.wifi, Colors.green, 'Wi-Fi Online');
          _showSnackBar('Wi-Fi turned ON', Colors.green);
          break;

        case ConnectionStatus.wifiOff:
          _updateUI(Icons.wifi_off, Colors.red, 'Wi-Fi Off');
          _showSnackBar('Wi-Fi turned OFF', Colors.red);
          break;

        case ConnectionStatus.mobileOn:
          _updateUI(
              Icons.signal_cellular_alt, Colors.green, 'Mobile Data Online');
          _showSnackBar('Mobile data turned ON', Colors.green);
          break;

        case ConnectionStatus.mobileOff:
          _updateUI(
              Icons.signal_cellular_off, Colors.red, 'Mobile Data Off');
          _showSnackBar('Mobile data turned OFF', Colors.red);
          break;

        case ConnectionStatus.offline:
          _updateUI(Icons.cloud_off, Colors.red, 'Offline');
          _showSnackBar('No internet connection', Colors.red);
          break;
      }
    });
  }

  void _updateUI(IconData icon, Color color, String label) {
    setState(() {
      _icon = icon;
      _color = color;
      _label = label;
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connectivity Status')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, size: 80, color: _color),
            const SizedBox(height: 16),
            Text(
              _label,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
