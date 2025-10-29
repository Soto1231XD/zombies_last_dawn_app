import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CategoriesContent extends StatelessWidget {
  const CategoriesContent({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'title': 'Armas', 'icon': Icons.security, 'color': Colors.redAccent},
      {
        'title': 'Zombies',
        'icon': Icons.bug_report,
        'color': Colors.greenAccent,
      },
      {'title': 'Mapas', 'icon': Icons.map, 'color': Colors.lightBlueAccent},
      {'title': 'Misiones', 'icon': Icons.flag, 'color': Colors.orangeAccent},
      {
        'title': 'Bugs',
        'icon': Icons.warning_amber_rounded,
        'color': Colors.yellowAccent,
      },
      {'title': 'Guías', 'icon': Icons.menu_book, 'color': Colors.purpleAccent},
    ];

    return Container(
      color: const Color(0xFF0B0F16),
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _categoryCard(
            title: category['title'] as String,
            icon: category['icon'] as IconData,
            color: category['color'] as Color,
            delay: index * 150,
            onTap: () {
              // TODO: acción al seleccionar categoría
            },
          );
        },
      ),
    );
  }

  static Widget _categoryCard({
    required String title,
    required IconData icon,
    required Color color,
    required int delay,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child:
          Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.15),
                      Colors.black.withOpacity(0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.4), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: color, size: 42),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
              .animate(delay: (delay).ms)
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.8, 0.8))
              .slide(begin: const Offset(0, 0.2)),
    );
  }
}
