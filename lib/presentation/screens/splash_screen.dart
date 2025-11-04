import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    print('🚀 SplashScreen iniciado');
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Pequeña pausa para mostrar el splash
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final isLoggedIn = SupabaseService().isLoggedIn;
    final user = SupabaseService().currentUser;
    
    print('🔍 SplashScreen - Usuario logueado: $isLoggedIn');
    print('📧 SplashScreen - Email del usuario: ${user?.email}');
    
    if (mounted) {
      // SIEMPRE navegar a AuthWrapper, que decidirá qué mostrar
      print('➡️ Navegando a AUTH WRAPPER');
      Navigator.pushReplacementNamed(context, AppRoutes.authWrapper);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F16),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.security,
              size: 80,
              color: Colors.greenAccent,
            ),
            const SizedBox(height: 20),
            Text(
              'Zombies: Last Dawn',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.greenAccent,
            ),
          ],
        ),
      ),
    );
  }
}