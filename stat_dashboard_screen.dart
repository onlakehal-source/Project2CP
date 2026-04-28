// ignore_for_file: deprecated_member_use, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
// COULEURS
// ─────────────────────────────────────────────
class _C {
  static const scaffold     = Color(0xFFE8E0CE);
  static const accent       = Color(0xFFE07B39);
  static const cardBg       = Color(0xFFF5F0E3);
  static const textDark     = Color(0xFF2C2814);
  static const textMuted    = Color(0xFF8A8070);
  static const navBg        = Color(0xFFB5C49E);
  static const white        = Color(0xFFFFFFFF);
  static const divider      = Color(0xFFD9D0BF);
  static const appBarBg     = Color(0xFFCCD5AE);
  static const appBarBorder = Color(0xFFC8B99A);
  static const green        = Color(0xFF3B6D11);
  static const greenBg      = Color(0xFFD4EBC5);
  static const greenMid     = Color(0xFF6B7C4E);
  static const danger       = Color(0xFFA32D2D);
  static const dangerBg     = Color(0xFFFCEBEB);
  static const warningBg    = Color(0xFFFAEEDA);
  static const warningFg    = Color(0xFF854F0B);
  static const blueBg       = Color(0xFFE6F1FB);
  static const blueFg       = Color(0xFF185FA5);
}

// ─────────────────────────────────────────────
// MODÈLES
// ─────────────────────────────────────────────
class _StatData {
  final String label;
  final String value;
  final IconData icon;
  final String trend;
  final bool trendUp;
  final Color iconColor;

  const _StatData({
    required this.label,
    required this.value,
    required this.icon,
    required this.trend,
    required this.trendUp,
    required this.iconColor,
  });
}

class _BarData {
  final String jour;
  final int reservations;
  final double recettes; // DA

  const _BarData(this.jour, this.reservations, this.recettes);
}

class _TopOffre {
  final String nom;
  final int reservations;
  final double recettes;
  final double taux; // taux de retrait %

  const _TopOffre(this.nom, this.reservations, this.recettes, this.taux);
}

// ─────────────────────────────────────────────
// STAT DASHBOARD SCREEN
// ─────────────────────────────────────────────
class StatDashboardScreen extends StatefulWidget {
  const StatDashboardScreen({super.key});

  @override
  State<StatDashboardScreen> createState() =>
      _StatDashboardScreenState();
}

class _StatDashboardScreenState extends State<StatDashboardScreen> {
  int _periodeIndex = 1; // 0=Aujourd'hui 1=7 jours 2=30 jours
  int _graphIndex   = 0; // 0=Réservations 1=Recettes

  final List<String> _periodes = ["Aujourd'hui", '7 jours', '30 jours'];

  // ── Stats principales ──
  List<_StatData> get _stats => [
        _StatData(
          label: 'Réservations',
          value: _periodeIndex == 0 ? '8' : _periodeIndex == 1 ? '47' : '189',
          icon: Icons.shopping_basket_outlined,
          trend: _periodeIndex == 0 ? '+3' : _periodeIndex == 1 ? '+12%' : '+18%',
          trendUp: true,
          iconColor: _C.greenMid,
        ),
        _StatData(
          label: 'Recettes (DA)',
          value: _periodeIndex == 0
              ? '1 440'
              : _periodeIndex == 1
                  ? '8 460'
                  : '34 020',
          icon: Icons.payments_outlined,
          trend: _periodeIndex == 0 ? '+320' : _periodeIndex == 1 ? '+9%' : '+22%',
          trendUp: true,
          iconColor: _C.accent,
        ),
        _StatData(
          label: 'Taux de retrait',
          value: _periodeIndex == 0 ? '90%' : _periodeIndex == 1 ? '87%' : '91%',
          icon: Icons.check_circle_outline,
          trend: _periodeIndex == 0 ? '+5%' : _periodeIndex == 1 ? '+2%' : '+4%',
          trendUp: true,
          iconColor: _C.green,
        ),
        _StatData(
          label: 'Note moyenne',
          value: '4.8 ★',
          icon: Icons.star_border_outlined,
          trend: '+0.2',
          trendUp: true,
          iconColor: const Color(0xFFBA7517),
        ),
        _StatData(
          label: 'Offres actives',
          value: '3',
          icon: Icons.local_offer_outlined,
          trend: '=',
          trendUp: true,
          iconColor: _C.blueFg,
        ),
        _StatData(
          label: 'Vues du profil',
          value: _periodeIndex == 0 ? '24' : _periodeIndex == 1 ? '143' : '612',
          icon: Icons.visibility_outlined,
          trend: _periodeIndex == 0 ? '+4' : _periodeIndex == 1 ? '+11%' : '+28%',
          trendUp: true,
          iconColor: _C.greenMid,
        ),
      ];

  // ── Données graphique 7 jours ──
  final List<_BarData> _barsData = const [
    _BarData('Lun', 5,  900),
    _BarData('Mar', 8,  1440),
    _BarData('Mer', 6,  1080),
    _BarData('Jeu', 9,  1620),
    _BarData('Ven', 12, 2160),
    _BarData('Sam', 4,  720),
    _BarData('Dim', 3,  540),
  ];

  // ── Top offres ──
  final List<_TopOffre> _topOffres = const [
    _TopOffre('Panier boulangerie surprise', 22, 3960, 95),
    _TopOffre('Box viennoiseries',           18, 2160, 88),
    _TopOffre('Panier surprise',              7, 1120, 78),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: _C.scaffold,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _appBar()),
          SliverToBoxAdapter(child: _periodePicker()),
          SliverToBoxAdapter(child: _statsGrid()),
          SliverToBoxAdapter(child: _sectionTitle('Activité de la semaine')),
          SliverToBoxAdapter(child: _graphique()),
          SliverToBoxAdapter(child: _sectionTitle('Top offres')),
          SliverToBoxAdapter(child: _topOffresSection()),
          SliverToBoxAdapter(child: _sectionTitle('Alertes & conseils')),
          SliverToBoxAdapter(child: _alertes()),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // APP BAR
  // ─────────────────────────────────────────────
  Widget _appBar() {
    return Container(
      decoration: BoxDecoration(
        color: _C.appBarBg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _C.appBarBorder, width: 3),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 14, left: 16, right: 16,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: _C.white.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 16, color: _C.textDark),
            ),
          ),
          const Spacer(),
          const Text('Statistiques',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800,
                  color: _C.textDark)),
          const Spacer(),
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: _C.greenBg,
              shape: BoxShape.circle,
              border: Border.all(
                  color: _C.greenMid.withOpacity(0.3)),
            ),
            child: const Icon(Icons.bar_chart_outlined,
                size: 18, color: _C.greenMid),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SÉLECTEUR DE PÉRIODE
  // ─────────────────────────────────────────────
  Widget _periodePicker() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: _C.divider),
        ),
        child: Row(
          children: List.generate(_periodes.length, (i) {
            final sel = i == _periodeIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _periodeIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: sel ? _C.greenMid : Colors.transparent,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(_periodes[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: sel ? _C.white : _C.textMuted)),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // GRILLE STATS (2 colonnes)
  // ─────────────────────────────────────────────
  Widget _statsGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.55,
        ),
        itemCount: _stats.length,
        itemBuilder: (_, i) => _statCard(_stats[i]),
      ),
    );
  }

  Widget _statCard(_StatData s) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.divider.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: s.iconColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(s.icon, size: 14, color: s.iconColor),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: s.trendUp
                      ? _C.greenBg
                      : _C.dangerBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(s.trend,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: s.trendUp ? _C.green : _C.danger)),
              ),
            ],
          ),
          const Spacer(),
          Text(s.value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: _C.textDark)),
          const SizedBox(height: 2),
          Text(s.label,
              style: const TextStyle(
                  fontSize: 10.5,
                  color: _C.textMuted,
                  height: 1.3),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // GRAPHIQUE EN BARRES (7 jours)
  // ─────────────────────────────────────────────
  Widget _graphique() {
    final vals = _graphIndex == 0
        ? _barsData.map((b) => b.reservations.toDouble()).toList()
        : _barsData.map((b) => b.recettes).toList();
    final maxVal = vals.reduce((a, b) => a > b ? a : b);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _C.divider.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toggle réservations / recettes
          Row(
            children: [
              _toggleGraph(0, 'Réservations', _C.greenMid),
              const SizedBox(width: 8),
              _toggleGraph(1, 'Recettes (DA)', _C.accent),
            ],
          ),
          const SizedBox(height: 18),

          // Barres — hauteur fixe, label + valeur réservés en dehors
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Zone réservée : 14px label jour + 6px gap + 16px valeur max
                const labelH  = 14.0;
                const gapH    = 6.0;
                const valueH  = 16.0;
                final barZone = constraints.maxHeight - labelH - gapH - valueH;
                final barColor = _graphIndex == 0 ? _C.greenMid : _C.accent;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(_barsData.length, (i) {
                    final ratio  = maxVal > 0 ? vals[i] / maxVal : 0.0;
                    final isMax  = vals[i] == maxVal;
                    final barH   = (barZone * ratio).clamp(2.0, barZone);

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Valeur au-dessus — toujours présente, vide si pas max
                            SizedBox(
                              height: valueH,
                              child: isMax
                                  ? Text(
                                      _graphIndex == 0
                                          ? '${vals[i].toInt()}'
                                          : '${(vals[i] / 1000).toStringAsFixed(1)}k',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          color: barColor),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            // Barre
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOut,
                              height: barH,
                              decoration: BoxDecoration(
                                color: isMax
                                    ? barColor
                                    : barColor.withOpacity(0.35),
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(6)),
                              ),
                            ),
                            // Gap
                            const SizedBox(height: gapH),
                            // Label jour
                            SizedBox(
                              height: labelH,
                              child: Text(_barsData[i].jour,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: _C.textMuted,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleGraph(int idx, String label, Color color) {
    final sel = _graphIndex == idx;
    return GestureDetector(
      onTap: () => setState(() => _graphIndex = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: sel ? color.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: sel ? color.withOpacity(0.4) : _C.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                    color: sel ? color : _C.textMuted,
                    shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: sel ? color : _C.textMuted)),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TOP OFFRES
  // ─────────────────────────────────────────────
  Widget _topOffresSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _C.divider.withOpacity(0.6)),
      ),
      child: Column(
        children: List.generate(_topOffres.length, (i) {
          final o = _topOffres[i];
          return Column(
            children: [
              if (i > 0)
                const Divider(color: _C.divider, height: 20),
              Row(
                children: [
                  // Rang
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: i == 0
                          ? const Color(0xFFFFF8E1)
                          : _C.scaffold,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: i == 0
                              ? const Color(0xFFFFC107)
                              : _C.divider),
                    ),
                    child: Center(
                      child: Text('${i + 1}',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: i == 0
                                  ? const Color(0xFF7A5C00)
                                  : _C.textMuted)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(o.nom,
                            style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: _C.textDark),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 3),
                        // Barre de progression taux retrait
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: o.taux / 100,
                                  backgroundColor:
                                      _C.greenMid.withOpacity(0.15),
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                          _C.greenMid),
                                  minHeight: 5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text('${o.taux.toInt()}% retrait',
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: _C.textMuted,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${o.reservations} rés.',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: _C.textDark)),
                      Text('${o.recettes.toStringAsFixed(0)} DA',
                          style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: _C.accent)),
                    ],
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ALERTES & CONSEILS
  // ─────────────────────────────────────────────
  Widget _alertes() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          _alerteCard(
            Icons.trending_up_outlined,
            'Vendredi est votre meilleure journée',
            'Publiez plus d\'offres le jeudi soir pour maximiser vos ventes du vendredi.',
            _C.greenBg,
            _C.greenMid,
          ),
          const SizedBox(height: 10),
          _alerteCard(
            Icons.inventory_2_outlined,
            'Stock faible sur "Panier surprise"',
            '2 restants seulement. Pensez à augmenter la quantité disponible.',
            _C.warningBg,
            _C.warningFg,
          ),
          const SizedBox(height: 10),
          _alerteCard(
            Icons.star_border_outlined,
            'Note excellente : 4.8 ★',
            'Vous êtes dans le top 10% des commerçants de votre zone. Continuez ainsi !',
            _C.blueBg,
            _C.blueFg,
          ),
        ],
      ),
    );
  }

  Widget _alerteCard(IconData icon, String titre, String sous,
      Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: fg.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: fg.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 17, color: fg),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titre,
                    style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: fg)),
                const SizedBox(height: 4),
                Text(sous,
                    style: TextStyle(
                        fontSize: 11.5,
                        color: fg.withOpacity(0.8),
                        height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────
  Widget _sectionTitle(String titre) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Text(titre,
          style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: _C.textDark)),
    );
  }
}