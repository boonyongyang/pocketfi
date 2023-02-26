import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:pocketfi/src/common_widgets/animations/data_not_found_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/welcome_app_animation_view.dart';

/// Widget for the root/initial pages in the bottom navigation bar.
class RootScreen extends StatelessWidget {
  /// Creates a RootScreen
  const RootScreen({required this.label, required this.detailsPath, Key? key})
      : super(key: key);

  /// The label
  final String label;

  /// The path to the detail page
  final String detailsPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tab root - $label'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Screen $label',
                  style: Theme.of(context).textTheme.titleLarge),
              const Padding(padding: EdgeInsets.all(4)),
              TextButton(
                onPressed: () => Beamer.of(context).beamToNamed(detailsPath),
                child: const Text('View details'),
              ),
              const WelcomeAppAnimationView(),
              const EmptyContentsAnimationView(),
              const LoadingAnimationView(),
              const ErrorAnimationView(),
              const DataNotFoundAnimationView(),
            ],
          ),
        ),
      ),
    );
  }
}

/// The details screen for either the A or B screen.
class DetailsScreen extends StatefulWidget {
  // / Constructs a [DetailsScreen].
  const DetailsScreen({
    required this.label,
    Key? key,
  }) : super(key: key);

  /// The label to display in the center of the screen.
  final String label;

  @override
  State<StatefulWidget> createState() => DetailsScreenState();
}

/// The state for DetailsScreen
class DetailsScreenState extends State<DetailsScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('Details Screen - ${widget.label}'),
          leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Beamer.of(context).beamBack(),
      )),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Details for ${widget.label} - Counter: $_counter',
                style: Theme.of(context).textTheme.titleLarge),
            const Padding(
              padding: EdgeInsets.all(4),
            ),
            TextButton(
              onPressed: () => setState(() => _counter++),
              child: const Text('Increment counter'),
            ),
            const Padding(
              padding: EdgeInsets.all(4),
            ),
            TextButton(
              onPressed: () => setState(() => _counter--),
              child: const Text('Decrement counter'),
            ),
          ],
        ),
      ),
    );
  }
}
