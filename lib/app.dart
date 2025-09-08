import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/notes/view/notes_screen.dart';
import 'features/posts/view/posts_screen.dart';
import 'features/settings/view/settings_screen.dart';
import 'features/settings/viewmodel/setting_viewmodel.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsViewModel>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FAZ Flutter Task',
      theme: AppTheme.lightTheme(settings.seedColor),
      darkTheme: AppTheme.darkTheme(settings.seedColor),
      themeMode: settings.themeMode,
      home: const _Home(),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home({super.key});
  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  int index = 0;
  final pages = const [NotesScreen(), PostsScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.note_alt_outlined), label: 'Notes'),
          NavigationDestination(icon: Icon(Icons.dynamic_feed_outlined), label: 'Posts'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
