import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/features/battle/services/battle_service.dart';
import 'package:front/features/profile/widgets/player_name.dart';
import 'package:front/src/contracts/proto/engine.pb.dart';
import 'package:front/src/contracts/proto/profile.pb.dart';
import 'package:front/src/providers/app_config_provider.dart';
import 'package:front/widgets/turn_timer.dart';

class Board extends ConsumerWidget {
  final BattleObject battle;
  final BattleService battleService;

  // final ProfileService profileService;
  final ProfileObject profile;

  // final WidgetRef ref;

  const Board({
    required this.profile,
    required this.battle,
    required this.battleService,
    // required this.profileService,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appConfig = ref.watch(appConfigProvider);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < battle.playerIds.length; i++) ...[
              PlayerName(profileId: battle.playerIds[i]),
              if (i < battle.playerIds.length - 1) const Text(' vs '),
            ],
          ],
        ),
        battle.winnerId.isNotEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Winner: '),
                  PlayerName(profileId: battle.winnerId),
                ],
              )
            : (battleService.canMove(battle)
                  ? TurnTimer(
                      seconds: config.moveTimeout,
                      battleService: battleService,
                      battleId: battle.id,
                    )
                  : const Text('Not your turn')),

        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              debugPrint("Cells raw: ${battle.cells}");
              final cellValue = safeCellAt(battle.cells, index);
              return GestureDetector(
                onTap: () {
                  if (battleService.canMove(battle)) {
                    battleService.makeMove(battle, index);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white), // белая рамка
                    color: Colors.grey[900],
                  ),
                  child: Center(
                    child: Text(
                      _renderCell(cellValue),
                      style: TextStyle(
                        fontSize: 32,
                        color: _cellColor(
                          cellValue,
                        ), // цвет зависит от значения
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  BattleCellValue safeCellAt(List<BattleCellValue> cells, int index) {
    if (index >= 0 && index < cells.length) {
      return cells[index];
    }
    return BattleCellValue.CELL_EMPTY;
  }

  String _renderCell(BattleCellValue value) {
    switch (value) {
      case BattleCellValue.CELL_X:
        return 'X';
      case BattleCellValue.CELL_O:
        return 'O';
      case BattleCellValue.CELL_EMPTY:
      default:
        return '';
    }
  }

  Color _cellColor(BattleCellValue value) {
    switch (value) {
      case BattleCellValue.CELL_X:
        return Colors.red; // X красный
      case BattleCellValue.CELL_O:
        return Colors.blue; // O синий
      case BattleCellValue.CELL_EMPTY:
      default:
        return Colors.white; // пустая клетка белая
    }
  }
}
