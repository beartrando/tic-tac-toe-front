import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:front/src/clients/streaming_channel.dart';
import 'package:front/src/contracts/proto/engine.pb.dart' as battleProto;
import 'package:front/src/contracts/proto/common/ping.pb.dart';
import 'package:front/src/contracts/proto/streaming.pb.dart' as streamingProto;
import 'package:front/src/contracts/proto/streaming.pb.dart';
import 'package:front/src/helpers/protobuf_utils.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class BattleChannel extends StreamingChannel<battleProto.BattleObject> {
  late String profileId;
  final pathname = 'engine';

  messageHandler(List<int> message) {
    try {
      final resp = BattleResponse.fromBuffer(message);
      // logger.i(resp);
      if (resp.hasBattle()) {
        final battle = resp.battle;
        // logger.i('before engine added to controller');
        safeAdd(battle);
        // logger.i('engine added to controller');

        // logger.i('engine added to controller');
      } else {
        logger.e(resp);
        logger.e('Battle handling went wrong: $resp');
      }
    } catch (e) {
      logger.e('Failed to parse: $e');
    }
  }

  getWsUri() {
    return Uri.parse(
      'ws://${config.host}:${config.port}/$pathname?token=$jwt&profileId=${this.profileId}',
    );
  }

  BattleChannel(super.config, this.profileId, super.jwt);

  void move(String battleId, int cellIdx) {
    // logger.i('BattleMove event');
    final moveReq = BattleMove()
      ..cellIdx = cellIdx
      ..battleId = battleId;

    final req = BattleRequest()..move = moveReq;
    // logger.d(req);
    channel.sink.add(req.writeToBuffer());
    // logger.i('Sent profile: $profileId at $cellIdx');
  }

  void leave(String battleId) {
    final req = BattleRequest()..leave = (BattleLeave()..battleId = battleId);
    // logger.d(req);
    channel.sink.add(req.writeToBuffer());
    // logger.i('Sent profile: $profileId at $cellIdx');
  }

  connectAi(String battleId) {
    // logger.i('BattleMove event');
    final connectAiRequest = streamingProto.BattleJoinAi()..battleId = battleId;

    final req = BattleRequest()..connectAi = connectAiRequest;
    // logger.d(req);
    channel.sink.add(req.writeToBuffer());
    // logger.i('Sent profile: $profileId at $cellIdx');
  }

  start([String? battleId]) {
    final request = streamingProto.BattleStart();

    if (battleId != null) {
      request.battleId = battleId;
    }

    final req = BattleRequest()..start = request;
    channel.sink.add(req.writeToBuffer());

    // logger.i('Sent start engine: $battleId');
  }

  Future<void> ping() async {
    final req = BattleRequest()
      ..ping = (Ping()..timestamp = toTimestamp(DateTime.now()));
    channel.sink.add(req.writeToBuffer());
  }
}
