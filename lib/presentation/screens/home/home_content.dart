import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // BANNER PRINCIPAL
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF22D3EE),
                  Color(0xFF0B1220),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('assets/images/banner_zombies.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black45,
                  BlendMode.darken,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 900.ms).slide(begin: const Offset(0, -0.2)),

          const SizedBox(height: 24),

          // TÍTULO "Sobre el juego"
          const Text(
            'Sobre el juego',
            style: TextStyle(
              color: Color(0xFF22D3EE),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(duration: 600.ms),

          const SizedBox(height: 8),

          // DESCRIPCIÓN PRINCIPAL
          const Text(
            'Last Dawn es un juego 2D de supervivencia en vista cenital donde deberás enfrentar hordas interminables de zombies, completar misiones aleatorias y mejorar tus habilidades.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Color(0xFFA8B3C7),
              fontSize: 16,
              height: 1.5,
            ),
          ).animate().fadeIn(duration: 800.ms).slide(begin: const Offset(0, 0.1)),

          const SizedBox(height: 12),

          // SUBSECCIONES SOBRE EL JUEGO
          _gameSubSection(
            title: 'Historia del mundo',
            content: 'El mundo ha caído en el caos tras un extraño fenómeno que hizo surgir hordas de zombies. Los sobrevivientes deben organizarse y luchar por su existencia.',
          ),
          _gameSubSection(
            title: 'Objetivos del jugador',
            content: 'Sobrevive, rescata a los sobrevivientes, defiende zonas y consigue recursos antes del amanecer.',
          ),
          _gameSubSection(
            title: 'Consejos',
            content: 'Explora cuidadosamente, combina armas y habilidades, y planifica tus movimientos para enfrentar hordas más difíciles.',
          ),

          const SizedBox(height: 30),

          // TÍTULO "Características"
          const Text(
            'Características del juego',
            style: TextStyle(
              color: Color(0xFF22D3EE),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(duration: 600.ms),

          const SizedBox(height: 16),

          // TARJETAS DE CARACTERÍSTICAS
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

          // ----- PERSONAJES -----
          const Text(
            'Personajes principales',
            style: TextStyle(
              color: Color(0xFF22D3EE),
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
                imagePath: 'assets/images/curandero.png',
                description: 'Especialista en curar y apoyar al equipo durante las batallas.',
              ),
            ],
          ).animate().fadeIn(duration: 1000.ms).scale(begin: const Offset(0.9, 0.9)),

          const SizedBox(height: 40),

          // ----- ARMAS -----
          const Text(
            'Armas destacadas',
            style: TextStyle(
              color: Color(0xFF22D3EE),
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
                imagePath: 'assets/images/escopeta.png',
                description: 'Ideal para combate cercano, alto daño.',
              ),
              _weaponCard(
                name: 'Rifle de francotirador',
                imagePath: 'assets/images/sniper.png',
                description: 'Precisión a larga distancia, perfecto para francotiradores.',
              ),
            ],
          ).animate().fadeIn(duration: 1000.ms).scale(begin: const Offset(0.9, 0.9)),

          const SizedBox(height: 40),

          // ----- ENEMIGOS -----
          const Text(
            'Enemigos',
            style: TextStyle(
              color: Color(0xFF22D3EE),
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
              _enemyCard(
                name: 'Zombie común',
                imagePath: 'assets/images/zombie-normal.png',
                description: 'Lento pero en gran número, peligroso en grupo.',
              ),
              _enemyCard(
                name: 'Zombie corredor',
                imagePath: 'assets/images/sprinter.png',
                description: 'Rápido y agresivo, difícil de esquivar.',
              ),
              _enemyCard(
                name: 'Tanke',
                imagePath: 'assets/images/Tank.png',
                description: 'Fuerte, resistente, pero lento.',
              ),
            ],
          ).animate().fadeIn(duration: 1000.ms).scale(begin: const Offset(0.9, 0.9)),

          const SizedBox(height: 40),

          // ----- NUEVAS ACTUALIZACIONES -----
          const Text(
            'Últimas actualizaciones',
            style: TextStyle(
              color: Color(0xFF22D3EE),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(duration: 600.ms),

          const SizedBox(height: 16),

          _updateCard(
            title: 'Versión 1.2',
            description: 'Se añadieron nuevas misiones, armas y enemigos especiales.',
          ),
          _updateCard(
            title: 'Versión 1.3',
            description: 'Mejoras en la IA enemiga y corrección de bugs.',
          ),

          const SizedBox(height: 40),

          // FRASE FINAL
          const Text(
            '"El amanecer llega para algunos... pero no todos lo verán."',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFA8B3C7),
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ).animate().fadeIn(duration: 1200.ms).slide(begin: const Offset(0, 0.2)),
        ],
      ),
    );
  }

  // --- SUBSECCIONES SOBRE EL JUEGO ---
  Widget _gameSubSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF22D3EE),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            color: Color(0xFFA8B3C7),
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms).slide(begin: const Offset(0, 0.1));
  }

  // --- CARD GENÉRICA DE FEATURE ---
  Widget _featureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121A2B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF22D3EE), size: 38),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF22D3EE),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFA8B3C7),
              fontSize: 13,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // --- CARD DE PERSONAJE ---
  Widget _characterCard({
    required String name,
    required String? imagePath,
    required String description,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF121A2B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Image.asset(imagePath!, height: 80),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF22D3EE),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFA8B3C7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // --- CARD DE ARMA ---
  Widget _weaponCard({
    required String name,
    required String? imagePath,
    required String description,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF121A2B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Image.asset(imagePath!, height: 80),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF22D3EE),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFA8B3C7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // --- CARD DE ENEMIGO ---
  Widget _enemyCard({
    required String name,
    required String? imagePath,
    required String description,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF121A2B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Image.asset(imagePath!, height: 80),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF22D3EE),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFA8B3C7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // --- CARD DE ACTUALIZACIÓN ---
  Widget _updateCard({required String title, required String description}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121A2B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF22D3EE),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFFA8B3C7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slide(begin: const Offset(0, 0.1));
  }
}
