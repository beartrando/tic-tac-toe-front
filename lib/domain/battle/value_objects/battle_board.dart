import 'package:front/domain/battle/enums/battle_cell_value.enum.dart';

class BattleBoard {
  static const int size = 9;

  final List<BattleCellValueEnum> cells;

  BattleBoard(List<BattleCellValueEnum> cells)
      : assert(cells.isEmpty || cells.length == size),
        cells = List.unmodifiable(
          cells.isEmpty
              ? List.filled(size, BattleCellValueEnum.empty)
              : cells,
        );

  BattleCellValueEnum operator [](int index) => cells[index];

  int get filledCount =>
      cells.where((cell) => cell != BattleCellValueEnum.empty).length;

  bool validateIndex(int index) {
    return index >= 0 && index < size;
  }

  @override
  String toString() {
    return cells.join(', ');
  }
}
