import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/features/battle/widgets/battle_content.dart';
import 'package:front/features/profile/providers/my_profile_provider.dart';
import 'package:front/src/contracts/proto/engine.pb.dart';
import 'package:front/src/params/client_params.dart';
import 'package:front/src/providers/jwt_provider.dart';

import '../../battle/params/battle_params.dart';
import '../../battle/providers/battle_service_provider.dart';
import '../../battle/providers/battle_stream_provider.dart';
import '../../battle/services/battle_service.dart';

class BattleScreen extends ConsumerStatefulWidget {
  const BattleScreen({super.key});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  late BattleService battleService;
  late BattleObject? _battle;

  @override
  Widget build(BuildContext context) {
    final jwtAsync = ref.watch(jwtProvider);

    return jwtAsync.when(
      data: (jwt) {
        final ClientParams clientParams = ClientParams(jwt);
        final profileAsync = ref.watch(myProfileProvider(clientParams));
        return profileAsync.when(
          data: (profile) {
            final battleParams = BattleParams(clientParams, profile.id);
            final battleServiceAsync = ref.watch(
              battleServiceProvider(battleParams),
            );
            return battleServiceAsync.when(
              data: (service) {
                battleService = service;
                final battleAsync = ref.watch(
                  battleStreamProvider(battleParams),
                );

                return battleAsync.when(
                  data: (battle) {
                    _battle = battle;
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
                    return Center(child: Text('Ошибка: $err'));
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text("Profile error: $e"),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text("Profile error: $e"),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text("AuthObject error: $e"),
    );
  }

  @override
  void dispose() {
    debugPrint("BattleScreen dispose");
    final battle = _battle;
    if (battle != null) {
      battleService.leave(battleId: battle.id);
    }
    super.dispose();
  }
}
