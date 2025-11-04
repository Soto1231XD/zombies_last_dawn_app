import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import '../../../services/supabase_service.dart';
import '../../../routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  String? _userRole; // 🔹 AGREGAR ESTA VARIABLE

  @override
  void initState() {
    super.initState();
    _loadUserData(); // 🔹 CAMBIAR A _loadUserData
  }

  // 🔹 NUEVO MÉTODO: Cargar datos del usuario
  Future<void> _loadUserData() async {
    try {
      // Cargar el rol del usuario
      _userRole = await SupabaseService().getUserRole();
    } catch (e) {
      _userRole = 'user';
    }
    
    // Simulación de carga de datos
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await SupabaseService().signOut();
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
    final user = SupabaseService().currentUser;
    final userEmail = user?.email ?? 'Usuario';
    final userName = _extractUsername(userEmail);
    
    // CORRECCIÓN: Usar los métodos corregidos para fechas
    final userSince = _formatDateFromString(user?.createdAt);
    final lastAccess = _formatDateFromString(user?.lastSignInAt);

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
            icon: const Icon(Icons.logout, color: Colors.greenAccent),
            onPressed: () => _signOut(context),
            tooltip: 'Cerrar sesión',
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
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              )
                  .animate()
                  .scale(duration: 800.ms, curve: Curves.easeOutBack)
                  .fadeIn(duration: 600.ms),
            ),
            const SizedBox(height: 16),

            // Nombre de usuario REAL
            Text(
              userName,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 800.ms),

            const SizedBox(height: 6),

            // Email real del usuario
            Text(
              userEmail,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ).animate().fadeIn(duration: 800.ms),

            const SizedBox(height: 6),

            // Fecha de registro real - CORREGIDO
            Text(
              "Miembro desde: $userSince",
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ).animate().fadeIn(duration: 1000.ms),

            const SizedBox(height: 24),

            // Información de la cuenta (datos reales) - CORREGIDO y CON ROL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF141A22),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Rol', _userRole ?? 'user'), // 🔹 AGREGAR ESTA LÍNEA
                  _buildInfoRow('Email verificado', user?.emailConfirmedAt != null ? 'Sí' : 'No'),
                  _buildInfoRow('Último acceso', lastAccess),
                  _buildInfoRow('Estado', 'Activo'),
                ],
              ),
            ).animate().fadeIn(duration: 1000.ms).slide(begin: const Offset(0, 0.2)),

            const SizedBox(height: 30),

            // Estadísticas del juego (puedes mantenerlas ficticias o conectarlas a tu base de datos después)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statCard("Kills", "3,421"),
                _statCard("Misiones", "87"),
                _statCard("Logros", "15"),
              ],
            ).animate().fadeIn(duration: 1000.ms).slide(begin: const Offset(0, 0.2)),

            const SizedBox(height: 30),

            // Descripción (puedes hacerla editable después)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF141A22),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text(
                    "Biografía",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Soy un sobreviviente de las ruinas. Me especializo en armas de largo alcance y recolección de suministros. "
                    "He formado parte del escuadrón 'Last Dawn' desde el inicio del brote.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Futura funcionalidad para editar biografía
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Editar Biografía'),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 1000.ms).slide(begin: const Offset(0, 0.2)),

            const SizedBox(height: 30),

            // Botón de cerrar sesión
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _signOut(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ).animate().fadeIn(duration: 1000.ms),

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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
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
        return "Completó la misión 'Rescate en el Búnker'.";
      case 1:
        return "Desbloqueó el arma legendaria 'Reaper Shotgun'.";
      case 2:
        return "Formó alianza con el jugador 'ShadowFox'.";
      default:
        return "Actividad reciente desconocida.";
    }
  }

  // --- Métodos auxiliares para datos reales ---

  String _extractUsername(String email) {
    if (email.contains('@')) {
      return email.split('@')[0];
    }
    return email;
  }

  // NUEVO MÉTODO: Maneja fechas como String desde Supabase
  String _formatDateFromString(String? dateString) {
    if (dateString == null) return 'No disponible';
    
    try {
      final date = DateTime.parse(dateString);
      return _formatDate(date);
    } catch (e) {
      return 'Fecha inválida';
    }
  }

  // MÉTODO CORREGIDO: Solo acepta DateTime
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays < 1) {
      return 'Hoy';
    } else if (difference.inDays < 2) {
      return 'Ayer';
    } else if (difference.inDays < 30) {
      return 'Hace ${difference.inDays} días';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Hace $months ${months == 1 ? 'mes' : 'meses'}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}