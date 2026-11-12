import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/services/asistencia_service.dart';
import '../../data/services/notification_service.dart';

class EscanerScreen extends StatefulWidget {
  const EscanerScreen({super.key});

  @override
  State<EscanerScreen> createState() => _EscanerScreenState();
}

class _EscanerScreenState extends State<EscanerScreen> {
  final MobileScannerController _ctrl = MobileScannerController();
  String? _resultado; // nombre del alumno escaneado
  String _mensaje = '';
  bool _activo = true; // true = escaneando
  bool _yaEstaba = false;

  @override
  void dispose() {
    _ctrl.dispose(); // liberar la cámara
    super.dispose();
  }

  Future<void> _procesarCodigo(String codigo) async {
    if (!_activo) return; // evitar procesar el mismo QR varias veces
    setState(() {
      _activo = false;
      _resultado = codigo;
      _mensaje = 'Guardando...';
    });
    _ctrl.stop(); // pausar la cámara

    try {
      bool repetido = await yaRegistradoHoy(codigo);
      if (repetido) {
        // Ya estaba registrado hoy: aviso con notificación local
        await NotificationService.mostrar(
          titulo: 'Asistencia repetida',
          cuerpo: '$codigo ya tiene el presente de hoy',
        );
        setState(() {
          _yaEstaba = true;
          _mensaje = 'Ya estaba registrado hoy';
        });
      } else {
        await registrarAsistencia(codigo);
        setState(() {
          _yaEstaba = false;
          _mensaje = 'Presente guardado a las ${horaActual()}';
        });
      }
    } catch (e) {
      setState(() {
        _yaEstaba = true;
        _mensaje = 'Error al guardar: $e';
      });
    }
  }

  void _escanearDeNuevo() {
    setState(() {
      _resultado = null;
      _mensaje = '';
      _activo = true;
    });
    _ctrl.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        actions: [
          // Botón de linterna
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _ctrl.toggleTorch(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: _ctrl,
              onDetect: (BarcodeCapture capture) {
                if (capture.barcodes.isNotEmpty) {
                  final codigo = capture.barcodes.first.rawValue;
                  if (codigo != null) _procesarCodigo(codigo);
                }
              },
            ),
          ),
          // Panel con el resultado
          if (_resultado != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: _yaEstaba ? Colors.orange.shade50 : Colors.green.shade50,
              child: Column(
                children: [
                  Icon(
                    _yaEstaba ? Icons.warning_amber : Icons.check_circle,
                    color: _yaEstaba ? Colors.orange : Colors.green,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _resultado!,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(_mensaje),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _escanearDeNuevo,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Escanear otro alumno'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
