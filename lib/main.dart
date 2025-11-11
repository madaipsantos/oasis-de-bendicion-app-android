import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webradiooasis/config/router/app_router.dart';
import 'package:webradiooasis/infrastructure/services/daily_verse_service.dart';
import 'package:webradiooasis/presentation/providers/audio_player_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Cargar los versículos al inicio
  await DailyVerseService.loadVerses();
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => AudioPlayerProvider(),
      lazy: false,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oasis de Bendición',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.home,
      routes: AppRouter.routes,
    );
  }
}
