// ─────────────────────────────────────────────
//  PROFIL CLIENT — Laaisfraf
//  Route : '/profil_client'
//  Position bottom nav : index 4 (icône person)
// ─────────────────────────────────────────────
// ignore_for_file: sized_box_for_whitespace, unused_element, dead_code, non_constant_identifier_names, unused_field, deprecated_member_use

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
// COULEURS — alignées sur le projet
// ─────────────────────────────────────────────
class _C {
  static const scaffold   = Color(0xFFE8E0CE);
  static const accent     = Color(0xFFE07B39);
  static const accentBg   = Color(0xFFFAEEDA);
  static const cardBg     = Color(0xFFF5F0E3);
  static const textDark   = Color(0xFF2C2814);
  static const textMuted  = Color(0xFF8A8070);
  static const navBg      = Color(0xFFB5C49E);
  static const greenMid   = Color(0xFF6B7C4E);
  static const greenBg    = Color(0xFFD4EBC5);
  static const white      = Color(0xFFFFFFFF);
  static const divider    = Color(0xFFD9D0BF);
  static const danger     = Color(0xFFA32D2D);
  static const dangerBg   = Color(0xFFFCEBEB);
  static const headerBg   = Color(0xFFCCD5AE);
}

// ─────────────────────────────────────────────
// ÉCRAN
// ─────────────────────────────────────────────
class ProfilClientScreen extends StatefulWidget {
  const ProfilClientScreen({super.key});

  @override
  State<ProfilClientScreen> createState() => _ProfilClientScreenState();
}

class _ProfilClientScreenState extends State<ProfilClientScreen> {

  // ── Données fictives (remplacer par modèle/API) ──
  final String _nom            = 'Sofiane Kadi';
  final String _email          = 'sofiane.kadi8@gmail.com';
  final String _adresse        = 'Kouba, Alger';
  final int    _nbReservations = 12;
  final int    _nbFavoris      = 8;
  final String _economise      = '2 140 DA';
  

  // chemin asset ou null → initiales
 // chemin asset ou null → initiales
  bool _notifActives = true;
   
   
    
     
       Null get _demo => null;
  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
     
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 250, 237, 205),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _hero()),
          SliverToBoxAdapter(child: _carteStats()),
          SliverToBoxAdapter(child: _carteEconomies()),
          SliverToBoxAdapter(child: _sectionCompte()),
          SliverToBoxAdapter(child: _sectionAide()),
          SliverToBoxAdapter(child: _boutonsActions()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  // ─────────────────────────────────────────────
  // HERO — En-tête avec avatar, nom, email, badge
  // ─────────────────────────────────────────────
   Widget _hero() {
    
 
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.divider.withOpacity(0.6)),
      ),
      child: Column(
        children: [
          // Logo
                 
          const SizedBox(height: 100),
 
           // Avatar
          Stack(
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: _C.divider,
                  shape: BoxShape.circle,
                  border: Border.all(color: _C.white, width:0.5),
                ),
 
                child: const Icon(Icons.person_outline_rounded,
                    size: 42, color: _C.textDark),
              ),
              Positioned(
                bottom: 0, right: 0,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 26, height: 26,
                    
                    
                  ),
                ),
              ),
            ],
          ),
         
 
          // Nom
          Text(_nom,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: _C.textDark)),
          const SizedBox(height: 3),
 
          // Email
          Text(_email,
              style: const TextStyle(
                  fontSize: 12.5, color: _C.textMuted)),
          const SizedBox(height: 10),
 
          // Badge "Profil client"
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: _C.accent.withOpacity(0.13),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _C.accent.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.person_outline_rounded,
                    size: 13, color: _C.accent),
                SizedBox(width: 5),
                Text('Profil client',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _C.accent)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CARTE STATS — Réservations / Favoris
  // ─────────────────────────────────────────────
  Widget _carteStats() {
    return Container(
      margin: const EdgeInsets.fromLTRB(60, 10, 60, 5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 250, 237, 205),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _C.greenMid.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          _statItem('$_nbReservations', 'Réservations',
              Icons.shopping_bag_outlined),
          Container(width: 10, height: 70, color: const Color.fromARGB(255, 244, 234, 224)),
          _statItem('$_nbFavoris', 'Favoris',
              Icons.favorite_border_rounded),
        ],
      ),
    );
  }

  Widget _statItem(String val, String label, IconData icon) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Text(val,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 255, 183, 135))),
            const SizedBox(height: 3),
            Text(label,
                style: const TextStyle(
                    fontSize: 11.5, color: _C.textMuted)),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CARTE ÉCONOMIES
  // ─────────────────────────────────────────────
  Widget _carteEconomies() {
    return Container(
      margin: const EdgeInsets.fromLTRB(60, 10, 60, 0),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 250, 237, 205),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _C.greenMid.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(_economise,
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 251, 191, 151))),
          const SizedBox(height: 3),
          const Text('Économisés',
              style: TextStyle(fontSize: 12, color: _C.textMuted)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SECTION COMPTE
  // ─────────────────────────────────────────────
  Widget _sectionCompte() {
    return _carte(
      titre: 'Compte',
      enfants: [
        _ligneParam(
          Icons.location_on_outlined,
          'Mon adresse',
          subtitle: _adresse,
          onTap: () => Navigator.pushNamed(context, '/acces_rapide'),
        ),
        _ligneParam(
          Icons.notifications_outlined,
          'Notifications',
          trailing: Transform.scale(
            scale: 0.8,
            child: Switch(
              value: _notifActives,
              onChanged: (v) => setState(() => _notifActives = v),
              activeColor: _C.accent,
            ),
          ),
        ),
        _ligneParam(
          Icons.lock_outline,
          'Sécurité',
          onTap: () {},
          isLast: true,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // SECTION AIDE
  // ─────────────────────────────────────────────
  Widget _sectionAide() {
    return _carte(
      titre: 'Aide',
      enfants: [
        _ligneParam(
          Icons.help_outline_rounded,
          'Aide à support',
          onTap: () {},
        ),
        _ligneParam(
          Icons.description_outlined,
          'Conditions d\'utilisation',
          onTap: () {},
        ),
        _ligneParam(
          Icons.security_outlined,
          'Sécurité',
          onTap: () {},
          isLast: true,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // BOUTONS SE DÉCONNECTER + SUPPRIMER
  // ─────────────────────────────────────────────
  Widget _boutonsActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          // Se déconnecter
          _boutonAction(
            label: 'Se déconnecter',
            icon: Icons.logout_outlined,
            color: _C.accent,
            bg: _C.accentBg,
            borderColor: _C.accent.withOpacity(0.3),
            onTap: _confirmerDeconnexion,
          ),
          const SizedBox(height: 10),

          // Supprimer mon compte
          _boutonAction(
            label: 'Supprimer mon compte',
            icon: Icons.delete_outline_rounded,
            color: _C.danger,
            bg: _C.dangerBg,
            borderColor: _C.danger.withOpacity(0.3),
            onTap: _confirmerSuppression,
          ),
        ],
      ),
    );
  }

  Widget _boutonAction({
    required String label,
    required IconData icon,
    required Color color,
    required Color bg,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: color)),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BOTTOM NAV — identique HomeClientScreen
  // ─────────────────────────────────────────────
  Widget _bottomNav() {
    final icons = [
      Icons.favorite_border,
      Icons.search,
      Icons.home_outlined,
      Icons.shopping_bag_outlined,
      Icons.person_outline,
    ];
    const int selectedIndex = 4;

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      height: 62,
      decoration: BoxDecoration(
        color: _C.navBg,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (i) {
          final bool sel = i == selectedIndex;
          return GestureDetector(
            onTap: () {
              if (i == 0) Navigator.pushNamed(context, '/acces_rapide');
              if (i == 1) Navigator.pushNamed(context, '/carte');
              if (i == 2) Navigator.pushReplacementNamed(context, '/home_client');
              if (i == 3) Navigator.pushReplacementNamed(context, '/reservations');
              // i == 4 : déjà ici
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: sel ? _C.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icons[i],
                size: 22,
                color: sel
                    ? _C.textDark
                    : _C.textDark.withOpacity(0.55),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HELPERS WIDGETS
  // ─────────────────────────────────────────────
  Widget _carte({
    required String titre,
    required List<Widget> enfants,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _C.divider.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titre,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: _C.textDark)),
          const SizedBox(height: 14),
          ...enfants,
        ],
      ),
    );
  }

  Widget _ligneParam(
    IconData icon,
    String label, {
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 12 : 14),
        child: Row(
          children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: _C.scaffold,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: _C.divider),
              ),
              child: Icon(icon, size: 16, color: _C.textDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _C.textDark)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 11.5, color: _C.textMuted)),
                  ],
                ],
              ),
            ),
            trailing ??
                const Icon(Icons.arrow_forward_ios,
                    size: 13, color: _C.textMuted),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ACTIONS
  // ─────────────────────────────────────────────
  void _ouvrirEdition() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Modification du profil — à venir'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _confirmerDeconnexion() {
    _showConfirmSheet(
      icon: Icons.logout_outlined,
      iconColor: _C.accent,
      iconBg: _C.accentBg,
      titre: 'Se déconnecter ?',
      corps: 'Vous devrez vous reconnecter pour accéder à votre espace.',
      labelConfirm: 'Déconnecter',
      couleurConfirm: _C.accent,
      onConfirm: () {
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(
            context, '/choix_compte', (_) => false);
      },
    );
  }

  void _confirmerSuppression() {
    _showConfirmSheet(
      icon: Icons.delete_outline_rounded,
      iconColor: _C.danger,
      iconBg: _C.dangerBg,
      titre: 'Supprimer le compte ?',
      corps:
          'Cette action est irréversible. Toutes vos données seront effacées définitivement.',
      labelConfirm: 'Supprimer',
      couleurConfirm: _C.danger,
      onConfirm: () {
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(
            context, '/choix_compte', (_) => false);
      },
    );
  }

  void _showConfirmSheet({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String titre,
    required String corps,
    required String labelConfirm,
    required Color couleurConfirm,
    required VoidCallback onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20,
            MediaQuery.of(context).padding.bottom + 20),
        decoration: const BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Poignée
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: _C.divider,
                  borderRadius: BorderRadius.circular(2)),
            ),
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                  color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, size: 26, color: iconColor),
            ),
            const SizedBox(height: 14),
            Text(titre,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _C.textDark)),
            const SizedBox(height: 8),
            Text(corps,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13, color: _C.textMuted, height: 1.5)),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: _C.scaffold,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: _C.divider),
                      ),
                      child: const Center(
                        child: Text('Annuler',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: _C.textDark)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: couleurConfirm,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(labelConfirm,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: _C.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}