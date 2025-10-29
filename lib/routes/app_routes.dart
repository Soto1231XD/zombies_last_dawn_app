import 'package:flutter/material.dart';
import 'package:zombies_last_dawn_app/presentation/screens/home/home_content.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/posts/posts_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/categories/categories_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String posts = '/posts';
  static const String profile = '/profile';
  static const String categories = '/categories';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeContent(),
    home: (context) => const HomeScreen(),
    posts: (context) => const PostsScreen(),
    profile: (context) => const ProfileScreen(),
    categories: (context) => const CategoriesScreen(),
  };
}
