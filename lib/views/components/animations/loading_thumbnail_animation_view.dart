import 'package:pocketfi/views/components/animations/lottie_animation_view.dart';

import 'models/lottie_animation.dart';

class LoadingThumbnailAnimationView extends LottieAnimationView {
  const LoadingThumbnailAnimationView({super.key})
      : super(
          animation: LottieAnimation.loadingThumbnail,
        );
}
