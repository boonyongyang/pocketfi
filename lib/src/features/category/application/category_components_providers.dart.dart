import 'package:flutter/material.dart' show Color, Colors, IconData, Icons;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/category/application/category_providers.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';

final selectedCategoryColorProvider = StateProvider<Color>((ref) {
  final categoryColor = ref.watch(selectedCategoryProvider).color;
  return categoryColor;
});

Color? getCategoryColor(Category category) {
  return category.color;
}

final categoryColorListProvider = Provider<List<Color>>(
  (ref) => colorList,
);

final selectedCategoryIconProvider = StateProvider<IconData?>(
  (ref) => null,
);

final categoryIconListProvider = Provider<List<IconData>>(
  (ref) => iconList,
);

resetCategoryComponentsState(WidgetRef ref) {
  ref.read(selectedCategoryColorProvider.notifier).state = Colors.grey;
  ref.read(selectedCategoryIconProvider.notifier).state = null;
}

// list of colors
const List<Color> colorList = [
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.pink,
  Colors.teal,
  Colors.cyan,
  Colors.lime,
  Colors.indigo,
  Colors.brown,
  Colors.amber,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.black,
];

// list of icons
const List<IconData> iconList = [
  Icons.attach_money,
  Icons.account_balance,
  Icons.account_balance_wallet,
  Icons.account_circle,
  Icons.add_shopping_cart,
  Icons.add_to_home_screen,
  Icons.add_to_photos,
  Icons.add_to_queue,
  Icons.airline_seat_flat,
  Icons.kayaking,
  Icons.local_atm,
  Icons.local_bar,
  Icons.local_cafe,
  Icons.local_car_wash,
  Icons.local_convenience_store,
  Icons.safety_check,
  Icons.sanitizer,
  Icons.satellite,
  Icons.qr_code_scanner,
  Icons.offline_bolt
];
