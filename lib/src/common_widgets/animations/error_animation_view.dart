import 'package:pocketfi/src/common_widgets/animations/lottie_animation_view.dart';

import 'models/lottie_animation.dart';

class ErrorAnimationView extends LottieAnimationView {
  const ErrorAnimationView({super.key})
      : super(
          animation: LottieAnimation.error,
        );
}
