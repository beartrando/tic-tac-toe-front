import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/domain/battle/entities/battle.dart';
import 'package:front/domain/battle/enums/battle_cell_value.enum.dart';
import 'package:front/domain/battle/rules/batle_finished.dart';
import 'package:front/domain/battle/rules/batle_started.dart';
import 'package:front/domain/battle/rules/can_move.dart';
import 'package:front/domain/battle/value_objects/battle_board.dart';
import 'package:front/domain/profile/entities/profile.dart';
import 'package:front/features/battle/infrastructure/websocket/battle_service.dart';
import 'package:front/features/battle/ui/widgets/turn_timer.dart';
import 'package:front/features/profile/ui/widgets/player_name.dart';
import 'package:front/infrastructure/app/app_config_provider.dart';
import 'package:front/infrastructure/feedback/event_feedback_service_provider.dart';
import 'package:front/infrastructure/feedback/events/move_event.dart';
import 'package:front/infrastructure/feedback/events/reject_move_event.dart';
import 'package:front/infrastructure/localization/generated/l10n.dart';

class BattleBoardWideget extends ConsumerWidget {
  final Battle battle;
  final BattleService battleService;

  // final ProfileService profileService;
  final Profile profile;

  // final WidgetRef ref;

  const BattleBoardWideget({
    super.key,
    required this.profile,
    required this.battle,
    required this.battleService,
    // required this.profileService,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final feedbackService = ref.read(eventFeedbackServiceProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < battle.playerIds.length; i++) ...[
              PlayerName(profileId: battle.playerIds.value[i]),
              if (i < battle.playerIds.length - 1)
                Text(' ${S.of(context).versus} '),
            ],
          ],
        ),
        (BattleFinished().calculate(battle)
            ? (battle.winnerId != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${S.of(context).winner} '),
                        PlayerName(profileId: battle.winnerId!),
                      ],
                    )
                  : Text(S.of(context).battleCancelled))
            : (BattleStarted().calculate(battle)
                  ? (CanMove().calculate(battle, profile.id)
                        ? TurnTimer(
                            key: const ValueKey('your-turn'),
                            text: Text(S.of(context).yourTurn),
                            seconds: config.moveTimeout,
                            battleService: battleService,
                            battleId: battle.id,
                          )
                        : TurnTimer(
                            key: const ValueKey('not-your-turn'),
                            text: Text(S.of(context).notYourTurn),
                            seconds: config.moveTimeout,
                            battleService: battleService,
                          ))
                  : Text(S.of(context).battleReadyWait))),

        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              // debugPrint("Cells raw: ${battle.board}");
              final cellValue = safeCellAt(battle.board, index);
              return GestureDetector(
                onTap: () {
                  if (CanMove().calculate(battle, profile.id)) {
                    battleService.makeMove(battle, index);
                    feedbackService.execute(const MoveEvent());
                  } else {
                    feedbackService.execute(const RejectMoveEvent());
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

  BattleCellValueEnum safeCellAt(BattleBoard board, int index) {
    if (board.validateIndex(index)) {
      return board[index];
    }
    return BattleCellValueEnum.empty;
  }

  String _renderCell(BattleCellValueEnum value) {
    switch (value) {
      case BattleCellValueEnum.x:
        return 'X';
      case BattleCellValueEnum.o:
        return 'O';
      case BattleCellValueEnum.empty:
      // ignore: unreachable_switch_default
      default:
        return '';
    }
  }

  Color _cellColor(BattleCellValueEnum value) {
    switch (value) {
      case BattleCellValueEnum.x:
        return Colors.red; // X красный
      case BattleCellValueEnum.o:
        return Colors.blue; // O синий
      case BattleCellValueEnum.empty:
      // ignore: unreachable_switch_default
      default:
        return Colors.white; // пустая клетка белая
    }
  }
}
