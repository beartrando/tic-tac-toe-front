# front

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

dart run flutter_launcher_icons
dart run flutter_native_splash:create

⚠ Heads up, you have less than 5% of your monthly limit left. Run /status for a breakdown.

• Ревью завершено. Изменений не вносил. Главные риски — жизненный цикл WebSocket, авторизация и неработающая интеграция
Crashlytics.

1. Критично: Crashlytics фактически не подключён. В main.dart нет Firebase.initializeApp(...), FirebaseErrorReporter
   нигде не создаётся и не вызывается. Сейчас ошибки только пишутся в консоль и Logger; в
   Firebase они не уйдут.
   Файлы: lib/main.dart:19, lib/infrastructure/error/firebase_error_reporter.dart:4.

2. Критично: утечка WebSocket-соединений. Очистка через ref.onDispose зарегистрирована после yield*. Обычно поток не
   завершается сам, поэтому обработчик не будет зарегистрирован и сокет с heartbeat-таймером
   останется жить после ухода с экрана. Зарегистрировать ref.onDispose нужно до первого yield.
   Файл: lib/features/battle/providers/battle_stream_provider.dart:25.

3. Высокий: возможен LateInitializationError при уходе с экрана боя. battleService и _battle объявлены late, но
   dispose() обращается к ним, даже если пользователь вернулся назад до загрузки провайдеров.
   Файл: lib/features/battle/ui/battle_screen.dart:24.

4. Высокий: повторные команды start и повторные диалоги завершения. Побочный эффект выполняется прямо в build: при
   каждой перерисовке состояния ready отправляется start, а при завершённой партии планируется
   новый диалог. Нужны защита по идентификатору партии/статусу либо перенос в listener провайдера.
   Файлы: lib/features/battle/ui/battle_screen.dart:62, lib/features/battle/ui/widgets/battle_content.dart:47.

5. Высокий: обработка 401 удаляет refresh-токен до попытки обновления. При первом 401 клиент вызывает
   clearRefreshToken(), а затем ensureAccessToken(). Это лишает приложение возможности обновить сессию и может
   создавать нового анонимного пользователя. Также параллельные запросы могут одновременно обновлять/перезаписывать
   токены.
   Файлы: lib/infrastructure/http/clients/authorized_http_client.dart:58, lib/infrastructure/auth/auth_service.dart:59.

6. Высокий: HTTP-запросы без таймаутов. Зависший сервер или сеть могут оставить загрузочные экраны навсегда. Стоит
   задать единый timeout и преобразовывать TimeoutException/сетевые ошибки в типизированные
   исключения.
   Файл: lib/infrastructure/http/clients/http_client.dart:31.

7. Средний: настройки не сохраняются. Методы SettingNotifier помечены async, но не вызывают SettingStorage.save(). После
   перезапуска все переключатели вернутся к старому сохранённому значению.
   Файл: lib/features/setting/application/setting_notifier.dart:13.

8. Средний: диагностические сообщения искажены. В main.dart интерполяция экранирована: в логе будет буквальный $
   {details...}. В асинхронном обработчике выводится \\n, а не перенос строки. Это заметно осложнит
   расследование падений.
   Файл: lib/main.dart:35.

9. Средний: WebSocket передаёт access token в query string и всегда использует ws://. Токен может попасть в access-логи
   прокси, а на production без wss:// передаётся незашифрованно. Лучше использовать
   защищённый transport и, если сервер позволяет, заголовок/одноразовый ticket вместо query-параметра.
   Файл: lib/infrastructure/websocket/websocket_connection.dart:48.

10. Тестов по сути нет. Единственный тест сравнивает Finder со строкой и должен падать; домен, авторизация, HTTP-ретраи
    и WebSocket не покрыты.
    Файл: test/widget_test.dart:10.

Не смог запустить flutter analyze: установленный Flutter пытается обновить cache в недоступной для записи директории.
Первым делом я бы исправил пункты 1–5, затем добавил unit-тесты для авторизации и
провайдеров боя.
