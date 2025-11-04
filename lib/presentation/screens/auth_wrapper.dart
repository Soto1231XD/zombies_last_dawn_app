import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zombies_last_dawn_app/services/supabase_service.dart';
import 'auth/login_screen.dart';
import 'home/home_screen.dart';
import 'admin/admin_dashboard.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final SupabaseService _supabaseService = SupabaseService();
  User? _user;
  bool _isCheckingAuth = true;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  void _initializeAuth() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _getCurrentUser();
    
    _supabaseService.client.auth.onAuthStateChange.listen((data) async {
      if (!mounted) return;
      
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.userUpdated) {
        await _checkUserRole();
        setState(() {
          _user = data.session?.user;
          _isCheckingAuth = false;
        });
      } else if (event == AuthChangeEvent.signedOut) {
        setState(() {
          _user = null;
          _isAdmin = false;
          _isCheckingAuth = false;
        });
      } else if (event == AuthChangeEvent.initialSession) {
        await _checkUserRole();
        setState(() {
          _user = data.session?.user;
          _isCheckingAuth = false;
        });
      }
    });
  }

  void _getCurrentUser() async {
    final user = _supabaseService.currentUser;
    await _checkUserRole();
    if (mounted) {
      setState(() {
        _user = user;
        _isCheckingAuth = false;
      });
    }
  }

  Future<void> _checkUserRole() async {
    try {
      _isAdmin = await _supabaseService.isAdmin();
    } catch (e) {
      _isAdmin = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAuth) {
      return _buildLoadingScreen();
    }
    
    if (_user == null) {
      return const LoginScreen();
    }

    // 🔹 NUEVO: Redirigir admins al dashboard
    return _isAdmin ? const AdminDashboard() : const HomeScreen();
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F16),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.greenAccent,
            ),
            const SizedBox(height: 20),
            Text(
              'Verificando permisos...',
              style: TextStyle(
                color: Colors.greenAccent,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}