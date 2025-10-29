import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Simulacion de carga de datos
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F16),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Perfil del Jugador",
          style: TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.greenAccent),
            onPressed: () {
              // Navegación futura a configuración
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar animado
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.greenAccent, Colors.black],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage:
                      AssetImage('assets/images/avatar.png'),
                ),
              )
                  .animate()
                  .scale(duration: 800.ms, curve: Curves.easeOutBack)
                  .fadeIn(duration: 600.ms),
            ),
            const SizedBox(height: 16),

            // Nombre de usuario
            const Text(
              "Survivor_Zero",
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 800.ms),

            const SizedBox(height: 6),

            const Text(
              "Nivel 27 • Cazador de Élite",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ).animate().fadeIn(duration: 1000.ms),

            const SizedBox(height: 24),

            // Estadísticas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statCard("Kills", "3,421"),
                _statCard("Misiones", "87"),
                _statCard("Logros", "15"),
              ],
            ).animate().fadeIn(duration: 1000.ms).slide(begin: const Offset(0, 0.2)),

            const SizedBox(height: 30),

            // Descripción
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF141A22),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
              ),
              child: const Text(
                "Soy un sobreviviente de las ruinas. Me especializo en armas de largo alcance y recolección de suministros. "
                "He formado parte del escuadrón ‘Last Dawn’ desde el inicio del brote.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ).animate().fadeIn(duration: 1000.ms).slide(begin: const Offset(0, 0.2)),

            const SizedBox(height: 30),

            // Últimas actividades
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Últimas actividades",
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ).animate().fadeIn(duration: 900.ms),

            const SizedBox(height: 16),

            // Aquí se alterna entre shimmer o contenido real
            isLoading ? _buildShimmerList() : _buildActivityList(),
          ],
        ),
      ),
    );
  }

  // --- Widgets auxiliares ---

  Widget _buildShimmerList() {
    return Column(
      children: List.generate(
        3,
        (index) => Shimmer.fromColors(
          baseColor: const Color(0xFF1A1F28),
          highlightColor: Colors.greenAccent.withOpacity(0.2),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF141A22),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF141A22),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.greenAccent.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.bolt, color: Colors.greenAccent, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _activityText(index),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 700.ms, curve: Curves.easeOut),
      ),
    );
  }

  static Widget _statCard(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.greenAccent,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  static String _activityText(int index) {
    switch (index) {
      case 0:
        return "Completó la misión ‘Rescate en el Búnker’.";
      case 1:
        return "Desbloqueó el arma legendaria ‘Reaper Shotgun’.";
      case 2:
        return "Formó alianza con el jugador ‘ShadowFox’.";
      default:
        return "Actividad reciente desconocida.";
    }
  }
}
