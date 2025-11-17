import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import '../../../services/supabase_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  String? _userRole;

  // ---- PALETA -----
  final Color bg = const Color(0xFF0B1220);
  final Color fg = const Color(0xFFE5E7EB);
  final Color accent = const Color(0xFF22D3EE);
  final Color warn = const Color(0xFFF59E0B);
  final Color muted = const Color(0xFF94A3B8);
  final Color card = const Color(0xFF121A2B);

  // overrides
  final Color secondary = const Color(0xFF0E1626);
  final Color mutedFg = const Color(0xFFA8B3C7);
  final Color border = const Color.fromRGBO(255, 255, 255, 0.12);
  final Color destructive = const Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      _userRole = await SupabaseService().getUserRole();
    } catch (e) {
      _userRole = 'user';
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => isLoading = false);
      }
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await SupabaseService().signOut();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al cerrar sesión'),
          backgroundColor: destructive,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = SupabaseService().currentUser;
    final userEmail = user?.email ?? 'Usuario';
    final userName = _extractUsername(userEmail);

    final userSince = _formatDateFromString(user?.createdAt);
    final lastAccess = _formatDateFromString(user?.lastSignInAt);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Perfil del Jugador",
          style: TextStyle(
            color: accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: accent),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [accent, bg],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
              ).animate().scale(duration: 800.ms).fadeIn(duration: 600.ms),
            ),
            const SizedBox(height: 16),

            Text(
              userName,
              style: TextStyle(
                color: accent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 800.ms),

            const SizedBox(height: 6),

            Text(
              userEmail,
              style: TextStyle(
                color: mutedFg,
                fontSize: 14,
              ),
            ).animate().fadeIn(duration: 800.ms),

            const SizedBox(height: 6),

            Text(
              "Miembro desde: $userSince",
              style: TextStyle(
                color: mutedFg,
                fontSize: 12,
              ),
            ).animate().fadeIn(duration: 1000.ms),

            const SizedBox(height: 24),

            // INFO CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Rol', _userRole ?? 'user'),
                  _buildInfoRow('Email verificado', user?.emailConfirmedAt != null ? 'Sí' : 'No'),
                  _buildInfoRow('Último acceso', lastAccess),
                  _buildInfoRow('Estado', 'Activo'),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 1000.ms)
                .slide(begin: const Offset(0, 0.2)),

            const SizedBox(height: 30),

            // ESTADÍSTICAS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statCard("Kills", "3,421"),
                _statCard("Misiones", "87"),
                _statCard("Logros", "15"),
              ],
            ),

            const SizedBox(height: 30),

            // BIO
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  Text(
                    "Biografía",
                    style: TextStyle(
                      color: accent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Soy un sobreviviente de las ruinas. Me especializo en armas de largo alcance y recolección de suministros. "
                    "He formado parte del escuadrón 'Last Dawn' desde el inicio del brote.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: mutedFg,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: bg,
                    ),
                    child: const Text('Editar Biografía'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // BOTÓN CERRAR SESIÓN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _signOut(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: destructive,
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
            ),

            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Últimas actividades",
                style: TextStyle(
                  color: accent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            isLoading ? _buildShimmerList() : _buildActivityList(),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // SUBWIDGETS
  // ---------------------------

  Widget _buildShimmerList() {
    return Column(
      children: List.generate(
        3,
        (index) => Shimmer.fromColors(
          baseColor: secondary,
          highlightColor: accent.withOpacity(0.2),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 70,
            decoration: BoxDecoration(
              color: secondary,
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
            color: secondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Icon(Icons.bolt, color: accent, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _activityText(index),
                  style: TextStyle(
                    color: mutedFg,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
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
              color: muted,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: fg,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: accent,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: mutedFg,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // ---------------------------
  // AUX
  // ---------------------------

  String _activityText(int index) {
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

  String _extractUsername(String email) {
    if (email.contains('@')) {
      return email.split('@')[0];
    }
    return email;
  }

  String _formatDateFromString(String? dateString) {
    if (dateString == null) return 'No disponible';

    try {
      final date = DateTime.parse(dateString);
      return _formatDate(date);
    } catch (_) {
      return 'Fecha inválida';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) return 'Hoy';
    if (difference.inDays < 2) return 'Ayer';
    if (difference.inDays < 30) return 'Hace ${difference.inDays} días';

    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Hace $months ${months == 1 ? 'mes' : 'meses'}';
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}
