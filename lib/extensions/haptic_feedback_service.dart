import 'dart:io';
import 'package:flutter/services.dart';

class HapticFeedbackService {
  static void lightImpact() {
    Platform.isIOS ? HapticFeedback.lightImpact() : HapticFeedback.vibrate();
  }

  static void mediumImpact() {
    Platform.isIOS ? HapticFeedback.mediumImpact() : HapticFeedback.vibrate();
  }

  static void heavyImpact() {
    Platform.isIOS ? HapticFeedback.heavyImpact() : HapticFeedback.vibrate();
  }

// todo idk what this does actually
  static void selectionClick() {
    Platform.isIOS ? HapticFeedback.selectionClick() : HapticFeedback.vibrate();
  }

// todo what about this?
  // SystemSound.play(SystemSoundType.click);
}
