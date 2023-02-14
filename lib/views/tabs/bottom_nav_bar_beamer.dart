import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:pocketfi/views/components/animations/data_not_found_animation_view.dart';
import 'package:pocketfi/views/components/animations/empty_contents_animation_view.dart';
import 'package:pocketfi/views/components/animations/error_animation_view.dart';
import 'package:pocketfi/views/components/animations/loading_animation_view.dart';
import 'package:pocketfi/views/components/animations/welcome_app_animation_view.dart';
import 'package:pocketfi/views/constants/app_colors.dart';
import 'package:pocketfi/views/tabs/account/account_page.dart';
import 'package:pocketfi/views/tabs/account/setting_page.dart';
import 'package:pocketfi/views/tabs/timeline/timeline_page.dart';
import 'package:pocketfi/views/tabs/timeline/transactions/add_new_transactions/add_new_transaction.dart';

class BottomNavBarBeamer extends StatelessWidget {
  const BottomNavBarBeamer({super.key});

  static final routerDelegate = BeamerDelegate(
    initialPath: '/timeline',
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '*': (context, state, data) => const ScaffoldWithBottomNavBar(),
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppSwatches.mainMaterialColor1,
      ),
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(
        delegate: routerDelegate,
        fallbackToBeamBack: false,
      ),
    );
  }
}

/// Location defining the pages for the first tab
class TabA extends BeamLocation<BeamState> {
  TabA(super.routeInformation);
  @override
  List<String> get pathPatterns => ['/*'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('timeline'),
          title: 'Timeline',
          type: BeamPageType.noTransition,
          // child: RootScreen(label: 'Timeline', detailsPath: '/timeline/details'),
          child: TimelinePage(),
        ),
        if (state.uri.pathSegments.length == 2)
          const BeamPage(
            type: BeamPageType.slideTransition,
            key: ValueKey('timeline/addnewexpense'),
            title: 'Timeline Details',
            child: AddTransactionPage(),
          ),
        // if (state.)
        //   const BeamPage(
        //     type: BeamPageType.slideTransition,
        //     key: ValueKey('timeline/overview'),
        //     title: 'Overview Details',
        //     child: RootScreen(
        //         label: 'Overview',
        //         detailsPath: '/timeline/addnewexpense/selectcategory'),
        //   ),
        if (state.uri.pathSegments.length == 3)
          const BeamPage(
            // fullScreenDialog: true,
            type: BeamPageType.fadeTransition,
            key: ValueKey('timeline/addnewexpense/selectcategory'),
            title: 'Select Category',
            child: DetailsScreen(label: 'Select Category'),
          ),
      ];
}

/// Location defining the pages for the second tab
class TabB extends BeamLocation<BeamState> {
  TabB(super.routeInformation);
  @override
  List<String> get pathPatterns => ['/*'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('b'),
          title: 'Tab B',
          type: BeamPageType.noTransition,
          child: RootScreen(label: 'B', detailsPath: '/b/details'),
          // child: BudgetPage(),
        ),
        if (state.uri.pathSegments.length == 2)
          const BeamPage(
            key: ValueKey('b/details'),
            title: 'Details B',
            child: DetailsScreen(label: 'B'),
          ),
      ];
}

/// Location defining the pages for the third tab
class TabC extends BeamLocation<BeamState> {
  TabC(super.routeInformation);
  @override
  List<String> get pathPatterns => ['/*'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('c'),
          title: 'Tab C',
          type: BeamPageType.noTransition,
          child: RootScreen(label: 'C', detailsPath: '/c/details'),
          // child: FinancesPage(),
        ),
        if (state.uri.pathSegments.length == 2)
          const BeamPage(
            key: ValueKey('c/details'),
            title: 'Details C',
            child: DetailsScreen(label: 'C'),
          ),
      ];
}

/// Location defining the pages for the fourth tab
class TabD extends BeamLocation<BeamState> {
  TabD(super.routeInformation);
  @override
  List<String> get pathPatterns => ['/*'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('account'),
          title: 'Account',
          type: BeamPageType.noTransition,
          // child: RootScreen(label: 'Account', detailsPath: '/account/details'),
          child: AccountPage(),
        ),
        if (state.uri.pathSegments.length == 2)
          const BeamPage(
            key: ValueKey('account/settings'),
            title: 'Account settings',
            child: SettingsPage(),
            // child: DetailsScreen(label: 'Account Details'),
          ),
      ];
}

/// A widget class that shows the BottomNavigationBar and
/// performs navigation between tabs
class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar({super.key});

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  late int _currentIndex;

  final _routerDelegates = [
    BeamerDelegate(
      initialPath: '/timeline',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('/timeline')) {
          return TabA(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
    BeamerDelegate(
      initialPath: '/b',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('/b')) {
          return TabB(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
    BeamerDelegate(
      initialPath: '/c',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('/c')) {
          return TabC(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
    BeamerDelegate(
      initialPath: '/account',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('/account')) {
          return TabD(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uriString = Beamer.of(context).configuration.location!;
    // _currentIndex = uriString.contains('/timeline') ? 0 : 1;
    if (uriString.contains('/timeline')) {
      _currentIndex = 0;
    } else if (uriString.contains('/b')) {
      _currentIndex = 1;
    } else if (uriString.contains('/c')) {
      _currentIndex = 2;
    } else if (uriString.contains('/account')) {
      _currentIndex = 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Beamer(
            routerDelegate: _routerDelegates[0],
          ),
          Beamer(
            routerDelegate: _routerDelegates[1],
          ),
          Beamer(
            routerDelegate: _routerDelegates[2],
          ),
          Beamer(
            routerDelegate: _routerDelegates[3],
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: _currentIndex,
        // onDestinationSelected: (int newIndex) {
        //   setState(() {
        //     _currentIndex = newIndex;
        //   });
        // },
        onDestinationSelected: (index) {
          if (index != _currentIndex) {
            setState(() => _currentIndex = index);
            _routerDelegates[_currentIndex].update(rebuild: false);
          }
        },
        destinations: const [
          // GestureDetector(
          //   onDoubleTap: () {
          //     Beamer.of(context).beamToNamed('/timeline');
          //   },
          // child: const
          NavigationDestination(
            selectedIcon: Icon(Icons.timeline),
            icon: Icon(Icons.timeline_outlined),
            label: 'Timeline',
          ),
          // ),
          // GestureDetector(
          //   onDoubleTap: () {
          //     Beamer.of(context).beamToNamed('/b');
          //   },
          // child: const
          NavigationDestination(
            selectedIcon: Icon(Icons.flood),
            icon: Icon(Icons.flood_outlined),
            label: 'Budget',
          ),
          // ),
          // GestureDetector(
          //   onDoubleTap: () {
          //     Beamer.of(context).beamToNamed('/c');
          //   },
          // child: const
          NavigationDestination(
            selectedIcon: Icon(Icons.attach_money_rounded),
            icon: Icon(Icons.attach_money_outlined),
            label: 'Finances',
          ),
          // ),
          // GestureDetector(
          //   onDoubleTap: () {
          //     Beamer.of(context).beamToNamed('/d');
          //   },
          // child: const
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
          // ),
        ],
      ),
    );
  }
}

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
