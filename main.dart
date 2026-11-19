import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/app_shell.dart';
import 'services/notes_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = NotesStore();
  await store.load();
  runApp(
    ChangeNotifierProvider<NotesStore>.value(
      value: store,
      child: const FieldNotesApp(),
    ),
  );
}

class FieldNotesApp extends StatelessWidget {
  const FieldNotesApp({super.key});

  static const green = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Field Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        scaffoldBackgroundColor: const Color(0xFFFAFBF8),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const AppShell(),
    );
  }
}
