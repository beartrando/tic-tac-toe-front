import 'package:front/infrastructure/feedback/events/feedback_event.dart';
import 'package:front/infrastructure/feedback/resolver/feedback_action_resolver.dart';

class EventFeedbackService {
  final FeedbackActionResolver _resolver;

  const EventFeedbackService({
    required FeedbackActionResolver resolver,
  }) : _resolver = resolver;

  Future<void> execute(FeedbackEvent event) {
    return _resolver.resolve(event).execute();
  }
}

