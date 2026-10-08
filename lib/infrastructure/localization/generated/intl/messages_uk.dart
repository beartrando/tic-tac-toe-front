// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a uk locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'uk';

  static String m0(seconds) => "ШІ підключиться через ${seconds} с";

  static String m1(error) =>
      "Сталася помилка. Перезапустіть застосунок і спробуйте ще раз.";

  static String m2(experience) => "Досвід: ${experience}";

  static String m3(id) => "ID: ${id}";

  static String m4(level) => "Рівень: ${level}";

  static String m5(nickname) => "Нікнейм: ${nickname}";

  static String m6(rating) => "Рейтинг: ${rating}";

  static String m7(seconds) => "(${seconds} с)";

  final messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aiWillConnectIn": m0,
    "appTitle": MessageLookupByLibrary.simpleMessage("Хрестики-нулики"),
    "backToMenu": MessageLookupByLibrary.simpleMessage("Вийти в меню"),
    "battleCancelled": MessageLookupByLibrary.simpleMessage("Матч скасовано"),
    "battleReadyWait": MessageLookupByLibrary.simpleMessage(
      "Матч готовий, зачекайте мить.",
    ),
    "battleTitle": MessageLookupByLibrary.simpleMessage(
      "Матч: Хрестики-нулики",
    ),
    "cancelAiConnection": MessageLookupByLibrary.simpleMessage(
      "Скасувати підключення ШІ",
    ),
    "cancelled": MessageLookupByLibrary.simpleMessage("Скасовано"),
    "close": MessageLookupByLibrary.simpleMessage("Закрити"),
    "connectAiNow": MessageLookupByLibrary.simpleMessage("Підключити ШІ зараз"),
    "connectionLost": MessageLookupByLibrary.simpleMessage(
      "З\'єднання із сервером втрачено",
    ),
    "draw": MessageLookupByLibrary.simpleMessage("Нічия"),
    "effects": MessageLookupByLibrary.simpleMessage("Ефекти"),
    "error": m1,
    "loading": MessageLookupByLibrary.simpleMessage("Завантаження..."),
    "localeLoadingError": MessageLookupByLibrary.simpleMessage(
      "Не вдалося завантажити мову. Спробуйте ще раз пізніше.",
    ),
    "matchFinished": MessageLookupByLibrary.simpleMessage("Матч завершено"),
    "notYourTurn": MessageLookupByLibrary.simpleMessage("Хід суперника"),
    "play": MessageLookupByLibrary.simpleMessage("Грати"),
    "playAgain": MessageLookupByLibrary.simpleMessage("Зіграти ще"),
    "playWithAi": MessageLookupByLibrary.simpleMessage("Грати з ШІ"),
    "profile": MessageLookupByLibrary.simpleMessage("Профіль"),
    "profileExperience": m2,
    "profileId": m3,
    "profileLevel": m4,
    "profileNickname": m5,
    "profileRating": m6,
    "secondsRemaining": m7,
    "settings": MessageLookupByLibrary.simpleMessage("Налаштування"),
    "sound": MessageLookupByLibrary.simpleMessage("Звук"),
    "versus": MessageLookupByLibrary.simpleMessage("проти"),
    "vibration": MessageLookupByLibrary.simpleMessage("Вібрація"),
    "waitingForRival": MessageLookupByLibrary.simpleMessage(
      "Очікування суперника...",
    ),
    "winner": MessageLookupByLibrary.simpleMessage("Переможець:"),
    "youLost": MessageLookupByLibrary.simpleMessage("Ви програли!"),
    "youWon": MessageLookupByLibrary.simpleMessage("Ви перемогли!"),
    "yourTurn": MessageLookupByLibrary.simpleMessage("Ваш хід"),
  };
}
