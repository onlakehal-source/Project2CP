// ignore_for_file: deprecated_member_use, prefer_final_fields, unused_field, sort_child_properties_last, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
// MODÈLE — OffreDetail
// ─────────────────────────────────────────────
class OffreDetail {
  final String id;
  final String nom;
  final String commercant;
  final String adresse;
  final String prix;
  final String prixOriginal;
  final String distance;
  final double note;
  final int restants;
  final String creneau;
  final String categorie;
  final String? imageAsset;
  final String description;
  final List<String> contenu;

  const OffreDetail({
    required this.id,
    required this.nom,
    required this.commercant,
    required this.adresse,
    required this.prix,
    required this.prixOriginal,
    required this.distance,
    required this.note,
    required this.restants,
    required this.creneau,
    required this.categorie,
    this.imageAsset,
    required this.description,
    required this.contenu,
  });
}

// ─────────────────────────────────────────────
// COULEURS (reprises du projet)
// ─────────────────────────────────────────────
class _C {
  static const scaffold    = Color(0xFFE8E0CE);
  static const cardBg      = Color(0xFFF5F0E3);
  static const accent      = Color(0xFFE07B39);
  static const textDark    = Color(0xFF2C2814);
  static const textMuted   = Color(0xFF8A8070);
  static const divider     = Color(0xFFD9D0BF);
  static const chipDark    = Color(0xFF6B7C4E);
  static const white       = Color(0xFFFFFFFF);
  static const navBg       = Color(0xFFB5C49E);
  static const offerCardBg = Color(0xFFC8B99A);
  static const slotActive  = Color(0xFFCCD5AE);
  static const slotDone    = Color(0xFFD9D0BF);
}

// ─────────────────────────────────────────────
// ÉCRAN DÉTAIL OFFRE
// ─────────────────────────────────────────────
class OffreDetailScreen extends StatefulWidget {
  final OffreDetail offre;
  const OffreDetailScreen({super.key, required this.offre});

  @override
  State<OffreDetailScreen> createState() => _OffreDetailScreenState();
}

class _OffreDetailScreenState extends State<OffreDetailScreen> {
  int _qty = 1;

  // Mode de service sélectionné : 0 = À emporter, 1 = Livraison
  int _serviceMode = 0;

  // Créneaux disponibles
  final List<Map<String, dynamic>> _creneaux = [
    {'label': '13h–14h', 'dispo': true},
    {'label': '17h–19h', 'dispo': true},
    {'label': '19h–20h', 'dispo': false}, // barré
  ];
  int _selectedCreneau = 0;

  // Filtres alimentaires (placeholder)
  bool _sansGluten = false;
  bool _vegetarien = false;

  OffreDetail get o => widget.offre;

  // ── Prix total calculé ──
  int get _totalDA {
    final raw = o.prix.replaceAll(RegExp(r'[^0-9]'), '');
    return (int.tryParse(raw) ?? 0) * _qty;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 213, 174),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── IMAGE HERO ──
              SliverToBoxAdapter(child: _hero()),

              // ── CORPS ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _titleBlock(),
                      const SizedBox(height: 16),
                      _priceRow(),
                      const SizedBox(height: 14),
                      _timerRow(),
                      const SizedBox(height: 20),
                      _divider(),
                      const SizedBox(height: 16),
                      _commerceBlock(),
                      const SizedBox(height: 16),
                      _divider(),
                      const SizedBox(height: 16),
                      _serviceModeBlock(),
                      const SizedBox(height: 16),
                      _divider(),
                      const SizedBox(height: 16),
                      _creneauxBlock(),
                      const SizedBox(height: 16),
                      _divider(),
                      const SizedBox(height: 16),
                      _filtresBlock(),
                      const SizedBox(height: 16),
                      _divider(),
                      const SizedBox(height: 16),
                      _qtyBlock(),
                      const SizedBox(height: 160), // espace bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── BOTTOM BAR fixe ──
          Positioned(bottom: 0, left: 0, right: 0, child: _bottomBar()),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HERO IMAGE
  // ─────────────────────────────────────────────
  Widget _hero() {
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          // Image
          Positioned.fill(
            child: o.imageAsset != null
                ? Image.asset(
                    o.imageAsset!,
                    fit: BoxFit.cover,
                    // ignore: unnecessary_underscores
                    errorBuilder: (_, __, ___) => Container(
                      color: _C.offerCardBg,
                      child: const Center(
                        child: Icon(Icons.image_outlined,
                            size: 60, color: _C.textMuted),
                      ),
                    ),
                  )
                : Container(color: _C.offerCardBg),
          ),

          // Gradient bas
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.45),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Bouton retour
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 14,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36, height: 36,
                decoration: const BoxDecoration(
                  color: _C.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    size: 16, color: _C.textDark),
              ),
            ),
          ),

          // Bouton favori
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 14,
            child: Container(
              width: 26, height: 36,
              decoration: const BoxDecoration(
                color: _C.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_border,
                  size: 17, color: _C.textDark),
            ),
          ),

          // Label catégorie
          Positioned(
            bottom: 14, left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: _C.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                o.categorie,
                style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700,
                  color: _C.textDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TITRE + DESCRIPTION
  // ─────────────────────────────────────────────
  Widget _titleBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(o.nom,
          style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.w800,
            color: _C.textDark, height: 1.2,
          )),
        const SizedBox(height: 8),
        Text(o.description,
          style: const TextStyle(
            fontSize: 13, color: _C.textMuted, height: 1.55,
          )),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // LIGNE PRIX + RESTANTS
  // ─────────────────────────────────────────────
  Widget _priceRow() {
    return Row(
      children: [
        // Prix
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 233, 237, 201),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _C.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/prix.png'),
                    const SizedBox(width: 6),
                    Text(o.prix,
                      style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800,
                        color: _C.accent,
                      )),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Économie ${_economie()}',
                  style: const TextStyle(fontSize: 11, color: _C.textMuted),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Restants
        Container(
          
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 50),
          
          decoration: BoxDecoration(
            
            color: const Color.fromARGB(255, 233, 237, 201),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.divider),
          ),
          
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,  
            children: [
             
            Row( 
              crossAxisAlignment: CrossAxisAlignment.center,
            //  crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              const SizedBox(width: 50),
              Text(o.restants.toString(),
                style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800,
                  color: _C.textDark,
                )),
               
            ]
            ),

             
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Image.asset('assets/images/stock.png'),   
             
               
              Column(
              mainAxisAlignment: MainAxisAlignment.center,  
              children: [
              const Text('restants', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w800, color: _C.textDark)),
              
               const Text('Stock', style: TextStyle(fontSize: 10, color: _C.textMuted)),
              ]
              )
              ]
             ),
            
            ],
          
          ),
        ),
      ],
    
    );
  }

  String _economie() {
    final prixN  = int.tryParse(o.prix.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final origN  = int.tryParse(o.prixOriginal.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    return origN > 0 ? '${origN - prixN} DA' : '';
  }

  // ─────────────────────────────────────────────
  // LIGNE TIMER
  // ─────────────────────────────────────────────
  Widget _timerRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 237, 201),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time_outlined, size: 18, color: _C.textDark),
          const SizedBox(width: 8),
          _CountdownTimer(creneau: o.creneau),
          const Spacer(),
          const Text('Disponible encore',
            style: TextStyle(fontSize: 11.5, color: _C.textMuted)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // COMMERCE
  // ─────────────────────────────────────────────
  Widget _commerceBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Le commerce',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _C.textDark)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 233, 237, 201),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.divider),
          ),
          child: Row(
            children: [
              // Logo placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 70, height:70,
                  color: _C.offerCardBg,
                  child: Center(
                    child: Image.asset('assets/images/burger_house2.png'),
                      
                   
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(o.commercant.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w800,
                        color: _C.textDark, letterSpacing: 0.3,
                      )),
                    const SizedBox(height: 2),
                    Text(o.categorie,
                      style: const TextStyle(
                        fontSize: 11.5, color: _C.chipDark,
                        fontWeight: FontWeight.w600,
                      )),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                           size: 12, color: _C.textMuted),
                        const SizedBox(width: 3),
                        Text('${o.adresse}  ·  ${o.distance}',
                          style: const TextStyle(
                              fontSize: 11, color: _C.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),

              // Étoile
              Column(
                children: [
                  const Icon(Icons.star, size: 14, color: _C.accent),
                  Text(o.note.toString(),
                    style: const TextStyle(fontSize: 11, color: _C.textMuted)),
                ],
              ),

              const SizedBox(width: 6),
              const Icon(Icons.chevron_right, size: 18, color: _C.textMuted),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // MODE DE SERVICE
  // ─────────────────────────────────────────────
  Widget _serviceModeBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mode de service',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _C.textDark)),
        const SizedBox(height: 10),
        Row(
          children: [
            _serviceBtn(0, Icons.shopping_bag_outlined, 'À emporter'),
            const SizedBox(width:50),
            _serviceBtn(1, Icons.local_taxi_outlined, 'Livraison'),
          ],
        ),
      ],
    );
  }

  Widget _serviceBtn(int idx, IconData icon, String label) {
    final selected = _serviceMode == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _serviceMode = idx),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: selected ? const Color.fromARGB(255, 233, 237, 201) : const Color.fromARGB(255, 233, 237, 201),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? _C.cardBg : _C.divider,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 30,
                  color: selected ? _C.textDark : _C.textMuted),
              const SizedBox(height: 5),
              Text(label,
                style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w800,
                  color: selected ? _C.textDark : _C.textDark,
                )),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CRÉNEAUX
  // ─────────────────────────────────────────────
  Widget _creneauxBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Disponibilité — créneaux de retrait',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _C.textDark)),
        const SizedBox(height: 10),
        Row(
          children: List.generate(_creneaux.length, (i) {
            final c = _creneaux[i];
            final bool dispo = c['dispo'] as bool;
            final bool selected = _selectedCreneau == i && dispo;
            return Padding(
              padding: EdgeInsets.only(right: i < _creneaux.length - 1 ? 8 : 0),
              child: GestureDetector(
                onTap: dispo ? () => setState(() => _selectedCreneau = i) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: !dispo
                        ? const Color.fromARGB(255, 233, 237, 201)
                        : selected
                            ? const Color.fromARGB(255, 233, 237, 201)
                            : const Color.fromARGB(255, 233, 237, 201),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    c['label'] as String,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: !dispo
                          ? _C.textMuted
                          : selected
                              ? _C.textDark
                              : _C.textDark,
                      decoration: !dispo
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text('Le créneau barré est complet.',
          style: TextStyle(fontSize: 11, color: _C.textMuted)),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // FILTRES ALIMENTAIRES
  // ─────────────────────────────────────────────
  Widget _filtresBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Filtres alimentaires',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _C.textDark)),
        const SizedBox(height: 6),
        const Text('Option non disponible pour ce produit',
          style: TextStyle(fontSize: 12, color: _C.textMuted)),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // QUANTITÉ
  // ─────────────────────────────────────────────
  Widget _qtyBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quantité',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _C.textDark)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 233, 237, 201),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.divider),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Nombre de paniers',
                style: TextStyle(fontSize: 16, color: _C.textDark, fontWeight: FontWeight.w500)),
              Row(
                children: [
                  // Bouton –
                  GestureDetector(
                    onTap: () { if (_qty > 1) setState(() => _qty--); },
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 254, 200, 99),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: _C.navBg,width: 3),
                      ),
                      child: const Icon(Icons.remove, size: 20, color: _C.textDark),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text('$_qty',
                    style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800, color: _C.textDark)),
                  const SizedBox(width: 14),
                  // Bouton +
                  GestureDetector(
                    onTap: () { if (_qty < o.restants) setState(() => _qty++); },
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 254, 200, 99),
                        borderRadius: BorderRadius.circular(15),
                         border: Border.all(color: _C.navBg,width:3 ),
                      ),
                      child: const Icon(Icons.add, size: 20, color: _C.textDark),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // BOTTOM BAR
  // ─────────────────────────────────────────────
  Widget _bottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          12, 10, 12, MediaQuery.of(context).padding.bottom + 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 248, 238, 214),
        border: Border(top: BorderSide(color: _C.divider.withOpacity(0.6))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total a payé',
                style: TextStyle(fontSize: 14, color: _C.textMuted)),
              Text('$_totalDA DA',
                style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800, color: _C.accent)),
            ],
          ),
          const SizedBox(height: 10),
          // Bouton panier
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/cart'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 252, 198, 144),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: _C.divider,width:3 ),
                      ),
              child: const Center(
                child: Text('Ajouter au panier',
                  style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: _C.textDark)),
              ),
            ),
          ),
          const SizedBox(height: 5),
          // Lien signalement
          GestureDetector(
            onTap: () {},
            child: const Text('Signaler cette offre',
              style: TextStyle(
                fontSize: 12, color: _C.textMuted,
                decoration: TextDecoration.underline,
                decorationColor: _C.textMuted,
              )),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // DIVIDER
  // ─────────────────────────────────────────────
  Widget _divider() => Divider(color: _C.divider.withOpacity(0.7), height: 1);
}

// ─────────────────────────────────────────────
// WIDGET COUNTDOWN TIMER
// ─────────────────────────────────────────────
class _CountdownTimer extends StatefulWidget {
  final String creneau;
  const _CountdownTimer({required this.creneau});

  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  late Duration _remaining;
  late final Stream<Duration> _stream;

  @override
  void initState() {
    super.initState();
    // Simuler un compte à rebours de 4h15 (remplacer par la vraie logique)
    _remaining = const Duration(hours: 4, minutes: 15, seconds: 15);
    _stream = Stream.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds > 0) {
        _remaining -= const Duration(seconds: 1);
      }
      return _remaining;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: _stream,
      initialData: _remaining,
      builder: (_, snap) {
        final d = snap.data ?? _remaining;
        final h = d.inHours.toString().padLeft(2, '0');
        final m = (d.inMinutes % 60).toString().padLeft(2, '0');
        final s = (d.inSeconds % 60).toString().padLeft(2, '0');
        return Text('$h:$m:$s',
          style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w800,
            color: Color(0xFF2C2814), fontFeatures: [FontFeature.tabularFigures()],
          ));
      },
    );
  }
}