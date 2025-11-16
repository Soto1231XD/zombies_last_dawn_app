import 'package:flutter/material.dart';
import '../../../services/supabase_service.dart';
import '../home/home_content.dart';
import '../posts/posts_screen.dart';
import '../categories/categories_content.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Lista de pantallas
  final List<Widget> _screens = const [
    HomeContent(),      
    PostsScreen(),    
    CategoriesContent(),
    ProfileScreen(),    
  ];

  // Títulos según la pestaña
  final List<String> _titles = [
    'Inicio',
    'Publicaciones',
    'Categorías',
    '', 
  ];

  // Cambio de índice al presionar un botón
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await SupabaseService().signOut();
      // AuthWrapper detectará automáticamente el cierre de sesión
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al cerrar sesión'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔹 AppBar solo para Inicio, Publicaciones y Categorías
      appBar: _selectedIndex != 3
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                _titles[_selectedIndex],
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              actions: _selectedIndex == 0 
                  ? [
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () => _signOut(context),
                        tooltip: 'Cerrar sesión',
                        color: Colors.greenAccent,
                      ),
                    ]
                  : null,
            )
          : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF0B0F16),
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey.shade600,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'Publicaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}