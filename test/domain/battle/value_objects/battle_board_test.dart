import 'package:front/domain/battle/value_objects/battle_board.dart';
import 'package:front/domain/battle/enums/battle_cell_value.enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BattleBoard', () {
    test('creates board with 9 empty cells by default', () {
      final board = BattleBoard(List.filled(9, BattleCellValueEnum.empty));

      expect(board.cells.length, 9);
      expect(board.cells.every((c) => c == BattleCellValueEnum.empty), isTrue);
    });

    test('operator[] returns cell at index', () {
      final cells = [
        BattleCellValueEnum.x,
        BattleCellValueEnum.o,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
      ];
      final board = BattleBoard(cells);

      expect(board[0], BattleCellValueEnum.x);
      expect(board[1], BattleCellValueEnum.o);
      expect(board[2], BattleCellValueEnum.empty);
    });

    test('filledCount returns number of non-empty cells', () {
      final cells = [
        BattleCellValueEnum.x,
        BattleCellValueEnum.o,
        BattleCellValueEnum.x,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
        BattleCellValueEnum.empty,
      ];
      final board = BattleBoard(cells);

      expect(board.filledCount, 3);
    });

    test('filledCount is 0 for empty board', () {
      final board = BattleBoard(List.filled(9, BattleCellValueEnum.empty));

      expect(board.filledCount, 0);
    });

    test('filledCount is 9 for full board', () {
      final cells = List.generate(
        9,
        (i) => i % 2 == 0 ? BattleCellValueEnum.x : BattleCellValueEnum.o,
      );
      final board = BattleBoard(cells);

      expect(board.filledCount, 9);
    });

    test('validateIndex returns true for valid indices', () {
      final board = BattleBoard(List.filled(9, BattleCellValueEnum.empty));

      expect(board.validateIndex(0), isTrue);
      expect(board.validateIndex(4), isTrue);
      expect(board.validateIndex(8), isTrue);
    });

    test('validateIndex returns false for invalid indices', () {
      final board = BattleBoard(List.filled(9, BattleCellValueEnum.empty));

      expect(board.validateIndex(-1), isFalse);
      expect(board.validateIndex(9), isFalse);
      expect(board.validateIndex(10), isFalse);
    });

    test('cells list is unmodifiable', () {
      final cells = List.filled(9, BattleCellValueEnum.empty);
      final board = BattleBoard(cells);

      expect(
        () => board.cells[0] = BattleCellValueEnum.x,
        throwsUnsupportedError,
      );
    });

    test('toString returns comma-separated cells', () {
      final cells = [
        BattleCellValueEnum.x,
        BattleCellValueEnum.o,
        BattleCellValueEnum.empty,
      ];
      final board = BattleBoard([
        ...cells,
        ...List.filled(6, BattleCellValueEnum.empty),
      ]);

      expect(board.toString(), contains('x'));
      expect(board.toString(), contains('o'));
      expect(board.toString(), contains('empty'));
    });
  });
}
