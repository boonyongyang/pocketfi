import 'package:pocketfi/src/common_widgets/animations/lottie_animation_view.dart';

import 'models/lottie_animation.dart';

class SmallErrorAnimationView extends LottieAnimationView {
  const SmallErrorAnimationView({super.key})
      : super(
          animation: LottieAnimation.smallError,
        );
}
