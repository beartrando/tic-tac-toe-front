import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/infrastructure/device/device_id_provider_factory.dart';
import 'package:front/infrastructure/device/device_service.dart';
import 'package:front/infrastructure/http/clients/http_client.dart';
import 'package:front/infrastructure/http/config/http_config.dart';
import 'package:front/infrastructure/storage/secure_storage.dart';

/// Простой клиент для отправки диагностических данных с приложения на сервер.
///
/// Отправка выполняется fire-and-forget: метод не блокирует вызывающий код,
/// а сетевые ошибки и таймауты не приводят к сбою приложения.
///
/// Если в переменных окружения задан `DEBUG_DEVICE`, логи отправляются только
/// с устройства, чей идентификатор совпадает с ним; логи с других устройств
/// игнорируются.
class ServerLog {
  static const Duration _timeout = Duration(seconds: 3);

  static HttpConfig _buildConfig() {
    try {
      final raw = dotenv.env['GATEWAY_HTTP_ADDRESS']?.trim();
      if (raw != null && raw.isNotEmpty) {
        return HttpConfig.fromEnv();
      }
    } catch (_) {
      // dotenv может быть не инициализирован — используем значение по умолчанию.
    }
    return const HttpConfig(origin: 'https://tic-tac-toe.beartrando.org');
  }

  static DeviceService? _deviceService;

  static DeviceService? get _deviceServiceInstance {
    if (_deviceService != null) {
      return _deviceService;
    }
    try {
      _deviceService = DeviceService(
        deviceIdProvider: createDeviceIdProvider(),
        storage: SecureStorage(),
      );
    } catch (_) {
      _deviceService = null;
    }
    return _deviceService;
  }

  static void log(String event, Object? data) {
    unawaited(_send(event, data));
  }

  static Future<void> _send(String event, Object? data) async {
    try {
      final debugDevice = _readEnv('DEBUG_DEVICE');
      if (debugDevice != null && debugDevice.isNotEmpty) {
        final allowedDevices = debugDevice
            .split(RegExp(r'[,\s]+'))
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toList();

        if (allowedDevices.isNotEmpty) {
          String? currentDeviceId;
          final service = _deviceServiceInstance;
          if (service != null) {
            try {
              currentDeviceId = (await service.getDeviceId()).value;
            } catch (_) {
              currentDeviceId = null;
            }
          }
          if (currentDeviceId == null ||
              !allowedDevices.contains(currentDeviceId)) {
            return;
          }
        }
      }

      final httpClient = HttpClient(_buildConfig());
      await httpClient
          .post('/gateway/log', body: <String, Object?>{
            'event': event,
            'data': data,
          })
          .timeout(_timeout);
    } catch (_) {
      // Сетевые ошибки, таймауты и проблемы получения id устройства
      // не должны приводить к сбою приложения.
    }
  }

  static String? _readEnv(String key) {
    try {
      final value = dotenv.env[key];
      if (value == null) {
        return null;
      }
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    } catch (_) {
      return null;
    }
  }
}
