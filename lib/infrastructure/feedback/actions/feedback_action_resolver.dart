class FeedbackActionResolver {
  final Map<Type, FeedbackAction Function()> _actions;

  const FeedbackActionResolver(this._actions);

  FeedbackAction resolve(FeedbackEvent event) {
    final factory = _actions[event.runtimeType];

    if (factory == null) {
      throw StateError(
        'No FeedbackAction registered for ${event.runtimeType}',
      );
    }

    return factory();
  }
}
