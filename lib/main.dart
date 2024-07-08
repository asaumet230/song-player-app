import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/config.dart';
import 'presentation/providers/providers.dart';
import 'presentation/screens/screens.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioPlayerProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getAppTheme(),
      home: const SongPlayerScreen(),
    );
  }
}
