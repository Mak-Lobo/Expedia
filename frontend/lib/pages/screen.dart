import 'package:expedia/containers/dashboard.dart';
import 'package:expedia/containers/edits.dart';
import 'package:expedia/containers/read_data.dart';
import 'package:expedia/customWidgets/appbar.dart';
import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int _selectedIndex = 2;
  bool _isVisible = true;

  // screens
  final List<Widget> _pages = const [Dashboard(), ReadData(), Edits()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 800,
          maxWidth: 1920,
          minHeight: 600,
          maxHeight: 1024,
        ),
        child: Row(
          children: [
            if (_isVisible)
              NavigationRail(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.tertiaryContainer.withValues(alpha: 0.5),
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text("Dashboard"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.edit),
                    label: Text("Modify"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.book_rounded),
                    label: Text("Fetch Data"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.flight_takeoff),
                    label: Text("Flights"),
                  ),
                ],
                selectedIndex: _selectedIndex,
                onDestinationSelected: (int i) {
                  setState(() {
                    _selectedIndex = i;
                  });
                },
                groupAlignment: 0.0,
                minExtendedWidth: 500,
                minWidth: 50,
                labelType: NavigationRailLabelType.all,
              ),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _isVisible = !_isVisible;
                  });
                },
                icon: (_isVisible)
                    ? Icon(Icons.arrow_left, size: 30)
                    : Icon(Icons.arrow_right, size: 30),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height - kToolbarHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: _pages[_selectedIndex],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
