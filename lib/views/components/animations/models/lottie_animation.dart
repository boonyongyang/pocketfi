enum LottieAnimation {
  dataNotFound(name: 'data_not_found'),
  empty(name: 'empty'),
  loading(name: 'loading'),
  loadingThumbnail(name: 'loading_thumbnail'),
  loadingImage(name: 'loading_image'),
  smallError(name: 'small_error'),
  error(name: 'error'),
  welcomeApp(name: 'welcome_app500');

  final String name;

  const LottieAnimation({required this.name});
}
