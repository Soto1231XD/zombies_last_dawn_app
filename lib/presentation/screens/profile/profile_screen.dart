import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../services/supabase_service.dart';
import '../../../services/image_service.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  String? _userRole;
  String? _avatarUrl;
  String? _username;

  // ---- PALETA -----
  final Color bg = const Color(0xFF0B1220);
  final Color fg = const Color(0xFFE5E7EB);
  final Color accent = const Color(0xFF22D3EE);
  final Color muted = const Color(0xFF94A3B8);

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
      final profile = await SupabaseService().getUserProfile();

      if (profile != null) {
        _username = profile['username'] as String?;

        if (profile['avatar_url'] != null) {
          final avatarUrl = profile['avatar_url'] as String;
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final cachedAvatarUrl = '$avatarUrl?t=$timestamp';

          if (mounted) {
            setState(() {
              _avatarUrl = cachedAvatarUrl;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _avatarUrl = null;
            });
          }
        }
      }
    } catch (e) {
      _userRole = 'user';
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateProfilePicture() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Tomar foto'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _handleImageSelection(true);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Elegir de la galería'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _handleImageSelection(false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleImageSelection(bool fromCamera) async {
    try {
      final ImageService imageService = ImageService();
      final String? imageUrl = fromCamera
          ? await imageService.takeAndUploadProfilePicture()
          : await imageService.selectAndUploadProfilePicture();

      if (imageUrl != null && mounted) {
        await Future.delayed(const Duration(milliseconds: 500));
        await _loadUserData();

        setState(() {
          _avatarUrl = imageUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Foto de perfil actualizada correctamente'),
            backgroundColor: accent,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: destructive,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );

    if (result == true && mounted) {
      await _loadUserData();
    }
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
    final userName = _username ?? _extractUsername(userEmail);

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
          style: TextStyle(color: accent, fontWeight: FontWeight.bold),
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
            // AVATAR
            Center(
              child: Stack(
                children: [
                  Container(
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
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: _avatarUrl != null
                          ? NetworkImage(_avatarUrl!)
                          : const AssetImage('assets/images/avatar.png')
                              as ImageProvider,
                      onBackgroundImageError: (exception, stackTrace) {
                        if (mounted) {
                          setState(() {
                            _avatarUrl = null;
                          });
                        }
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: bg, width: 3),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: _updateProfilePicture,
                      ),
                    ),
                  ),
                ],
              ).animate().scale(duration: 800.ms).fadeIn(duration: 600.ms),
            ),

            const SizedBox(height: 16),

            // USERNAME + EDIT
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    color: accent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _navigateToEditProfile,
                  child: Icon(
                    Icons.edit,
                    color: mutedFg,
                    size: 18,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 800.ms),

            const SizedBox(height: 8),

            // BADGES: ROL + ESTADO
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: accent.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _userRole == 'admin'
                            ? Icons.verified_user
                            : Icons.person,
                        size: 14,
                        color: accent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        (_userRole ?? 'Jugador').toUpperCase(),
                        style: TextStyle(
                          color: accent,
                          fontSize: 11,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: Color(0xFF22C55E),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'En línea',
                        style: TextStyle(
                          color: Color(0xFFBBF7D0),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // EMAIL
            Text(
              userEmail,
              style: TextStyle(color: mutedFg, fontSize: 14),
            ).animate().fadeIn(duration: 800.ms),

            const SizedBox(height: 6),

            // MIEMBRO DESDE
            Text(
              "Miembro desde: $userSince",
              style: TextStyle(color: mutedFg, fontSize: 12),
            ).animate().fadeIn(duration: 1000.ms),

            const SizedBox(height: 24),

            // TÍTULO SECCIÓN INFO
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Información de la cuenta',
                style: TextStyle(
                  color: fg,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 8),

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
                  _buildInfoRow('Nombre de usuario', userName),
                  _buildInfoRow(
                    'Email verificado',
                    user?.emailConfirmedAt != null ? 'Sí' : 'No',
                  ),
                  _buildInfoRow('Último acceso', lastAccess),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 1000.ms)
                .slide(begin: const Offset(0, 0.2)),

            const SizedBox(height: 20),

            // ACCIONES RÁPIDAS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _quickAction(
                  icon: Icons.person,
                  label: 'Perfil',
                  onTap: _navigateToEditProfile,
                ),
                const SizedBox(width: 8),
                _quickAction(
                  icon: Icons.lock,
                  label: 'Seguridad',
                  onTap: () {
                    // TODO: Navegar a pantalla de seguridad
                  },
                ),
                const SizedBox(width: 8),
                _quickAction(
                  icon: Icons.settings,
                  label: 'Ajustes',
                  onTap: () {
                    // TODO: Navegar a ajustes
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // SUBWIDGETS
  // ---------------------------

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
              style: TextStyle(color: fg, fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: border),
              ),
              child: Icon(
                icon,
                color: accent,
                size: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: mutedFg,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // AUX
  // ---------------------------

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
