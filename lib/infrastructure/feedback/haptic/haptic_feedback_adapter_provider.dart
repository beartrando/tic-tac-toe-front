import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/infrastructure/feedback/haptic/haptic_feedback_adapter.dart';

final hapticFeedbackAdapterProvider = Provider<HapticFeedbackAdapter>((ref) {
  return const HapticFeedbackAdapter();
});
