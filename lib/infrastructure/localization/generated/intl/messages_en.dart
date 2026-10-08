// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(seconds) => "AI will connect in ${seconds} s";

  static String m1(error) =>
      "An error occurred. Restart the app and try again.";

  static String m2(experience) => "Experience: ${experience}";

  static String m3(id) => "ID: ${id}";

  static String m4(level) => "Level: ${level}";

  static String m5(nickname) => "Nickname: ${nickname}";

  static String m6(rating) => "Rating: ${rating}";

  static String m7(seconds) => "(${seconds} s)";

  final messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aiWillConnectIn": m0,
    "appTitle": MessageLookupByLibrary.simpleMessage("Tic Tac Toe"),
    "backToMenu": MessageLookupByLibrary.simpleMessage("Back to menu"),
    "battleCancelled": MessageLookupByLibrary.simpleMessage("Battle cancelled"),
    "battleReadyWait": MessageLookupByLibrary.simpleMessage(
      "Battle ready, wait a sec.",
    ),
    "battleTitle": MessageLookupByLibrary.simpleMessage("Battle: Tic Tac Toe"),
    "cancelAiConnection": MessageLookupByLibrary.simpleMessage(
      "Cancel AI connection",
    ),
    "cancelled": MessageLookupByLibrary.simpleMessage("Cancelled"),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "connectAiNow": MessageLookupByLibrary.simpleMessage("Connect AI now"),
    "connectionLost": MessageLookupByLibrary.simpleMessage(
      "Connection to the server was lost",
    ),
    "draw": MessageLookupByLibrary.simpleMessage("Draw"),
    "effects": MessageLookupByLibrary.simpleMessage("Effects"),
    "error": m1,
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "localeLoadingError": MessageLookupByLibrary.simpleMessage(
      "Failed to load locale. Please try again later.",
    ),
    "matchFinished": MessageLookupByLibrary.simpleMessage("Match finished"),
    "notYourTurn": MessageLookupByLibrary.simpleMessage("Not your turn"),
    "play": MessageLookupByLibrary.simpleMessage("Play"),
    "playAgain": MessageLookupByLibrary.simpleMessage("Play again"),
    "playWithAi": MessageLookupByLibrary.simpleMessage("Play with AI"),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "profileExperience": m2,
    "profileId": m3,
    "profileLevel": m4,
    "profileNickname": m5,
    "profileRating": m6,
    "secondsRemaining": m7,
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "sound": MessageLookupByLibrary.simpleMessage("Sound"),
    "versus": MessageLookupByLibrary.simpleMessage("vs"),
    "vibration": MessageLookupByLibrary.simpleMessage("Vibration"),
    "waitingForRival": MessageLookupByLibrary.simpleMessage(
      "Waiting for rival...",
    ),
    "winner": MessageLookupByLibrary.simpleMessage("Winner:"),
    "youLost": MessageLookupByLibrary.simpleMessage("You lost!"),
    "youWon": MessageLookupByLibrary.simpleMessage("You won!"),
    "yourTurn": MessageLookupByLibrary.simpleMessage("Your turn"),
  };
}
