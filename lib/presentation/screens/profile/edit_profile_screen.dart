import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/profile_service.dart';
import '../../../services/supabase_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileService _profileService = ProfileService(Supabase.instance.client);
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isCheckingUsername = false;
  String _currentAvatarUrl = '';
  String _originalUsername = '';

  // ---- PALETA DE COLORES ----
  final Color bg = const Color(0xFF0B1220);
  final Color accent = const Color(0xFF22D3EE);
  final Color mutedFg = const Color(0xFFA8B3C7);
  final Color secondary = const Color(0xFF0E1626);
  final Color border = const Color.fromRGBO(255, 255, 255, 0.12);
  final Color destructive = const Color(0xFFEF4444);
  final Color success = const Color(0xFF10B981);

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await _profileService.getCurrentUserProfile();
      if (profile != null) {
        setState(() {
          _usernameController.text = profile['username'] ?? '';
          _originalUsername = profile['username'] ?? '';
          _currentAvatarUrl = profile['avatar_url'] ?? '';
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar el perfil: $e'),
            backgroundColor: destructive,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final newUsername = _usernameController.text.trim();
    
    // Si el username no cambió, solo cerrar
    if (newUsername == _originalUsername) {
      if (mounted) {
        Navigator.of(context).pop(false);
      }
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Verificar si el username está disponible
      setState(() {
        _isCheckingUsername = true;
      });

      final isAvailable = await _profileService.isUsernameAvailable(newUsername);
      
      if (!isAvailable) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('El nombre de usuario "$newUsername" ya está en uso'),
              backgroundColor: destructive,
            ),
          );
        }
        return;
      }

      setState(() {
        _isCheckingUsername = false;
      });

      // Actualizar el perfil
      await _profileService.updateProfile(
        username: newUsername,
        avatarUrl: _currentAvatarUrl.isEmpty ? null : _currentAvatarUrl,
      );

      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil actualizado correctamente'),
            backgroundColor: Color(0xFF10B981),
            duration: Duration(seconds: 2),
          ),
        );
        
        // Esperar un momento para que el usuario vea el mensaje
        await Future.delayed(const Duration(milliseconds: 500));
        
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print('Error updating profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar perfil: $e'),
            backgroundColor: destructive,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _isCheckingUsername = false;
        });
      }
    }
  }

  Future<void> _changeAvatar() async {
    // Por ahora, implementación básica
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La funcionalidad de cambio de avatar estará disponible pronto'),
          backgroundColor: Color(0xFF22D3EE),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  String? _usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingresa un nombre de usuario';
    }
    
    final username = value.trim();
    
    if (username.length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }
    
    if (username.length > 20) {
      return 'El nombre no puede tener más de 20 caracteres';
    }
    
    // Validar caracteres permitidos (letras, números, guiones bajos)
    final validCharacters = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!validCharacters.hasMatch(username)) {
      return 'Solo se permiten letras, números y guiones bajos';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user = SupabaseService().currentUser;
    final userEmail = user?.email ?? 'No disponible';

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Editar Perfil',
          style: TextStyle(
            color: Color(0xFF22d3ee),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF22d3ee)),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF22d3ee),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(  // <-- Añadimos SingleChildScrollView aquí
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar Section - CENTRADO
                      Center(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
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
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: _currentAvatarUrl.isNotEmpty
                                        ? NetworkImage(_currentAvatarUrl)
                                        : const AssetImage('assets/images/avatar.png')
                                              as ImageProvider,
                                    radius: 50,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: accent,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: bg, width: 2),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.camera_alt,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      onPressed: _changeAvatar,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: _changeAvatar,
                              child: Text(
                                'Cambiar foto de perfil',
                                style: TextStyle(
                                  color: accent,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Información del usuario
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: secondary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Información de la cuenta',
                              style: TextStyle(
                                color: accent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow('Email', userEmail),
                            _buildInfoRow('Miembro desde', 
                              user?.createdAt != null 
                                ? _formatDate(DateTime.parse(user!.createdAt!))
                                : 'N/A'
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Formulario de edición
                      Text(
                        'Nombre de usuario',
                        style: TextStyle(
                          color: mutedFg,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Ingresa tu nombre de usuario',
                          hintStyle: TextStyle(color: mutedFg.withOpacity(0.6)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: accent),
                          ),
                          filled: true,
                          fillColor: secondary,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          suffixIcon: _isCheckingUsername
                              ? Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: accent,
                                  ),
                                )
                              : null,
                        ),
                        validator: _usernameValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Este nombre se mostrará en todos tus comentarios y publicaciones',
                        style: TextStyle(
                          color: mutedFg,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 12),
                      
                      // Reglas del username
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: secondary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reglas para el nombre de usuario:',
                              style: TextStyle(
                                color: accent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '• Mínimo 3 caracteres\n• Máximo 20 caracteres\n• Solo letras, números y _\n• Debe ser único',
                              style: TextStyle(
                                color: mutedFg,
                                fontSize: 11,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Botones de acción
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: mutedFg,
                                side: BorderSide(color: border),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Cancelar'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accent,
                                foregroundColor: bg,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                disabledBackgroundColor: accent.withOpacity(0.5),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Guardar',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: mutedFg,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}