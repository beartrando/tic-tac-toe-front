import 'dart:async';

import 'package:front/contracts/proto/common/ping.pb.dart';
import 'package:front/contracts/proto/streaming.pb.dart' as streaming_proto;
import 'package:front/contracts/proto/streaming.pb.dart';
import 'package:front/domain/battle/entities/battle.dart';
import 'package:front/domain/battle/value_objects/battle_id.dart';
import 'package:front/domain/profile/value_objects/profile_id.dart';
import 'package:front/infrastructure/proto/converters/streaming/battle_response_converter.dart';
import 'package:front/infrastructure/proto/converters/timestamp_converter.dart';
import 'package:front/infrastructure/websocket/websocket_connection.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class BattleChannel extends WebsocketConnection<Battle> {
  late ProfileId profileId;

  @override
  String get pathname => 'battle';

  @override
  messageHandler(List<int> message) {
    try {
      final battle = BattleResponseConverter.fromProto(
        streaming_proto.BattleResponse.fromBuffer(message),
      );
      // logger.i('before battle added to controller');
      safeAdd(battle);
      // logger.i('battle added to controller');

      // logger.i('battle added to controller');
    } catch (e) {
      logger.e('Failed to parse: $e');
    }
  }

  @override
  getWsUri() {
    print('getWsUri');

    print('WebSocket port: ${config.origin}');

    return Uri.parse(
      '${config.origin}/$pathname?token=${accessToken.value}&profileId=${profileId.value}',
    );
  }

  BattleChannel(super.config, this.profileId, super.accessToken);

  void move(BattleId battleId, int cellIdx) {
    // logger.i('Move event');
    final moveReq = BattleMove()
      ..cellIdx = cellIdx
      ..battleId = battleId.value;

    final req = BattleRequest()..move = moveReq;
    // logger.d(req);
    channel.sink.add(req.writeToBuffer());
    // logger.i('Sent profile: $profileId at $cellIdx');
  }

  void leave(BattleId battleId) {
    final req = BattleRequest()
      ..leave = (BattleLeave()..battleId = battleId.value);
    // logger.d(req);
    channel.sink.add(req.writeToBuffer());
    // logger.i('Sent profile: $profileId at $cellIdx');
  }

  void connectBot(BattleId battleId) {
    // logger.i(battleId.value);
    final connectBotRequest = streaming_proto.BattleJoinBot()
      ..battleId = battleId.value;

    final req = BattleRequest()..connectBot = connectBotRequest;
    // logger.d(req);
    channel.sink.add(req.writeToBuffer());
    // logger.i('Sent profile: $profileId at $cellIdx');
  }

  void init([BattleId? battleId]) {
    final request = streaming_proto.BattleInit();

    if (battleId != null) {
      request.battleId = battleId.value;
    }

    final req = BattleRequest()..init = request;

    channel.sink.add(req.writeToBuffer());

    // logger.i('Sent start battle: $battleId');
  }

  void start([BattleId? battleId]) {
    final request = streaming_proto.BattleStart();

    if (battleId != null) {
      request.battleId = battleId.value;
    }

    final req = BattleRequest()..start = request;
    channel.sink.add(req.writeToBuffer());

    // logger.i('Sent start battle: $battleId');
  }

  @override
  Future<void> ping() async {
    final req = BattleRequest()
      ..ping = (Ping()..timestamp = TimestampConverter().to(DateTime.now()));
    channel.sink.add(req.writeToBuffer());
  }
}
