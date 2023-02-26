import 'package:flutter/material.dart';
import 'package:pocketfi/state/category/models/category.dart';

class CategorySelectorView extends StatefulWidget {
  const CategorySelectorView({
    Key? key,
    required this.selectedCategory,
  }) : super(key: key);

  final Category? selectedCategory;

  @override
  CategorySelectorViewState createState() => CategorySelectorViewState();
}

class CategorySelectorViewState extends State<CategorySelectorView>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
    );

    if (widget.selectedCategory == null) {
      _fadeController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant CategorySelectorView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedCategory == null && oldWidget.selectedCategory != null) {
      _fadeController.forward();
    } else if (widget.selectedCategory != null &&
        oldWidget.selectedCategory == null) {
      _fadeController.reverse();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: child,
        );
      },
      child: widget.selectedCategory == null
          ? const SizedBox()
          : Row(
              children: [
                CircleAvatar(
                  backgroundColor: widget.selectedCategory!.color,
                  child: widget.selectedCategory!.icon,
                ),
                const SizedBox(width: 8.0),
                Text(widget.selectedCategory!.name),
              ],
            ),
    );
  }
}

// TODO: this is without animation
// class CategorySelector extends StatelessWidget {
//   const CategorySelector({
//     super.key,
//     required this.selectedCategory,
//   });

//   final Category? selectedCategory;

//   @override
//   Widget build(BuildContext context) {
//     if (selectedCategory == null) {
//       return const SizedBox();
//     } else {
//       return AnimatedOpacity(
//         duration: const Duration(milliseconds: 300),
//         opacity: selectedCategory == null ? 0.0 : 1.0,
//         child: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: selectedCategory!.color,
//               child: selectedCategory!.icon,
//             ),
//             const SizedBox(width: 8.0),
//             Text(selectedCategory!.name),
//           ],
//         ),
//       );
//     }
//   }
// }