import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../posts/posts_content.dart';
import '../categories/categories_content.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F16),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Banner principal con posible animación Lottie
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.greenAccent, Colors.black87],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/banner_zombies.png'), // Imagen del banner
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
                ),
              ),
              
            )
                .animate()
                .fadeIn(duration: 900.ms)
                .slide(begin: const Offset(0, -0.2)),

            const SizedBox(height: 24),

            // Descripción principal
            const Text(
              'Sobre el juego',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 600.ms),

            const SizedBox(height: 8),

            const Text(
              'Last Dawn es un juego 2D de supervivencia en vista cenital donde deberás enfrentar hordas interminables de zombies, completar misiones aleatorias y mejorar tus habilidades. '
              'Cada partida es distinta: rescata sobrevivientes, defiende zonas y busca recursos antes de que llegue el amanecer.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
            ).animate().fadeIn(duration: 800.ms).slide(begin: const Offset(0, 0.1)),

            const SizedBox(height: 30),

            // Sección de características
            const Text(
              'Características del juego',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 600.ms),

            const SizedBox(height: 16),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _featureCard(
                  icon: Icons.bolt,
                  title: 'Acción dinámica',
                  description: 'Combina estrategia y reflejos para sobrevivir a oleadas intensas.',
                ),
                _featureCard(
                  icon: Icons.shuffle,
                  title: 'Misiones aleatorias',
                  description: 'Cada partida presenta nuevos objetivos y desafíos únicos.',
                ),
                _featureCard(
                  icon: Icons.auto_fix_high,
                  title: 'Personalización',
                  description: 'Elige tus armas y mejora tu estilo de combate.',
                ),
                _featureCard(
                  icon: Icons.people,
                  title: 'Comunidad activa',
                  description: 'Comparte experiencias, consejos y estrategias en el foro.',
                ),
              ],
            ).animate().fadeIn(duration: 1000.ms).scale(begin: const Offset(0.9, 0.9)),

            const SizedBox(height: 40),

            // Nueva sección: Personajes principales
            const Text(
              'Personajes principales',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 600.ms),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _characterCard(
                  name: 'Sobreviviente',
                  imagePath: 'assets/images/survivor.png',
                  description: 'Valiente y ágil, especialista en combate cuerpo a cuerpo.',
                ),
                _characterCard(
                  name: 'Curandero',
                  imagePath: 'assets/images/curandero.png', // Imagen del personaje
                  description: 'Especialista en curar y apoyar al equipo, manteniendo a todos con vida durante las batallas.',
                ),
              ],
            ).animate().fadeIn(duration: 1000.ms).scale(begin: const Offset(0.9, 0.9)),

            const SizedBox(height: 40),

            // Nueva sección: Armas destacadas
            const Text(
              'Armas destacadas',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 600.ms),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _weaponCard(
                  name: 'Escopeta',
                  imagePath: 'assets/images/escopeta.png', // Imagen del arma
                  description: 'Ideal para combate cercano, alto daño.',
                ),
                _weaponCard(
                  name: 'Rifle de francotirador',
                  imagePath: 'assets/images/sniper.png', // Imagen del arma
                  description: 'Precisión a larga distancia, perfecto para francotiradores.',
                ),
              ],
            ).animate().fadeIn(duration: 1000.ms).scale(begin: const Offset(0.9, 0.9)),

            const SizedBox(height: 40),

            // Frase final
            const Text(
              '"El amanecer llega para algunos... pero no todos lo verán."',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
            ).animate().fadeIn(duration: 1200.ms).slide(begin: const Offset(0, 0.2)),
          ],
        ),
      ),
    );
  }

  // Widget de card de característica
  static Widget _featureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141A22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.greenAccent, size: 38),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
          ),
        ],
      ),
    );
  }

  // Widget de card de personaje
  static Widget _characterCard({
    required String name,
    String? imagePath,
    required String description,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF141A22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.4)),
      ),
      child: Column(
        children: [
           Image.asset(imagePath ?? 'assets/images/survivor.png', height: 80), // Imagen del personaje
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(description, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  // Widget de card de arma
  static Widget _weaponCard({
    required String name,
    String? imagePath,
    required String description,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF141A22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Image.asset(imagePath ?? 'assets/images/escopeta.png', height: 80), // Imagen del arma
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(description, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
