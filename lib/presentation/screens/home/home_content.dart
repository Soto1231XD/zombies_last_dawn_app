import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeContent extends StatelessWidget {
  final void Function(int index) onChangeTab;

  const HomeContent({
    super.key,
    required this.onChangeTab,
  });

  Color get _bg => const Color(0xFF0B1220);
  Color get _card => const Color(0xFF121A2B);
  Color get _accent => const Color(0xFF22D3EE);
  Color get _muted => const Color(0xFFA8B3C7);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _heroBanner(context),
          const SizedBox(height: 20),

          _sectionTitle('Tu progreso', icon: Icons.insights),
          const SizedBox(height: 10),
          _statsRow(),
          const SizedBox(height: 24),

          _sectionTitle('El mundo de Last Dawn', icon: Icons.public),
          const SizedBox(height: 8),
          _loreCard(),
          const SizedBox(height: 24),

          _sectionTitle('Explora', icon: Icons.explore),
          const SizedBox(height: 12),
          _exploreRow(),
          const SizedBox(height: 24),

          _sectionTitle('Personajes y arsenal', icon: Icons.groups),
          const SizedBox(height: 12),
          _horizontalCardsCharactersAndWeapons(),
          const SizedBox(height: 24),

          _sectionTitle('Últimas actualizaciones', icon: Icons.update),
          const SizedBox(height: 12),
          _updateCard(
            title: 'Versión 1.3 — “Ecos del Amanecer”',
            description:
                '• Nuevas misiones nocturnas\n• Ajustes de balance en zombies corredores\n• Mejora de rendimiento en dispositivos de gama media',
          ),
          const SizedBox(height: 8),
          _updateCard(
            title: 'Versión 1.2 — “Zona Roja”',
            description:
                '• Nuevo tipo de enemigo: Tanke\n• Sistema de botín mejorado\n• Corrección de errores visuales en el mapa',
          ),
          const SizedBox(height: 32),

          Center(
            child: Text(
              '"Sobrevive la noche. Gana el amanecer."',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _muted,
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
            ),
          ).animate().fadeIn(duration: 800.ms).slide(begin: const Offset(0, 0.1)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ---------------- HERO ----------------

  Widget _heroBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF22D3EE), Color(0xFF0B1220)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image: const DecorationImage(
          image: AssetImage('assets/images/banner_zombies.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black54,
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 18,
            top: 18,
            right: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ZOMBIES: LAST DAWN',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sobrevive al amanecer eterno.\nGestiona tu refugio, tus armas y tu equipo.',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 18,
            bottom: 18,
            right: 18,
            child: Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _primaryButton(
                      label: 'Publicaciones',
                      icon: Icons.article_outlined,
                      onTap: () => onChangeTab(1), // 👉 ir a pestaña Publicaciones
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _secondaryButton(
                      label: 'Categorías',
                      icon: Icons.category_outlined,
                      onTap: () => onChangeTab(2), // 👉 ir a pestaña Categorías
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 900.ms).slide(begin: const Offset(0, -0.15));
  }

  Widget _primaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF0B1220)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF0B1220),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secondaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- SECCIÓN TITULO ----------------

  Widget _sectionTitle(String text, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: _accent, size: 18),
          const SizedBox(width: 6),
        ],
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFFE5E7EB),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ---------------- STATS ----------------

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            label: 'Misiones',
            value: '24',
            icon: Icons.flag,
            color: const Color(0xFF38BDF8),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            label: 'Zombies',
            value: '1.2K',
            icon: Icons.bug_report,
            color: const Color(0xFFF97316),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            label: 'Logros',
            value: '12',
            icon: Icons.emoji_events,
            color: const Color(0xFFA855F7),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: _muted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- LORE CARD ----------------

  Widget _loreCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Tras el “Amanecer Rojo”, las ciudades colapsaron. Los pocos refugios que quedan dependen de exploradores como tú para conseguir recursos, proteger a la gente y descubrir qué originó el brote.',
            style: TextStyle(
              color: Color(0xFFA8B3C7),
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 12),
          Text(
            'En Last Dawn no sólo sobrevives: construyes historias en cada misión.',
            style: TextStyle(
              color: Color(0xFF22D3EE),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 700.ms).slide(begin: const Offset(0, 0.08));
  }

  // ---------------- EXPLORA ROW ----------------

  Widget _exploreRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _exploreChip(
          icon: Icons.groups,
          title: 'Personajes',
          subtitle: 'Descubre sus roles y habilidades.',
        ),
        const SizedBox(width: 10),
        _exploreChip(
          icon: Icons.security,
          title: 'Defensas',
          subtitle: 'Mejora tu refugio y barricadas.',
        ),
        const SizedBox(width: 10),
        _exploreChip(
          icon: Icons.forum_outlined,
          title: 'Comunidad',
          subtitle: 'Comparte ideas en el foro.',
        ),
      ],
    );
  }

  Widget _exploreChip({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 110,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: _accent, size: 20),
            const SizedBox(height: 10),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFE5E7EB),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: _muted,
                fontSize: 12,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- HORIZONTAL CARDS ----------------

  Widget _horizontalCardsCharactersAndWeapons() {
    return SizedBox(
      height: 190,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _imageCard(
            title: 'John – Explorador',
            subtitle: 'Rápido y sigiloso, ideal para escaramuzas.',
            imagePath: 'assets/images/survivor.png',
          ),
          _imageCard(
            title: 'Médico táctico',
            subtitle: 'Mantiene al escuadrón con vida en plena horda.',
            imagePath: 'assets/images/curandero.png',
          ),
          _imageCard(
            title: 'Escopeta',
            subtitle: 'Control brutal a corta distancia.',
            imagePath: 'assets/images/escopeta.png',
          ),
          _imageCard(
            title: 'Rifle de francotirador',
            subtitle: 'Precisión a larga distancia para eliminar amenazas clave.',
            imagePath: 'assets/images/sniper.png',
          ),
          _imageCard(
            title: 'Zombie común',
            subtitle: 'Lento, pero letal en grandes grupos.',
            imagePath: 'assets/images/zombie-normal.png',
          ),
          _imageCard(
            title: 'Zombie corredor',
            subtitle: 'Rápido y agresivo, difícil de contener.',
            imagePath: 'assets/images/sprinter.png',
          ),
          _imageCard(
            title: 'Tanke',
            subtitle: 'Resistente, cada bala cuenta cuando aparece.',
            imagePath: 'assets/images/Tank.png',
          ),
        ],
      ),
    ).animate().fadeIn(duration: 900.ms).slide(begin: const Offset(0, 0.08));
  }

  Widget _imageCard({
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFE5E7EB),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: _muted,
              fontSize: 11,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ---------------- UPDATE CARDS ----------------

  Widget _updateCard({required String title, required String description}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.fiber_new, color: Color(0xFF22D3EE), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFE5E7EB),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
