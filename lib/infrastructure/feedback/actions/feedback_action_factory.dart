import 'package:front/infrastructure/feedback/actions/feedback_action.dart';
import 'package:front/infrastructure/feedback/events/feedback_event.dart';

class FeedbackActionFactory {
  final Map<Type, FeedbackAction Function()> _factories;

  const FeedbackActionFactory({
    required Map<Type, FeedbackAction Function()> factories,
  }) : _factories = factories;

  FeedbackAction create(FeedbackEvent event) {
    final factory = _factories[event.runtimeType];

    if (factory == null) {
      throw StateError('No FeedbackAction registered for ${event.runtimeType}');
    }

    return factory();
  }
}
