import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

// Adapters / modèles
import 'core/data/models/event_model.dart';
import 'core/data/models/reminder_item.dart';
import 'core/data/models/contact_item.dart';
import 'core/data/models/brain_dump_item.dart';
import 'core/data/models/mes_pensees_item.dart';
import 'core/data/models/mental_load_item.dart';


// Providers
import 'core/data/providers/reminder_provider.dart';
import 'core/data/providers/contact_provider.dart';
import 'core/data/providers/brain_dump_provider.dart';
import 'core/data/providers/mes_pensees_provider.dart';
import 'core/data/providers/mental_load_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('fr_FR', null);

  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  // ⚠️ DEV uniquement
  await Hive.deleteFromDisk(); // ⚠️ DEV uniquement
  // ⚠️ DEV uniquement


  // ⚠️ Enregistre tous tes adapters AVANT d’ouvrir des box
  Hive.registerAdapter(EventModelAdapter());
  Hive.registerAdapter(ReminderTypeAdapter());
  Hive.registerAdapter(ReminderItemAdapter());
  Hive.registerAdapter(ContactItemAdapter());
  Hive.registerAdapter(BrainDumpItemAdapter());
  Hive.registerAdapter(MesPenseesItemAdapter());
  Hive.registerAdapter(MentalLoadItemAdapter());


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReminderProvider()..init()), 
        ChangeNotifierProvider(create: (_) => ContactProvider()..init()),  
        ChangeNotifierProvider(create: (_) => BrainDumpProvider()..init()),
        ChangeNotifierProvider(create: (_) => MesPenseesProvider()..init()),
        ChangeNotifierProvider(create: (_) => MentalLoadProvider()..init()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'IdentyQuest',
      locale: const Locale('fr', 'FR'),
      supportedLocales: const [Locale('fr', 'FR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
