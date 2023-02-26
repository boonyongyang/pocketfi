import 'package:pocketfi/src/common_widgets/animations/lottie_animation_view.dart';

import 'models/lottie_animation.dart';

class WelcomeAppAnimationView extends LottieAnimationView {
  const WelcomeAppAnimationView({super.key})
      : super(
          animation: LottieAnimation.welcomeApp,
        );
}
