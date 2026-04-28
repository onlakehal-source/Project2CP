// ─────────────────────────────────────────────
//  FILTRES AVANCÉS
//  Accessible via showModalBottomSheet depuis la Search Bar
//
//  USAGE dans HomeClientScreen :
//    final result = await ouvrirFiltres(context, _filtres);
//    if (result != null) setState(() => _filtres = result);
//
// ─────────────────────────────────────────────
// ignore_for_file: unused_field, deprecated_member_use

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// COULEURS
// ─────────────────────────────────────────────
class _C {
  static const bg       = Color(0xFFEFEAD8);
  static const card     = Color(0xFFF5F0E3);
  static const accent   = Color(0xFFE07B39);
  static const accentBg = Color(0xFFFAEEDA);
  static const textDark = Color(0xFF2C2814);
  static const textMut  = Color(0xFF8A8070);
  static const divider  = Color(0xFFD9D0BF);
  static const chip     = Color(0xFFE4DEC8);
  static const chipSel  = Color(0xFFB5C49E);
  static const chipSelTxt = Color(0xFF2C2814);
  static const green    = Color(0xFF6B7C4E);
}

// ─────────────────────────────────────────────
// MODÈLE RÉSULTAT — retourné via Navigator.pop
// ─────────────────────────────────────────────
class FiltreResultat {
  final Set<String> categories;
  final double      distance;
  final RangeValues prix;
  final RangeValues creneau;
  final Set<String> dispos;
  final double?     noteMin;
  final Set<String> services;
  final Set<String> paiements;
  final Set<String> alimentaires;

  const FiltreResultat({
    required this.categories,
    required this.distance,
    required this.prix,
    required this.creneau,
    required this.dispos,
    this.noteMin,
    required this.services,
    required this.paiements,
    required this.alimentaires,
  });

  /// Nombre de filtres actifs → utilisé pour le badge
  int get nbActifs =>
      categories.length +
      dispos.length +
      services.length +
      paiements.length +
      alimentaires.length +
      (noteMin != null ? 1 : 0) +
      (distance < 10 ? 1 : 0) +
      (prix != const RangeValues(100, 1000) ? 1 : 0) +
      (creneau != const RangeValues(6, 23) ? 1 : 0);

  /// État initial (aucun filtre actif)
  static FiltreResultat vide() => FiltreResultat(
    categories:   {},
    distance:     10.0,
    prix:         const RangeValues(100, 1000),
    creneau:      const RangeValues(6, 23),
    dispos:       {},
    noteMin:      null,
    services:     {},
    paiements:    {},
    alimentaires: {},
  );
}

// ─────────────────────────────────────────────
// HELPER — ouvrir le filtre depuis n'importe où
//
//   final result = await ouvrirFiltres(context, _filtres);
//   if (result != null) setState(() => _filtres = result);
// ─────────────────────────────────────────────
Future<FiltreResultat?> ouvrirFiltres(
  BuildContext context,
  FiltreResultat filtresActuels,
) {
  return showModalBottomSheet<FiltreResultat>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => FiltreScreen(initial: filtresActuels),
  );
}

// ─────────────────────────────────────────────
// BADGE BOUTON — à placer dans la Search Bar
//
//   FiltreBadgeButton(
//     nbActifs: _filtres.nbActifs,
//     onTap: () async {
//       final r = await ouvrirFiltres(context, _filtres);
//       if (r != null) setState(() => _filtres = r);
//     },
//   )
// ─────────────────────────────────────────────
class FiltreBadgeButton extends StatelessWidget {
  final int          nbActifs;
  final VoidCallback onTap;

  const FiltreBadgeButton({
    super.key,
    required this.nbActifs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: nbActifs > 0 ? _C.accentBg : _C.chip,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: nbActifs > 0
                    ? _C.accent.withOpacity(0.45)
                    : _C.divider,
              ),
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 19,
              color: nbActifs > 0 ? _C.accent : _C.textMut,
            ),
          ),
          if (nbActifs > 0)
            Positioned(
              right: -5, top: -5,
              child: Container(
                width: 17, height: 17,
                decoration: const BoxDecoration(
                  color: _C.accent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$nbActifs',
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FILTRE SCREEN
// ─────────────────────────────────────────────
class FiltreScreen extends StatefulWidget {
  /// Filtres déjà actifs — pré-remplit l'état au démarrage.
  /// Si null → aucun filtre actif (état vide).
  final FiltreResultat? initial;

  const FiltreScreen({super.key, this.initial});

  @override
  State<FiltreScreen> createState() => _FiltreScreenState();
}

class _FiltreScreenState extends State<FiltreScreen> {

  // ── Listes fixes ──
  final List<String> _categories = [
    'Boulangerie', 'Restaurant', 'Pâtisserie',
    'Boucherie', 'Épicerie', 'Café',
  ];
  final List<String> _dispos = [
    'Disponible maintenant', 'Ce soir',
    'Demain matin', 'Ce week-end',
  ];
  final List<String> _servicesOptions = [
    'À emporter', 'Livraison disponible',
  ];
  final List<String> _paiementsOptions = [
    'En ligne', 'Main à main',
  ];
  final List<String> _alimentaires = [
    'Sans gluten', 'Sans lactose', 'Sans sucre',
    'Végétarien', 'Healthy',
  ];

  // ── État — initialisé depuis widget.initial dans initState ──
  late Set<String>  _catsSelectionnees;
  late double       _distance;
  late RangeValues  _prix;
  late RangeValues  _creneau;
  late Set<String>  _disposSelectionnees;
  late double?      _noteMin;
  late Set<String>  _services;
  late Set<String>  _paiements;
  late Set<String>  _alimentairesSelectionnees;

  @override
  void initState() {
    super.initState();
    final i = widget.initial ?? FiltreResultat.vide();
    _catsSelectionnees         = Set.from(i.categories);
    _distance                  = i.distance;
    _prix                      = i.prix;
    _creneau                   = i.creneau;
    _disposSelectionnees       = Set.from(i.dispos);
    _noteMin                   = i.noteMin;
    _services                  = Set.from(i.services);
    _paiements                 = Set.from(i.paiements);
    _alimentairesSelectionnees = Set.from(i.alimentaires);
  }

  // ─────────────────────────────────────────────
  // BUILD — Material requis pour Slider / RangeSlider
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.94,
        ),
        decoration: const BoxDecoration(
          color: _C.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
        children: [
          // Poignée
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              decoration: BoxDecoration(
                color: _C.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          _appBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionCategories(),
                  _separateur(),
                  _sectionDistance(),
                  _separateur(),
                  _sectionPrix(),
                  _separateur(),
                  _sectionCreneau(),
                  _separateur(),
                  _sectionDisponibilite(),
                  _separateur(),
                  _sectionNote(),
                  _separateur(),
                  _sectionService(),
                  _separateur(),
                  _sectionPaiement(),
                  _separateur(),
                  _sectionAlimentaires(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          _boutonResultats(),
        ],
      ),
    ), // Container
    ); // Material
  }

  // ─────────────────────────────────────────────
  // APP BAR
  // ─────────────────────────────────────────────
  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios,
                size: 18, color: _C.textDark),
          ),
          const Spacer(),
          const Text('Filtres',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _C.textDark)),
          const Spacer(),
          // Réinitialiser
          GestureDetector(
            onTap: _reinitialiser,
            child: const Text('Réinitialiser',
                style: TextStyle(
                    fontSize: 13,
                    color: _C.textMut,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CATÉGORIES
  // ─────────────────────────────────────────────
  Widget _sectionCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titreSec('Catégories'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((c) {
            final sel = _catsSelectionnees.contains(c);
            return _chip(c, sel,
                () => setState(() => sel
                    ? _catsSelectionnees.remove(c)
                    : _catsSelectionnees.add(c)));
          }).toList(),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // DISTANCE
  // ─────────────────────────────────────────────
  Widget _sectionDistance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titreSec('Distance maximale'),
        const SizedBox(height: 8),
        Center(
          child: Text(
            '${_distance.toInt()} Km',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _C.textDark),
          ),
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: _sliderTheme(),
          child: Slider(
            value: _distance,
            min: 1, max: 10, divisions: 9,
            onChanged: (v) =>
                setState(() => _distance = v),
          ),
        ),
        _labelsAxe(['1Km', '5Km', '10Km']),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // FOURCHETTE DE PRIX
  // ─────────────────────────────────────────────
  Widget _sectionPrix() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titreSec('Fourchette de prix'),
        const SizedBox(height: 8),
        Center(
          child: Text(
            '${_prix.start.toInt()}Da  -  ${_prix.end.toInt()}Da',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _C.textDark),
          ),
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: _rangeSliderTheme(),
          child: RangeSlider(
            values: _prix,
            min: 100, max: 1000, divisions: 18,
            onChanged: (v) =>
                setState(() => _prix = v),
          ),
        ),
        _labelsAxe(['100 Da', '500Da', '1000Da']),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // CRÉNEAU DE RETRAIT
  // ─────────────────────────────────────────────
  Widget _sectionCreneau() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titreSec('Créneaux de retrait'),
        const SizedBox(height: 8),
        Center(
          child: Text(
            '${_creneau.start.toInt()}h  -  ${_creneau.end.toInt()}h',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _C.textDark),
          ),
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: _rangeSliderTheme(),
          child: RangeSlider(
            values: _creneau,
            min: 6, max: 23, divisions: 17,
            onChanged: (v) =>
                setState(() => _creneau = v),
          ),
        ),
        _labelsAxe(['6h', '14h', '23h']),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // DISPONIBILITÉ
  // ─────────────────────────────────────────────
  Widget _sectionDisponibilite() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.access_time_outlined,
                size: 16, color: _C.textDark),
            const SizedBox(width: 6),
            _titreSec('Disponibilité'),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _dispos.map((d) {
            final sel = _disposSelectionnees.contains(d);
            return _chip(d, sel,
                () => setState(() => sel
                    ? _disposSelectionnees.remove(d)
                    : _disposSelectionnees.add(d)));
          }).toList(),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // NOTE MINIMALE
  // ─────────────────────────────────────────────
  Widget _sectionNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.star_border_outlined,
                size: 16, color: _C.textDark),
            const SizedBox(width: 6),
            _titreSec('Note minimale'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [3.0, 4.0, 4.5].map((note) {
            final sel = _noteMin == note;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() =>
                    _noteMin = sel ? null : note),
                child: AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? _C.chipSel : _C.chip,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star,
                          size: 14,
                          color: sel
                              ? _C.textDark
                              : _C.textMut),
                      const SizedBox(width: 4),
                      Text('+$note',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: sel
                                  ? _C.textDark
                                  : _C.textMut)),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // SERVICE
  // ─────────────────────────────────────────────
  Widget _sectionService() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.delivery_dining_outlined,
                size: 16, color: _C.textDark),
            const SizedBox(width: 6),
            _titreSec('Service'),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _servicesOptions.map((s) {
            final sel = _services.contains(s);
            return _chip(s, sel,
                () => setState(() => sel
                    ? _services.remove(s)
                    : _services.add(s)));
          }).toList(),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // PAIEMENT
  // ─────────────────────────────────────────────
  Widget _sectionPaiement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.payment_outlined,
                size: 16, color: _C.textDark),
            const SizedBox(width: 6),
            _titreSec('Type de paiement'),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _paiementsOptions.map((p) {
            final sel = _paiements.contains(p);
            return _chip(p, sel,
                () => setState(() => sel
                    ? _paiements.remove(p)
                    : _paiements.add(p)));
          }).toList(),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // FILTRES ALIMENTAIRES
  // ─────────────────────────────────────────────
  Widget _sectionAlimentaires() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.tune_outlined,
                size: 16, color: _C.textDark),
            const SizedBox(width: 6),
            _titreSec('Filtres alimentaires'),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _alimentaires.map((a) {
            final sel =
                _alimentairesSelectionnees.contains(a);
            return _chip(a, sel,
                () => setState(() => sel
                    ? _alimentairesSelectionnees.remove(a)
                    : _alimentairesSelectionnees.add(a)));
          }).toList(),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // BOUTON VOIR LES RÉSULTATS
  // Retourne un FiltreResultat à l'appelant
  // ─────────────────────────────────────────────
  Widget _boutonResultats() {
    final nb = _nbFiltresActifs();
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20,
          MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: _C.bg,
        border: Border(
            top: BorderSide(
                color: _C.divider.withOpacity(0.4))),
      ),
      child: GestureDetector(
        onTap: _valider,
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: _C.accent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: _C.accent.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              nb > 0
                  ? 'Voir les résultats ($nb filtres)'
                  : 'Voir les résultats',
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // VALIDER — retourne le résultat à l'appelant
  // ─────────────────────────────────────────────
  void _valider() {
    Navigator.pop(
      context,
      FiltreResultat(
        categories:   Set.from(_catsSelectionnees),
        distance:     _distance,
        prix:         _prix,
        creneau:      _creneau,
        dispos:       Set.from(_disposSelectionnees),
        noteMin:      _noteMin,
        services:     Set.from(_services),
        paiements:    Set.from(_paiements),
        alimentaires: Set.from(_alimentairesSelectionnees),
      ),
    );
  }

  int _nbFiltresActifs() =>
      _catsSelectionnees.length +
      _disposSelectionnees.length +
      _services.length +
      _paiements.length +
      _alimentairesSelectionnees.length +
      (_noteMin != null ? 1 : 0) +
      (_distance < 10 ? 1 : 0) +
      (_prix != const RangeValues(100, 1000) ? 1 : 0) +
      (_creneau != const RangeValues(6, 23) ? 1 : 0);

  // ─────────────────────────────────────────────
  // RÉINITIALISER
  // ─────────────────────────────────────────────
  void _reinitialiser() {
    setState(() {
      _catsSelectionnees.clear();
      _distance = 10.0;
      _prix     = const RangeValues(100, 1000);
      _creneau  = const RangeValues(6, 23);
      _disposSelectionnees.clear();
      _noteMin  = null;
      _services.clear();
      _paiements.clear();
      _alimentairesSelectionnees.clear();
    });
  }

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────
  Widget _titreSec(String t) => Text(t,
      style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: _C.textDark));

  Widget _separateur() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Divider(
            color: _C.divider.withOpacity(0.5),
            height: 1),
      );

  Widget _chip(
      String label, bool sel, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: sel ? _C.chipSel : _C.chip,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: sel
                    ? _C.chipSelTxt
                    : _C.textMut)),
      ),
    );
  }

  Widget _labelsAxe(List<String> labels) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: labels
            .map((l) => Text(l,
                style: const TextStyle(
                    fontSize: 10.5,
                    color: _C.textMut)))
            .toList(),
      ),
    );
  }

  SliderThemeData _sliderTheme() {
    return SliderTheme.of(context).copyWith(
      activeTrackColor: _C.accent,
      inactiveTrackColor: _C.divider,
      thumbColor: _C.accent,
      overlayColor: _C.accent.withOpacity(0.15),
      trackHeight: 3,
      thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 8),
    );
  }

  SliderThemeData _rangeSliderTheme() {
    return SliderTheme.of(context).copyWith(
      activeTrackColor: _C.accent,
      inactiveTrackColor: _C.divider,
      thumbColor: _C.accent,
      overlayColor: _C.accent.withOpacity(0.15),
      trackHeight: 3,
      rangeThumbShape: const RoundRangeSliderThumbShape(
          enabledThumbRadius: 8),
      // Thumb gauche en vert, droit en orange
      valueIndicatorColor: _C.green,
    );
  }
}