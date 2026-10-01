import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front/infrastructure/feedback/event_feedback_service.dart';
import 'package:front/infrastructure/feedback/resolver/feedback_action_resolver.dart';

final eventFeedbackServiceProvider = Provider<EventFeedbackService>((ref) {
  return EventFeedbackService(
    resolver: ref.read(feedbackActionResolverProvider),
  );
});
