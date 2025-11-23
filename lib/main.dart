import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'routes/app_routes.dart';
import 'services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Cargar archivo .env
  try {
    await dotenv.load(fileName: ".env");
    print('✅ .env cargado correctamente');
  } catch (e) {
    print('❌ Error al cargar .env: $e');
  }

  // 2) Inicializar Supabase usando variables del .env
  try {
    await SupabaseService().initialize();
    print('✅ Supabase inicializado correctamente');
  } catch (e) {
    print('❌ Error inicializando Supabase: $e');
  }

  // 3) Lanzar app
  runApp(const LastDawnApp());
}

class LastDawnApp extends StatelessWidget {
  const LastDawnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zombies: Last Dawn Wiki',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.greenAccent,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0B0F16),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
