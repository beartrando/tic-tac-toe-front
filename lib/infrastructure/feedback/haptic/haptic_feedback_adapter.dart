import 'package:flutter/services.dart';
import 'package:front/infrastructure/feedback/haptic/haptic_effect.dart';

class HapticFeedbackAdapter {
  const HapticFeedbackAdapter();

  Future<void> lightImpact() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {
      // Ignored if haptic feedback is not supported on the platform.
    }
  }

  Future<void> mediumImpact() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {
      // Ignored if haptic feedback is not supported on the platform.
    }
  }

  Future<void> heavyImpact() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {
      // Ignored if haptic feedback is not supported on the platform.
    }
  }

  Future<void> selectionClick() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {
      // Ignored if haptic feedback is not supported on the platform.
    }
  }

  Future<void> execute(HapticEffect effect) {
    return switch (effect) {
      HapticEffect.light => this.lightImpact(),
      HapticEffect.medium => this.mediumImpact(),
      HapticEffect.heavy => this.heavyImpact(),
      HapticEffect.selectionClick => this.selectionClick(),
    };
  }
}
