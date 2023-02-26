import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/account/presentation/account_page.dart';
import 'package:pocketfi/src/features/account/presentation/setting_page.dart';
import 'package:pocketfi/src/features/budget/presentation/budget_page.dart';
import 'package:pocketfi/src/features/budget/presentation/create_new_budget_view.dart';
import 'package:pocketfi/src/features/budget/wallet/presentation/create_new_wallet_view.dart';
import 'package:pocketfi/src/features/budget/wallet/presentation/wallet_page.dart';
import 'package:pocketfi/src/features/timeline/presentation/timeline_page.dart';
import 'package:pocketfi/src/features/timeline/transactions/presentation/add_new_transactions/add_new_transaction.dart';
import 'package:pocketfi/src/routing/temp_screens.dart';

class BottomNavBarBeamer extends StatelessWidget {
  const BottomNavBarBeamer({super.key});

  static final routerDelegate = BeamerDelegate(
    // locationBuilder: simpleLocationBuilder
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
        primarySwatch: AppColors.mainMaterialColor1,
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
          title: Strings.timeline,
          type: BeamPageType.noTransition,
          // child: RootScreen(label: 'Timeline', detailsPath: '/timeline/details'),
          child: TimelinePage(),
        ),
        if (state.uri.pathSegments.length == 2)
          const BeamPage(
            // type: BeamPageType.slideTransition,
            key: ValueKey('timeline/overview'),
            title: 'Overview Details',
            child: AddNewTransaction(),
            // child: AddNewExpensePage(),
          ),
        if (state.uri.pathSegments.length == 3)
          const BeamPage(
            fullScreenDialog: true,
            // type: BeamPageType.fadeTransition,
            key: ValueKey('timeline/overview/selectcategory'),
            title: 'Select Category',
            child: DetailsScreen(label: 'Select Category'),
          ),
      ];
}

/// Location defining the pages for the second tab
class BudgetLocation extends BeamLocation<BeamState> {
  BudgetLocation(super.routeInformation);
  @override
  List<String> get pathPatterns => [
        // '/budget/:path*',
        // '/budget/wallet/:path*',
        // '/budget/createNewBudget',
        // '/wallet/createNewWallet',
        '/*',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('budget'),
          title: Strings.budget,
          type: BeamPageType.noTransition,
          // child: RootScreen(label: 'Budget', detailsPath: '/b/details'),
          child: BudgetPage(),
          // child: BudgetPage(),
        ),
        if (state.uri.pathSegments.contains('createNewBudget'))
          const BeamPage(
            key: ValueKey('/createNewBudget'),
            title: Strings.createNewBudget,
            child: CreateNewBudgetView(),
          ),
        if (state.uri.pathSegments.contains('wallet'))
          const BeamPage(
            key: ValueKey('/wallet'),
            title: 'Wallet',
            child: WalletPage(),
          ),
        if (state.uri.pathSegments.contains('createNewWallet'))
          const BeamPage(
            key: ValueKey('/createNewWallet'),
            title: Strings.createNewWallet,
            child: CreateNewWalletView(),
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
          title: Strings.account,
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
      initialPath: '/budget',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('/budget')) {
          return BudgetLocation(routeInformation);
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
    } else if (uriString.contains('/budget')) {
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
            label: Strings.timeline,
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
            label: Strings.budget,
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
            label: Strings.finances,
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
            label: Strings.account,
          ),
          // ),
        ],
      ),
    );
  }
}
