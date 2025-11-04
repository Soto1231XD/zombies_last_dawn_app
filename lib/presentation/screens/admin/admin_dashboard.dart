import 'package:flutter/material.dart';
import 'package:zombies_last_dawn_app/services/supabase_service.dart';
import 'package:zombies_last_dawn_app/services/category_service.dart';
import 'package:zombies_last_dawn_app/core/models/category_model.dart';

import 'categories_admin_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final SupabaseService _supabaseService = SupabaseService();
  final CategoryService _categoryService = CategoryService();
  bool _isLoading = true;

  Map<String, dynamic> _stats = {
    'totalUsers': 0,
    'totalAdmins': 0,
    'totalPosts': 0,
    'totalCategories': 0,
    'activeToday': 0,
  };
  
  List<Map<String, dynamic>> _recentUsers = [];
  List<Map<String, dynamic>> _recentPosts = [];
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final stats = await _supabaseService.getAdminStats();
      final users = await _supabaseService.getAllUsersDetailed();
      final posts = await _supabaseService.getPostsWithAuthors();
      final categories = await _categoryService.getCategories();
      
      if (!mounted) return;
      
      setState(() {
        _stats = stats;
        _stats['totalCategories'] = categories.length;
        _recentUsers = users.take(5).toList();
        _recentPosts = posts.take(5).toList();
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading admin dashboard: $e');
      
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await _supabaseService.signOut();
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

  void _navigateToCategoriesAdmin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CategoriesAdminScreen()),
    ).then((_) {
      if (mounted) {
        _loadDashboardData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F16),
      appBar: AppBar(
        title: const Text(
          'Panel de Administración',
          style: TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF141A22),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.greenAccent),
            onPressed: _loadDashboardData,
            tooltip: 'Actualizar datos',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: _signOut,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: _isLoading ? _buildLoading() : _buildDashboard(),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Colors.greenAccent,
          ),
          const SizedBox(height: 20),
          Text(
            'Cargando dashboard...',
            style: TextStyle(
              color: Colors.greenAccent,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsGrid(),
          const SizedBox(height: 30),

          _buildSectionTitle('Gestión Rápida'),
          const SizedBox(height: 16),
          _buildQuickActions(),

          const SizedBox(height: 30),

          _buildSectionTitle('Categorías Existentes (${_categories.length})'),
          const SizedBox(height: 16),
          _categories.isEmpty 
              ? _buildEmptyState('No hay categorías creadas')
              : _buildCategoriesPreview(),

          const SizedBox(height: 30),

          _buildSectionTitle('Usuarios Recientes (${_recentUsers.length})'),
          const SizedBox(height: 16),
          _recentUsers.isEmpty 
              ? _buildEmptyState('No hay usuarios registrados') 
              : _buildRecentUsers(),

          const SizedBox(height: 30),

          _buildSectionTitle('Publicaciones Recientes (${_recentPosts.length})'),
          const SizedBox(height: 16),
          _recentPosts.isEmpty 
              ? _buildEmptyState('No hay publicaciones') 
              : _buildRecentPosts(),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildStatCard(
          'Total Usuarios', 
          _stats['totalUsers'].toString(), 
          Icons.people, 
          Colors.greenAccent
        ),
        _buildStatCard(
          'Usuarios Activos Hoy', 
          _stats['activeToday'].toString(), 
          Icons.trending_up, 
          Colors.blueAccent
        ),
        _buildStatCard(
          'Total Administradores', 
          _stats['totalAdmins'].toString(), 
          Icons.admin_panel_settings, 
          Colors.orangeAccent
        ),
        _buildStatCard(
          'Total Publicaciones', 
          _stats['totalPosts'].toString(), 
          Icons.article, 
          Colors.purpleAccent
        ),
        _buildStatCard(
          'Total Categorías', 
          _stats['totalCategories'].toString(), 
          Icons.category, 
          Colors.cyanAccent,
          onTap: _navigateToCategoriesAdmin,
        ),
        _buildManagementCard(),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF141A22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementCard() {
    return GestureDetector(
      onTap: _navigateToCategoriesAdmin,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyanAccent.withOpacity(0.15), Colors.black.withOpacity(0.4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.4), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.settings, color: Colors.cyanAccent, size: 30),
            const SizedBox(height: 8),
            Text(
              'Gestionar',
              style: TextStyle(
                color: Colors.cyanAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Categorías',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141A22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickActionButton(
            'Gestionar Categorías',
            Icons.category,
            Colors.cyanAccent,
            _navigateToCategoriesAdmin,
          ),
          _buildQuickActionButton(
            'Gestionar Usuarios',
            Icons.people,
            Colors.orangeAccent,
            () => _showComingSoon('Gestión de Usuarios'),
          ),
          _buildQuickActionButton(
            'Gestionar Posts',
            Icons.article,
            Colors.purpleAccent,
            () => _showComingSoon('Gestión de Posts'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30),
          color: color,
          onPressed: onTap,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontFamily: 'Poppins',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCategoriesPreview() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141A22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          ..._categories.take(3).map((category) => _buildCategoryPreviewItem(category)),
          if (_categories.length > 3) ...[
            const Divider(color: Colors.grey, height: 1),
            ListTile(
              leading: const Icon(Icons.more_horiz, color: Colors.greenAccent),
              title: Text(
                'Ver todas las categorías (${_categories.length})',
                style: const TextStyle(color: Colors.greenAccent),
              ),
              trailing: const Icon(Icons.arrow_forward, color: Colors.greenAccent),
              onTap: _navigateToCategoriesAdmin,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryPreviewItem(Category category) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: category.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: category.imageUrl != null && category.imageUrl!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    category.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(category.icon, color: category.color, size: 20);
                    },
                  ),
                )
              : Icon(category.icon, color: category.color, size: 20),
        ),
        title: Text(
          category.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: category.description != null 
            ? Text(
                category.description!,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: const Icon(Icons.arrow_forward, color: Colors.greenAccent),
        onTap: _navigateToCategoriesAdmin,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.greenAccent,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF141A22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.info_outline, color: Colors.grey, size: 50),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentUsers() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141A22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: Column(
        children: _recentUsers.map((user) => _buildUserItem(user)).toList(),
      ),
    );
  }

  Widget _buildUserItem(Map<String, dynamic> user) {
    final username = user['username'] ?? 'Usuario';
    final role = user['role'] ?? 'user';
    final createdAt = user['created_at'];
    final isAdmin = role == 'admin';

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isAdmin ? Colors.orangeAccent : Colors.greenAccent,
          child: Text(
            username.toString().substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          username.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rol: $role',
              style: TextStyle(
                color: isAdmin ? Colors.orangeAccent : Colors.greenAccent,
                fontSize: 12,
              ),
            ),
            Text(
              'Registrado: ${_formatDate(createdAt)}',
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
        trailing: Icon(
          isAdmin ? Icons.admin_panel_settings : Icons.person,
          color: isAdmin ? Colors.orangeAccent : Colors.greenAccent,
        ),
      ),
    );
  }

  Widget _buildRecentPosts() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141A22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
      ),
      child: Column(
        children: _recentPosts.map((post) => _buildPostItem(post)).toList(),
      ),
    );
  }

  Widget _buildPostItem(Map<String, dynamic> post) {
    final title = post['title'] ?? 'Sin título';
    final author = post['profiles']?['username'] ?? 'Anónimo';
    final createdAt = post['created_at'];
    final content = post['content'] ?? '';

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        leading: const Icon(Icons.article, color: Colors.greenAccent),
        title: Text(
          title.toString(),
          style: const TextStyle(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Por: $author',
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              content.length > 50 ? '${content.substring(0, 50)}...' : content,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
              maxLines: 1,
            ),
            Text(
              _formatDate(createdAt),
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays == 0) {
        return 'Hoy';
      } else if (difference.inDays == 1) {
        return 'Ayer';
      } else if (difference.inDays < 7) {
        return 'Hace ${difference.inDays} días';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'Fecha inválida';
    }
  }

  void _showComingSoon(String feature) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Próximamente'),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}