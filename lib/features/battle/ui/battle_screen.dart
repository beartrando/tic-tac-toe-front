import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/domain/battle/entities/battle.dart';
import 'package:front/domain/battle/enums/battle_status.enum.dart';
import 'package:front/features/battle/infrastructure/websocket/battle_channel_provider.dart';
import 'package:front/features/battle/infrastructure/websocket/battle_service.dart';
import 'package:front/features/battle/infrastructure/websocket/battle_stream_provider.dart';
import 'package:front/features/battle/providers/battle_stream_provider.dart';
import 'package:front/features/battle/ui/widgets/battle_content.dart';
import 'package:front/features/profile/providers/my_profile_provider.dart';
import 'package:front/infrastructure/audio/app_music_controller_provider.dart';
import 'package:front/infrastructure/localization/generated/l10n.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class BattleScreen extends ConsumerStatefulWidget {
  const BattleScreen({super.key});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  late BattleService battleService;
  Battle? _battle;

  @override
  void initState() {
    super.initState();
    ref.read(musicControllerProvider).play();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(myProfileProvider);

    return profileAsync.when(
      data: (profile) {
        final battleServiceAsync = ref.watch(battleServiceProvider);
        return battleServiceAsync.when(
          data: (service) {
            battleService = service;

            final battleChannel = ref.watch(battleChannelProvider).valueOrNull;

            if (battleChannel != null) {
              battleChannel.onConnectionLost ??= () {
                if (!mounted) {
                  return;
                }

                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.of(context).connectionLost)),
                );
              };
            }

            final battleAsync = ref.watch(battleStreamProvider);

            return battleAsync.when(
              data: (battle) {
                debugPrint(battle.toString());
                _battle = battle;
                if (battle.status == BattleStatusEnum.ready) {
                  battleService.start(battle.id);
                }
                return BattleContent(
                  battle: battle,
                  profile: profile,
                  battleService: battleService,
                );
              },
              loading: () {
                debugPrint("Battle stream loading...");
                return const Center(child: CircularProgressIndicator());
              },
              error: (err, stack) {
                debugPrint("Battle stream error: $err\n$stack");
                return Center(child: Text(S.of(context).error(err)));
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text(S.of(context).error(e)),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text(S.of(context).error(e)),
    );
  }

  @override
  void dispose() {
    debugPrint("BattleScreen dispose");

    ref.read(musicControllerProvider).stop();

    final battle = _battle;
    if (battle != null) {
      battleService.leave(battle.id);
    }

    super.dispose();
  }
}
