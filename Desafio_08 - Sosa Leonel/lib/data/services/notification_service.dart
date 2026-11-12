import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Servicio de notificaciones locales (sección 8.3 de la cartilla).
// OJO: en la versión nueva del paquete (22.x) los parámetros de initialize()
// y show() van con nombre (settings:, id:, title:, body:...).
class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
    );

    // En Android 13 o más nuevo hay que pedir permiso para mostrar notificaciones
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> mostrar({
    required String titulo,
    required String cuerpo,
  }) async {
    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: titulo,
      body: cuerpo,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'canal_asistencia',
          'Asistencia',
          channelDescription: 'Avisos del sistema de asistencia',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}
