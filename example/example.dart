import 'package:flutter/material.dart';

import 'package:tabbed_scaffold/tabbed_scaffold.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<ScaffoldTab> _tabs = [
    ScaffoldTab(
      title: const Text('Phone'),
      body: Container(
        color: Colors.amber,
      ),
      bottomNavigationBarItemIcon: Icon(Icons.phone),
    ),
    ScaffoldTab(
      title: const Text('Local Activity'),
      body: Container(
        color: Colors.green,
      ),
      bottomNavigationBarItemIcon: Icon(Icons.local_activity),
    ),
    ScaffoldTab(
      title: const Text('Dashboard'),
      body: Container(
        color: Colors.red,
      ),
      bottomNavigationBarItemIcon: Icon(Icons.dashboard),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return TabbedScaffold(
      tabs: _tabs,
    );
  }
}
