import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/settings_manager.dart';
import 'utils/xp_manager.dart';
import 'ui/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = SettingsManager();
  final xp = XpManager();

  await settings.load();
  await xp.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsManager>(create: (_) => settings),
        ChangeNotifierProvider<XpManager>(create: (_) => xp),
      ],
      child: const ProgrammingHubApp(),
    ),
  );
}

class ProgrammingHubApp extends StatelessWidget {
  const ProgrammingHubApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsManager>();
    return MaterialApp(
      title: 'CodeBro',
      debugShowCheckedModeBanner: false,
      theme: settings.theme,
      home: const SplashScreen(),
    );
  }
}