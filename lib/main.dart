import 'package:flutter/material.dart';

import 'exports.dart';

void main() async {
  await ServiceLocator.initDependencies();
  runApp(const CattleApp());
}

class CattleApp extends StatelessWidget {
  const CattleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gado App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.home.route,
      routes: routes,
      onUnknownRoute: onUnknownRoute,
    );
  }
}
