import 'package:flutter/material.dart';
import 'screens/expenditure.dart';
import 'screens/memories.dart';
import 'screens/itinerary.dart';
import 'screens/saved.dart';
import 'screens/home.dart';
import 'constants/destinations.dart';
import 'constants/colours.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MainPage(title: 'Flutter Demo Home Page'),
    );
  }
}

// Main Page includes Navigation Bar
class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class Destination {
  const Destination(this.title, this.icon, this.widget);
  final String title;
  final Icon icon;
  final Widget widget;
}

List<Destination> screens = [
  Destination(DestinationNames.home, DestinationIcons.home, Home()),
  Destination(DestinationNames.expenditure, DestinationIcons.expenditure,
      Expenditure()),
  Destination(DestinationNames.memories, DestinationIcons.memories, Memories()),
  Destination(
      DestinationNames.itinerary, DestinationIcons.itinerary, Itinerary()),
  Destination(DestinationNames.saved, DestinationIcons.saved, Saved()),
];

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;

  List<Widget> destinations = screens
      .map((dest) => NavigationDestination(icon: dest.icon, label: dest.title))
      .toList();
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that
        // was created by the App.build method, and use it to set
        // our appbar title.
        backgroundColor: Color(Colours.SECONDARY),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              screens[currentPageIndex].title,
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_2_rounded),
            onPressed: () {
              // action to be performed when this button is pressed
            },
          ),
          // You can add more widgets here
        ],
      ),

      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(screens[currentPageIndex].title),
      // ),
      body: Center(child: screens[currentPageIndex].widget),
      bottomNavigationBar: NavigationBar(
          backgroundColor: Color(Colours.SECONDARY),
          labelBehavior: labelBehavior,
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: destinations),
    );
  }
}
