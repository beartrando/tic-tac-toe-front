import 'package:front/domain/battle/entities/battle.dart';
import 'package:front/domain/battle/enums/battle_status.enum.dart';
import 'package:front/domain/battle/rules/can_move.dart';
import 'package:front/domain/battle/value_objects/battle_board.dart';
import 'package:front/domain/battle/value_objects/battle_id.dart';
import 'package:front/domain/battle/value_objects/battle_player_ids.dart';
import 'package:front/domain/battle/enums/battle_cell_value.enum.dart';
import 'package:front/domain/profile/value_objects/profile_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CanMove', () {
    late CanMove canMove;
    late ProfileId player1;
    late ProfileId player2;
    late ProfileId player3;
    late BattlePlayerIds twoPlayers;
    late BattlePlayerIds onePlayer;

    setUp(() {
      canMove = const CanMove();
      player1 = const ProfileId('player-1');
      player2 = const ProfileId('player-2');
      player3 = const ProfileId('player-3');
      twoPlayers = BattlePlayerIds([player1, player2]);
      onePlayer = BattlePlayerIds([player1]);
    });

    Battle createBattle({
      BattleStatusEnum status = BattleStatusEnum.started,
      BattlePlayerIds? playerIds,
      List<BattleCellValueEnum>? cells,
    }) {
      return Battle(
        id: const BattleId('battle-1'),
        board: BattleBoard(cells ?? List.filled(9, BattleCellValueEnum.empty)),
        playerIds: playerIds ?? twoPlayers,
        status: status,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    test('returns true when it is player\'s turn on started battle with 2 players', () {
      final battle = createBattle(cells: [
        BattleCellValueEnum.x, // player1 moved
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
      ]);

      expect(canMove.calculate(battle, player2), isTrue);
    });

    test('returns false when battle status is not started', () {
      final battle = createBattle(status: BattleStatusEnum.created);

      expect(canMove.calculate(battle, player1), isFalse);
    });

    test('returns false when battle is finished', () {
      final battle = createBattle(status: BattleStatusEnum.finished);

      expect(canMove.calculate(battle, player1), isFalse);
    });

    test('returns false when battle is cancelled', () {
      final battle = createBattle(status: BattleStatusEnum.cancelled);

      expect(canMove.calculate(battle, player1), isFalse);
    });

    test('returns false when less than 2 players', () {
      final battle = createBattle(playerIds: onePlayer);

      expect(canMove.calculate(battle, player1), isFalse);
    });

    test('returns false when it is not player\'s turn', () {
      final battle = createBattle(cells: [
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
      ]);

      // Empty board - player1's turn (filledCount = 0, index = 0)
      expect(canMove.calculate(battle, player2), isFalse);
    });

    test('returns false for non-participating player', () {
      final battle = createBattle(cells: [
        BattleCellValueEnum.x,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
      ]);

      expect(canMove.calculate(battle, player3), isFalse);
    });

    test('correctly alternates turns', () {
      // Player1 moves first (index 0)
      var battle = createBattle(cells: [
        BattleCellValueEnum.x,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
      ]);
      expect(canMove.calculate(battle, player1), isFalse);
      expect(canMove.calculate(battle, player2), isTrue);

      // Player2 moves (index 1)
      battle = createBattle(cells: [
        BattleCellValueEnum.x,
        BattleCellValueEnum.o,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
      ]);
      expect(canMove.calculate(battle, player2), isFalse);
      expect(canMove.calculate(battle, player1), isTrue);

      // Player1 moves again (index 2)
      battle = createBattle(cells: [
        BattleCellValueEnum.x,
        BattleCellValueEnum.o,
        BattleCellValueEnum.x,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
      ]);
      expect(canMove.calculate(battle, player1), isFalse);
      expect(canMove.calculate(battle, player2), isTrue);
    });
  });
}