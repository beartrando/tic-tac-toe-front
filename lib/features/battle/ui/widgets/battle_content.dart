import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/domain/battle/entities/battle.dart';
import 'package:front/domain/battle/enums/battle_status.enum.dart';
import 'package:front/features/battle/infrastructure/websocket/battle_service.dart';
import 'package:front/features/battle/ui/widgets/battle_board_widget.dart';
import 'package:front/infrastructure/feedback/event_feedback_service_provider.dart';
import 'package:front/infrastructure/feedback/events/lose_event.dart';
import 'package:front/infrastructure/feedback/events/win_event.dart';
import 'package:front/infrastructure/localization/generated/l10n.dart';

class BattleContent extends ConsumerStatefulWidget {
  final Battle battle;
  final dynamic profile;
  final BattleService battleService;

  const BattleContent({
    super.key,
    required this.battle,
    required this.profile,
    required this.battleService,
  });

  @override
  ConsumerState<BattleContent> createState() => _BattleContentState();
}

class _BattleContentState extends ConsumerState<BattleContent> {
  static const _aiConnectionDelay = Duration(seconds: 5);

  Timer? _aiConnectionTimer;
  int _secondsUntilAi = _aiConnectionDelay.inSeconds;
  bool _isBotConnectionRequested = false;

  bool get _hasRival => widget.battle.hasRival();

  bool get _isAiConnectionScheduled => _aiConnectionTimer != null;

  @override
  void initState() {
    super.initState();
    _startAiConnectionTimer();
  }

  @override
  Widget build(BuildContext context) {
    final battle = widget.battle;

    if (battle.isFinished()) {
      _showMatchFinishedDialog(context, battle);
    }

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).battleTitle)),
      body: _hasRival
          ? _buildBattleBoard(context, battle)
          : _WaitingForRival(
              secondsUntilAi: _secondsUntilAi,
              aiConnectionScheduled: _isAiConnectionScheduled,
              isBotConnectionRequested: _isBotConnectionRequested,
              onConnectBot: _connectBot,
              onCancelAiConnection: _cancelAiConnectionTimer,
            ),
    );
  }

  void _showMatchFinishedDialog(BuildContext context, Battle battle) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerFinishFeedback(battle);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text(S.of(context).matchFinished),
          content: _matchResult(battle),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.battleService.channel.init();
              },
              child: Text(S.of(context).playAgain),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: Text(S.of(context).backToMenu),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).close),
            ),
          ],
        ),
      );
    });
  }

  void _triggerFinishFeedback(Battle battle) {
    final feedbackService = ref.read(eventFeedbackServiceProvider);
    final isWin = battle.winnerId == widget.profile.id;
    feedbackService.execute(isWin ? const WinEvent() : const LoseEvent());
  }

  @override
  void didUpdateWidget(covariant BattleContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_hasRival) {
      _cancelAiConnectionTimer();
      return;
    }

    if (_shouldRestartAiTimer(oldWidget)) {
      _restartAiConnectionTimer();
    }
  }

  bool _shouldRestartAiTimer(BattleContent oldWidget) {
    final wasFinished = oldWidget.battle.isFinished();
    final isNewBattle = oldWidget.battle.id != widget.battle.id;
    return (wasFinished || isNewBattle) && !_isAiConnectionScheduled;
  }

  @override
  void dispose() {
    _clearAiConnectionTimer();
    super.dispose();
  }

  void _startAiConnectionTimer() {
    if (_hasRival || _aiConnectionTimer != null) {
      return;
    }

    _aiConnectionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _hasRival) {
        _clearAiConnectionTimer();
        return;
      }

      if (_secondsUntilAi <= 1) {
        timer.cancel();
        _connectBot();
        return;
      }

      setState(() => _secondsUntilAi--);
    });
  }

  void _restartAiConnectionTimer() {
    setState(() {
      _secondsUntilAi = _aiConnectionDelay.inSeconds;
      _isBotConnectionRequested = false;
    });
    _startAiConnectionTimer();
  }

  void _cancelAiConnectionTimer() {
    _clearAiConnectionTimer();
    if (mounted) {
      setState(() {});
    }
  }

  void _clearAiConnectionTimer() {
    _aiConnectionTimer?.cancel();
    _aiConnectionTimer = null;
  }

  void _connectBot() {
    _clearAiConnectionTimer();
    setState(() => _isBotConnectionRequested = true);
    widget.battleService.connectBot(widget.battle.id);
  }

  Widget _buildBattleBoard(BuildContext context, Battle battle) {
    try {
      return BattleBoardWideget(
        battle: battle,
        profile: widget.profile,
        battleService: widget.battleService,
      );
    } catch (error, stackTrace) {
      debugPrint('UI error: $error\n$stackTrace');
      return Text(S.of(context).error(error));
    }
  }

  Widget _matchResult(Battle battle) {
    if (battle.winnerId == null) {
      return Text(
        battle.status == BattleStatusEnum.cancelled
            ? S.of(context).cancelled
            : S.of(context).draw,
      );
    }

    return Text(
      widget.profile.id == battle.winnerId
          ? S.of(context).youWon
          : S.of(context).youLost,
    );
  }
}

class _WaitingForRival extends StatelessWidget {
  final int secondsUntilAi;
  final bool aiConnectionScheduled;
  final bool isBotConnectionRequested;
  final VoidCallback onConnectBot;
  final VoidCallback onCancelAiConnection;

  const _WaitingForRival({
    required this.secondsUntilAi,
    required this.aiConnectionScheduled,
    required this.isBotConnectionRequested,
    required this.onConnectBot,
    required this.onCancelAiConnection,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(strings.waitingForRival),
          if (aiConnectionScheduled) ...[
            const SizedBox(height: 8),
            Text(strings.aiWillConnectIn(secondsUntilAi)),
          ],
          const SizedBox(height: 24),
          if (!isBotConnectionRequested) ...[
            ElevatedButton(
              onPressed: onConnectBot,
              child: Text(
                aiConnectionScheduled
                    ? strings.connectAiNow
                    : strings.playWithAi,
              ),
            ),
            if (aiConnectionScheduled) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onCancelAiConnection,
                child: Text(strings.cancelAiConnection),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
