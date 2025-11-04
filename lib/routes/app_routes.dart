import 'package:flutter/material.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/posts/posts_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/categories/categories_screen.dart';
import '../presentation/screens/splash_screen.dart'; // Agregar
import '../presentation/screens/auth_wrapper.dart'; // Agregar


class AppRoutes {
  static const String splash = '/'; // Ruta inicial
  static const String authWrapper = '/auth';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String posts = '/posts';
  static const String profile = '/profile';
  static const String categories = '/categories';
  

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    authWrapper: (context) => const AuthWrapper(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(), // Mantengo HomeScreen como principal
    posts: (context) => const PostsScreen(),
    profile: (context) => const ProfileScreen(),
    categories: (context) => const CategoriesScreen(),
  };
}