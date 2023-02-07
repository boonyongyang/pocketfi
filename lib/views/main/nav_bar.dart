import 'package:flutter/material.dart';
import 'package:pocketfi/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/views/main/account/account_page.dart';
import 'package:pocketfi/views/main/timeline_view.dart';
import 'package:pocketfi/views/main/timeline/timeline_page.dart';
import 'package:pocketfi/views/tabs/users_posts_view.dart';

const TextStyle _textStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  letterSpacing: 2,
  fontStyle: FontStyle.italic,
);

class MaterialYou extends StatefulWidget {
  const MaterialYou({Key? key}) : super(key: key);

  @override
  State<MaterialYou> createState() => _MaterialYouState();
}

class _MaterialYouState extends State<MaterialYou> {
  int _currentIndex = 0;

  List<Widget> pages = const [
    // Text('Timeline', style: _textStyle),
    TimelineView(),
    TimelinePage(),
    EmptyContentsWithTextAnimationView(text: 'Timeline'),
    EmptyContentsWithTextAnimationView(text: 'Timeline'),
    // Text('Budget', style: _textStyle),
    // Text('Finances', style: _textStyle),
    // Text('Account', style: _textStyle),
    // AccountPage(title: "Account"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(''),
      // ),
      body: Center(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        height: 80,
        selectedIndex: _currentIndex,
        onDestinationSelected: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.eco),
            icon: Icon(Icons.eco_outlined),
            label: 'Timeline',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.flood),
            icon: Icon(Icons.flood_outlined),
            label: 'Budget',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.attach_money_rounded),
            icon: Icon(Icons.attach_money_outlined),
            label: 'Finances',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
