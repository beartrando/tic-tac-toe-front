import 'package:front/domain/battle/entities/battle.dart';
import 'package:front/domain/battle/enums/battle_status.enum.dart';
import 'package:front/domain/battle/rules/batle_finished.dart';
import 'package:front/domain/battle/value_objects/battle_board.dart';
import 'package:front/domain/battle/value_objects/battle_id.dart';
import 'package:front/domain/battle/value_objects/battle_player_ids.dart';
import 'package:front/domain/battle/enums/battle_cell_value.enum.dart';
import 'package:front/domain/profile/value_objects/profile_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BattleFinished', () {
    late BattleFinished battleFinished;
    late ProfileId player1;
    late ProfileId player2;
    late BattlePlayerIds twoPlayers;

    setUp(() {
      battleFinished = const BattleFinished();
      player1 = const ProfileId('player-1');
      player2 = const ProfileId('player-2');
      twoPlayers = BattlePlayerIds([player1, player2]);
    });

    Battle createBattle({
      BattleStatusEnum status = BattleStatusEnum.started,
    }) {
      return Battle(
        id: const BattleId('battle-1'),
        board: BattleBoard(List.filled(9, BattleCellValueEnum.empty)),
        playerIds: twoPlayers,
        status: status,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    test('returns true when battle is finished', () {
      final battle = createBattle(status: BattleStatusEnum.finished);

      expect(battleFinished.calculate(battle), isTrue);
    });

    test('returns true when battle is cancelled', () {
      final battle = createBattle(status: BattleStatusEnum.cancelled);

      expect(battleFinished.calculate(battle), isTrue);
    });

    test('returns false when battle is started', () {
      final battle = createBattle(status: BattleStatusEnum.started);

      expect(battleFinished.calculate(battle), isFalse);
    });

    test('returns false when battle is ready', () {
      final battle = createBattle(status: BattleStatusEnum.ready);

      expect(battleFinished.calculate(battle), isFalse);
    });

    test('returns false when battle is matched', () {
      final battle = createBattle(status: BattleStatusEnum.matched);

      expect(battleFinished.calculate(battle), isFalse);
    });

    test('returns false when battle is created', () {
      final battle = createBattle(status: BattleStatusEnum.created);

      expect(battleFinished.calculate(battle), isFalse);
    });

    test('returns false when battle status is unknown', () {
      final battle = createBattle(status: BattleStatusEnum.unknown);

      expect(battleFinished.calculate(battle), isFalse);
    });
  });
}
