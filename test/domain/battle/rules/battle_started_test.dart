import 'package:front/domain/battle/entities/battle.dart';
import 'package:front/domain/battle/enums/battle_status.enum.dart';
import 'package:front/domain/battle/rules/batle_started.dart';
import 'package:front/domain/battle/value_objects/battle_board.dart';
import 'package:front/domain/battle/value_objects/battle_id.dart';
import 'package:front/domain/battle/value_objects/battle_player_ids.dart';
import 'package:front/domain/battle/enums/battle_cell_value.enum.dart';
import 'package:front/domain/profile/value_objects/profile_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BattleStarted', () {
    late BattleStarted battleStarted;
    late ProfileId player1;
    late ProfileId player2;
    late BattlePlayerIds twoPlayers;
    late BattlePlayerIds onePlayer;

    setUp(() {
      battleStarted = const BattleStarted();
      player1 = const ProfileId('player-1');
      player2 = const ProfileId('player-2');
      twoPlayers = BattlePlayerIds([player1, player2]);
      onePlayer = BattlePlayerIds([player1]);
    });

    Battle createBattle({
      BattleStatusEnum status = BattleStatusEnum.started,
      BattlePlayerIds? playerIds,
    }) {
      return Battle(
        id: const BattleId('battle-1'),
        board: BattleBoard(List.filled(9, BattleCellValueEnum.empty)),
        playerIds: playerIds ?? twoPlayers,
        status: status,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    test('returns true when battle is started with 2 players', () {
      final battle = createBattle();

      expect(battleStarted.calculate(battle), isTrue);
    });

    test('returns false when battle is created but not started', () {
      final battle = createBattle(status: BattleStatusEnum.created);

      expect(battleStarted.calculate(battle), isFalse);
    });

    test('returns false when battle is matched but not started', () {
      final battle = createBattle(status: BattleStatusEnum.matched);

      expect(battleStarted.calculate(battle), isFalse);
    });

    test('returns false when battle is ready but not started', () {
      final battle = createBattle(status: BattleStatusEnum.ready);

      expect(battleStarted.calculate(battle), isFalse);
    });

    test('returns false when battle is finished', () {
      final battle = createBattle(status: BattleStatusEnum.finished);

      expect(battleStarted.calculate(battle), isFalse);
    });

    test('returns false when battle is cancelled', () {
      final battle = createBattle(status: BattleStatusEnum.cancelled);

      expect(battleStarted.calculate(battle), isFalse);
    });

    test('returns false when battle has less than 2 players', () {
      final battle = createBattle(playerIds: onePlayer);

      expect(battleStarted.calculate(battle), isFalse);
    });
  });
}