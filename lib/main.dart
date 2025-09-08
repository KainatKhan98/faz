import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';

import 'features/notes/viewmodel/notes_viewmodel.dart';
import 'features/posts/viewmodel/posts_viewmodel.dart';
import 'features/settings/viewmodel/setting_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Build repositories inside VMs (simple for this task)
  final settingsVM = SettingsViewModel();
  await settingsVM.loadPersistedTheme();

  final notesVM = NotesViewModel();
  await notesVM.init();

  final postsVM = PostsViewModel();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => settingsVM),
        ChangeNotifierProvider(create: (_) => notesVM),
        ChangeNotifierProvider(create: (_) => postsVM),
      ],
      child: const MyApp(),
    ),
  );
}
