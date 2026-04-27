// ignore_for_file: deprecated_member_use, unused_label, unused_field, no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'offre_detail_screen.dart'; // ← import pour OffreDetail + OffreDetailScreen

// ─────────────────────────────────────────────
// COULEURS
// ─────────────────────────────────────────────
class AppColors {
  static const Color scaffold    = Color(0xFFE8E0CE);
  static const Color accent      = Color(0xFFE07B39);
  static const Color cardBg      = Color(0xFFF5F0E3);
  static const Color offerCardBg = Color(0xFFC8B99A);
  static const Color textDark    = Color(0xFF2C2814);
  static const Color textMuted   = Color(0xFF8A8070);
  static const Color navBg       = Color(0xFFB5C49E);
  static const Color white       = Color(0xFFFFFFFF);
  static const Color divider     = Color(0xFFD9D0BF);
  static const Color chipDark    = Color(0xFF6B7C4E);
  static const Color accentGreen = Color(0xFF5A9E8B);
}

// ─────────────────────────────────────────────
// MODÈLE RÉSERVATION
// ─────────────────────────────────────────────
enum ReservationStatut { enCours, validee, annulee }

class Reservation {
  final String id;
  final String commercant;
  final String soustitre;
  final String adresse;
  final String prix;
  final String distance;
  final String creneau;
  final String quantite;
  final String codeRetrait;
  final String imageAsset;
  final ReservationStatut statut;
  final bool confirme;
  final double? note;
  final String? date;
  final String? economie;
  final String? motifAnnulation;

  // Données pour naviguer vers OffreDetailScreen
  final OffreDetail? offreDetail;

  const Reservation({
    required this.id,
    required this.commercant,
    required this.soustitre,
    required this.adresse,
    required this.prix,
    required this.distance,
    required this.creneau,
    required this.quantite,
    required this.codeRetrait,
    required this.imageAsset,
    required this.statut,
    this.confirme = false,
    this.note,
    this.date,
    this.economie,
    this.motifAnnulation,
    this.offreDetail,
  });
}

// ─────────────────────────────────────────────
// ÉCRAN PRINCIPAL
// ─────────────────────────────────────────────
class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedNavIndex = 3;

  // ── Offre de démo pour "Voir l'offre" ──
  static const OffreDetail _offreBurger = OffreDetail(
    id: 'o2',
    nom: 'Box Burger House',
    commercant: 'Burger House',
    adresse: 'Laprovale , Kouba, Alger',
    prix: '550Da',
    prixOriginal: '900Da',
    distance: '0.9km',
    note: 4.3,
    restants: 5,
    creneau: '17h–19h',
    categorie: 'Box alimentaire',
    imageAsset: 'assets/images/burger_house2.png',
    description: 'Box surprise composée de burgers, frites et boissons invendus du jour.',
    contenu: ['1 burger', '1 portion de frites', '1 boisson', '1 surprise'],
  );

  final List<Reservation> _reservations = const [
    Reservation(
      id: 'r1',
      commercant: 'Kouba Shop',
      soustitre: 'Box alimentaire · Produits du quotidien · fruit surprise',
      adresse: 'Laprovale , Kouba, Alger',
      prix: '500Da',
      distance: '0.9km',
      creneau: '17h-19h',
      quantite: '1 panier',
      codeRetrait: '4872',
      imageAsset: 'assets/images/kouba_shop.png',
      statut: ReservationStatut.enCours,
      confirme: true, // ✅ Confirmé → code retrait + "Itinéraire"
    ),
    Reservation(
      id: 'r2',
      commercant: 'Burger House',
      soustitre: 'Box alimentaire · Produits du quotidien · fruit surprise',
      adresse: 'Laprovale , Kouba, Alger',
      prix: '550Da',
      distance: '0.9km',
      creneau: '17h-19h',
      quantite: '1 panier',
      codeRetrait: '1234',
      imageAsset: 'assets/images/burger_house2.png',
      statut: ReservationStatut.enCours,
      confirme: false, // ❌ Non confirmé → "Voir l'offre"
      offreDetail: _offreBurger,
    ),
    Reservation(
      id: 'r3',
      commercant: 'Burger House',
      soustitre: 'Offre spéciale · Burger · frites · salade',
      adresse: 'Vieux Kouba, Kouba, Alger',
      prix: '550Da',
      distance: '1.2km',
      creneau: '12h-14h',
      quantite: '1 menu',
      codeRetrait: '5678',
      imageAsset: 'assets/images/burger_house2.png',
      statut: ReservationStatut.validee,
      confirme: true,
      date: '18 mars 2025',
      economie: '220 DA',
    ),
    Reservation(
      id: 'r4',
      commercant: 'Kouba Shop',
      soustitre: 'Box alimentaire · Produits du quotidien · fruit surprise',
      adresse: 'Laprovale , Kouba, Alger',
      prix: '500Da',
      distance: '0.1km',
      creneau: '17h-19h',
      quantite: '1 panier',
      codeRetrait: '9012',
      imageAsset: 'assets/images/kouba_shop.png',
      statut: ReservationStatut.validee,
      confirme: true,
      date: '19 mars 2025',
      economie: '300 DA',
    ),
    // ── Annulée ──
    Reservation(
      id: 'r5',
      commercant: 'La maison du Pain',
      soustitre: 'Box boulangerie · pains variés · viennoiseries',
      adresse: 'Laprovale , Kouba, Alger',
      prix: '90Da',
      distance: '1.5km',
      creneau: '13h-14h',
      quantite: '1 panier',
      codeRetrait: '0000',
      imageAsset: 'assets/images/offre_maison_pain.png',
      statut: ReservationStatut.annulee,
      date: '12 mars 2025',
      motifAnnulation: 'Changement de plan',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Reservation> get _enCours =>
      _reservations.where((r) => r.statut == ReservationStatut.enCours).toList();
  List<Reservation> get _validees =>
      _reservations.where((r) => r.statut == ReservationStatut.validee).toList();
  List<Reservation> get _annulees =>
      _reservations.where((r) => r.statut == ReservationStatut.annulee).toList();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildEnCoursList(),
                    _buildValideesList(),
                    _buildAnnuleesList(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(bottom: 74, right: 16, child: _cartFab()),
          Positioned(bottom: 0, left: 0, right: 0, child: _bottomNav()),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HEADER + TABBAR
  // ─────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      children: [
        // ── AppBar verte ──
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFCCD5AE),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 12,
            bottom: 16,
            left: 20,
            right: 20,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new,
                    size: 18, color: AppColors.textDark),
              ),
              const Expanded(
                child: Center(
                  child: Text('Mes reservations',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark)),
                ),
              ),
              const SizedBox(width: 18),
            ],
          ),
        ),

        // ── TabBar dans son propre container ──
        Container(
          color: AppColors.scaffold,
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.textDark,
            unselectedLabelColor: AppColors.textMuted,
            labelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            unselectedLabelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(color: AppColors.accent, width: 2.5),
              insets: EdgeInsets.symmetric(horizontal: 16),
            ),
            tabs: const [
              Tab(text: 'En cours'),
              Tab(text: 'Validées'),
              Tab(text: 'Annulées'),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // ONGLET "EN COURS"
  // ─────────────────────────────────────────────
  Widget _buildEnCoursList() {
    if (_enCours.isEmpty) return _emptyState('Aucune réservation en cours');
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      itemCount: _enCours.length,
      itemBuilder: (_, i) => _enCoursCard(_enCours[i]),
    );
  }

  Widget _enCoursCard(Reservation r) {
    return Container(
     margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 237, 201),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.chipDark.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + infos
          Padding(
            padding: const EdgeInsets.all(2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                 
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: Image.asset(r.imageAsset,
                        fit: BoxFit.cover,
                       
                        // ignore: unnecessary_underscores
                        errorBuilder: (_, __, ___) => Container(
                          
                              color: AppColors.offerCardBg,
                              child: const Icon(Icons.storefront_outlined,
                              size: 36, color: AppColors.textMuted),                               
                            )                            
                            ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(r.commercant,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark)),
                          Text(r.prix,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.accent)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(r.soustitre,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 12, color: AppColors.textDark),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(r.adresse,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 11, color: AppColors.textMuted)),
                          ),
                          Text(r.distance,
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Étapes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _stepsRow(confirme: r.confirme),
          ),
          const SizedBox(height: 12),

          // Code de retrait (seulement si confirmé)
          if (r.confirme) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.chipDark.withOpacity(0.8), width: 1),
                ),
                child: Column(
                  children: [
                    const Text('Code de retrait',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.textDark)),
                    const SizedBox(height: 2),
                    Text(r.codeRetrait,
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 8,
                            color: AppColors.accent)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Créneau / Quantité / Distance
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoChip('Créneau', r.creneau),
                _infoChip('Quantité', r.quantite),
                _infoChip('Distance', r.distance),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Boutons
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
            child: Row(
              children: [
                Expanded(
                  child: _outlineButton(
                    label: r.confirme ? 'Itinéraire' : "Voir l'offre",
                    onTap: () {
                      if (!r.confirme) {
                        // ✅ FIX : navigation avec l'objet OffreDetail passé en paramètre
                        final offre = r.offreDetail;
                        if (offre != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OffreDetailScreen(offre: offre),
                            ),
                          );
                        }
                      }
                      // Itinéraire : ex. lancer Maps
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _filledButton(
                    label: 'Annuler',
                    onTap: () => _showAnnulationDialog(r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ÉTAPES
  // ─────────────────────────────────────────────
  Widget _stepsRow({required bool confirme}) {
    const steps = ['Réservé', 'Confirmé', 'Retrait', 'Avis'];
    final activeIndex = confirme ? 1 : 0;

    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final leftDone = (i ~/ 2) <= activeIndex;
          return Expanded(
            child: Container(
              height: 2,
              color: leftDone
                  ? AppColors.accentGreen.withOpacity(0.5)
                  : AppColors.divider,
            ),
          );
        }
        final idx = i ~/ 2;
        final done = idx <= activeIndex;
        return Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: done
                    ? AppColors.accentGreen.withOpacity(0.15)
                    : AppColors.divider.withOpacity(0.5),
                shape: BoxShape.circle,
                border: Border.all(
                    color: done ? AppColors.chipDark : AppColors.divider,
                    width: 1),
              ),
              child: done
                  ? const Icon(Icons.check, size: 30, color: AppColors.accentGreen)
                  : null,
            ),
            const SizedBox(height: 4),
            Text(steps[idx],
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: done ? AppColors.textDark : AppColors.textMuted)),
          ],
        );
      }),
    );
  }

  // ─────────────────────────────────────────────
  // ONGLET "VALIDÉES"
  // ─────────────────────────────────────────────
  Widget _buildValideesList() {
    if (_validees.isEmpty) return _emptyState('Aucune réservation validée');
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      itemCount: _validees.length,
      itemBuilder: (_, i) => _valideeCard(_validees[i]),
    );
  }

  Widget _valideeCard(Reservation r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: Image.asset(r.imageAsset,
                        fit: BoxFit.cover,
                        // ignore: unnecessary_underscores
                        errorBuilder: (_, __, ___) => Container(
                              color: AppColors.offerCardBg,
                              child: const Icon(Icons.storefront_outlined,
                                  size: 36, color: AppColors.textMuted),
                            )),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(r.commercant,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark)),
                          Text(r.prix,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.accent)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(r.soustitre,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 11, color: AppColors.textMuted),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(r.adresse,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 11, color: AppColors.textMuted)),
                          ),
                          Text(r.distance,
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _metaChip('Date', r.date ?? '-'),
                _metaChip('Créneau', r.creneau),
                _metaChip('Économie', r.economie ?? '-'),
              ],
            ),
          ),
          // Bouton "Laisser un avis" ou étoiles si déjà noté
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
            child: r.note == null
                ? _outlineButton(
                    label: 'Laisser un avis',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AvisScreen(reservation: r),
                      ),
                    ),
                  )
                : Row(
                    children: List.generate(
                      5,
                      (i) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          i < (r.note ?? 0) ? Icons.star : Icons.star_border,
                          size: 22,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ONGLET "ANNULÉES"
  // ─────────────────────────────────────────────
  Widget _buildAnnuleesList() {
    if (_annulees.isEmpty) return _emptyState('Aucune réservation annulée');
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      itemCount: _annulees.length,
      itemBuilder: (_, i) => _annuleeCard(_annulees[i]),
    );
  }

  Widget _annuleeCard(Reservation r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + infos
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.asset(r.imageAsset,
                        fit: BoxFit.cover,
                        // ignore: unnecessary_underscores
                        errorBuilder: (_, __, ___) => Container(
                              color: AppColors.offerCardBg,
                              child: const Icon(Icons.storefront_outlined,
                                  size: 32, color: AppColors.textMuted),
                            )),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(r.commercant,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textDark)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(r.prix,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accent,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: AppColors.accent)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(r.soustitre,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 11, color: AppColors.textMuted),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(r.adresse,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 11, color: AppColors.textMuted)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Date / Créneau / Remboursé
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _metaChip('Date', r.date ?? '-'),
                _metaChip('Créneau', r.creneau),
                _metaChip('Remboursé', 'Oui'),
              ],
            ),
          ),

          // Badge Annulé + motif
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cancel_outlined,
                      size: 14, color: Colors.red),
                  const SizedBox(width: 6),
                  const Text('Annulé',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.red)),
                  if (r.motifAnnulation != null) ...[
                    const Text('  ·  ',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                    Text(r.motifAnnulation!,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // DIALOGUE ANNULATION
  // ─────────────────────────────────────────────
  void _showAnnulationDialog(Reservation r) {
    String? _selectedReason;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setLocal) => Container(
          decoration: const BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.6),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.chipDark, width: 1),
                ),
                child: const Icon(Icons.close, size: 40, color: AppColors.textDark),
              ),
              const SizedBox(height: 16),
              const Text('Annuler la réservation ?',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark)),
              const SizedBox(height: 8),
              const Text(
                'Dites-nous pourquoi vous annulez.\nCela aide les commerçants à mieux planifier.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13, color: AppColors.textMuted, height: 1.5),
              ),
              const SizedBox(height: 20),
              ...['Changement de plan', 'Erreur de commande',
                      'Prix trop élevé finalement', 'Autre raison']
                  .map((reason) => GestureDetector(
                        onTap: () => setLocal(() => _selectedReason = reason),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: _selectedReason == reason
                                ? AppColors.accent.withOpacity(0.1)
                                : const Color.fromARGB(255, 247, 221, 195),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: _selectedReason == reason
                                    ? AppColors.accent
                                    : AppColors.chipDark,
                                width: 1.5),
                          ),
                          child: Text(reason,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _selectedReason == reason
                                      ? AppColors.accent
                                      : AppColors.textDark)),
                        ),
                      )),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 247, 221, 195),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: AppColors.chipDark, width: 2.5),
                        ),
                        child: const Center(
                          child: Text("Confirmer l'annulation",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 247, 221, 195),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: AppColors.chipDark, width: 2.5),
                        ),
                        child: const Center(
                          child: Text('Garder ma reservation',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark)),
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
    );
  }

  // ─────────────────────────────────────────────
  // WIDGETS UTILITAIRES
  // ─────────────────────────────────────────────
  Widget _infoChip(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 20,
                color: AppColors.textDark,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
      ],
    );
  }

  Widget _metaChip(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
      ],
    );
  }

  Widget _outlineButton(
      {required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(237, 249, 174, 99),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: const Color.fromARGB(255, 176, 176, 176), width: 2.5),
        ),
        child: Center(
          child: Text(label,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
        ),
      ),
    );
  }

  Widget _filledButton(
      {required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(237, 249, 174, 99),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: const Color.fromARGB(255, 176, 176, 176), width: 2.5),
        ),
        child: Center(
          child: Text(label,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
        ),
      ),
    );
  }

  Widget _emptyState(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.divider.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_bag_outlined,
                size: 32, color: AppColors.textMuted),
          ),
          const SizedBox(height: 14),
          Text(message,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted)),
        ],
      ),
    );
  }

 
    
    Widget _cartFab() {
  return GestureDetector(                                     // ← AJOUTER
    onTap: () => Navigator.pushNamed(context, '/cart'),       // ← AJOUTER
    child: Container(
      width: 45, height: 45,
      decoration: BoxDecoration(
        color:  const Color(0xFFE8A45A),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 3, 3, 3),
            blurRadius: 15,
            offset: const Offset(0,5),
          ),
        ],
      ),

      child: const Icon(Icons.shopping_cart_outlined,
          color: AppColors.textDark ,size: 40),
    )     
    );
  }

  Widget _bottomNav() {
    final icons = [
      Icons.favorite_border,
      Icons.search,
      Icons.home_outlined,
      Icons.shopping_bag_outlined,
      Icons.person_outline,
     // Icons.filter_rounded,
      Icons.tune_rounded
    ];
    const selectedIndex = 3;

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.navBg,
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
              setState(() => _selectedNavIndex = i);
              if (i == 0) Navigator.pushNamed(context, '/acces_rapide');
              if (i == 1) Navigator.pushNamed(context, '/carte');
              if (i == 2) Navigator.pushNamed(context, '/home_client');
              if (i == 3) Navigator.pushNamed(context, '/reservations');
              if (i == 4) Navigator.pushNamed(context, '/notifications_client');
              if (i == 5) Navigator.pushNamed(context, '/filtre_screen');
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: sel ? AppColors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(icons[i],
                  size: 22,
                  color: sel
                      ? AppColors.textDark
                      : AppColors.textDark.withOpacity(0.55)),
            ),
          );
        }),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// ÉCRAN "LAISSER UN AVIS"
// ═══════════════════════════════════════════════════════
class AvisScreen extends StatefulWidget {
  final Reservation reservation;
  const AvisScreen({super.key, required this.reservation});

  @override
  State<AvisScreen> createState() => _AvisScreenState();
}

class _AvisScreenState extends State<AvisScreen> {
  int _noteGlobale     = 0;
  int _noteCreneau     = 0;
  int _noteQualitePrix = 0;
  bool _envoye         = false;

  Reservation get r => widget.reservation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6DFB8),
      body: SafeArea(
        child: _envoye ? _merciPage() : _formulairePage(),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // PAGE FORMULAIRE
  // ─────────────────────────────────────────────
  Widget _formulairePage() {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new,
                    size: 18, color: AppColors.textDark),
              ),
              const SizedBox(width: 12),
              const Text('Laisser un avis',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark)),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carte commerce
                _commerceCard(),
                const SizedBox(height: 24),

                // Note globale
                Row(
                  children: const [
                    Icon(Icons.star_outline,
                        size: 20, color: AppColors.textDark),
                    SizedBox(width: 6),
                    Text('Note globale',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                  ],
                ),
                const SizedBox(height: 12),
                _etoiles(
                  note: _noteGlobale,
                  size: 40,
                  onTap: (v) => setState(() => _noteGlobale = v),
                ),
                const SizedBox(height: 28),

                // Détails
                Row(
                  children: const [
                    Icon(Icons.tune, size: 18, color: AppColors.textDark),
                    SizedBox(width: 6),
                    Text("Détails de l'expérience",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                  ],
                ),
                const SizedBox(height: 12),

                _detailCard(
                  label: 'Respect du créneau',
                  note: _noteCreneau,
                  onTap: (v) => setState(() => _noteCreneau = v),
                ),
                const SizedBox(height: 12),

                _detailCard(
                  label: 'Rapport qualité/prix',
                  note: _noteQualitePrix,
                  onTap: (v) => setState(() => _noteQualitePrix = v),
                ),
                const SizedBox(height: 32),

                // Bouton Envoyer
                GestureDetector(
                  onTap: _noteGlobale > 0
                      ? () => setState(() => _envoye = true)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _noteGlobale > 0
                          ? const Color.fromARGB(237, 249, 174, 99)
                          : AppColors.divider,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: _noteGlobale > 0
                              ? AppColors.chipDark
                              : AppColors.divider,
                          width: 2),
                    ),
                    child: const Center(
                      child: Text('Envoyer',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark)),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Passer
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Center(
                    child: Text('Passer, noter plus tard',
                        style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.textMuted)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // PAGE CONFIRMATION "MERCI"
  // ─────────────────────────────────────────────
  Widget _merciPage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new,
                    size: 18, color: AppColors.textDark),
              ),
              const SizedBox(width: 12),
              const Text('Laisser un avis',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _commerceCard(),
        ),
        const SizedBox(height: 24),

        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F0E3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.25),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.accent.withOpacity(0.5), width: 2),
                  ),
                  child: const Icon(Icons.handshake_outlined,
                      size: 46, color: AppColors.accent),
                ),
                const SizedBox(height: 24),
                const Text('Merci pour votre avis !',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark)),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    "Votre retour aide la communauté à faire de meilleurs choix et encourage les commerçants à s'améliorer.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        height: 1.6),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: GestureDetector(
                    onTap: () => Navigator.popUntil(
                        context, ModalRoute.withName('/reservations')),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(237, 249, 174, 99),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: AppColors.chipDark, width: 2),
                      ),
                      child: const Center(
                        child: Text('Retour a mes reservations',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // CARTE COMMERCE
  // ─────────────────────────────────────────────
  Widget _commerceCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 237, 201),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 64,
              height: 64,
              child: Image.asset(r.imageAsset,
                  fit: BoxFit.cover,
                  // ignore: unnecessary_underscores
                  errorBuilder: (_, __, ___) => Container(
                        color: AppColors.offerCardBg,
                        child: const Icon(Icons.storefront_outlined,
                            size: 28, color: AppColors.textMuted),
                      )),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.commercant.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(r.soustitre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.chipDark)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 11, color: AppColors.textMuted),
                    const SizedBox(width: 3),
                    Text(r.adresse,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(r.distance,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ÉTOILES
  // ─────────────────────────────────────────────
  Widget _etoiles({
    required int note,
    required double size,
    required void Function(int) onTap,
  }) {
    return Row(
      children: List.generate(5, (i) {
        return GestureDetector(
          onTap: () => onTap(i + 1),
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Icon(
              i < note ? Icons.star : Icons.star_border,
              size: size,
              color: i < note ? AppColors.accent : AppColors.textMuted,
            ),
          ),
        );
      }),
    );
  }

  // ─────────────────────────────────────────────
  // CARTE DÉTAIL
  // ─────────────────────────────────────────────
  Widget _detailCard({
    required String label,
    required int note,
    required void Function(int) onTap,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 237, 201),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 10),
          _etoiles(note: note, size: 32, onTap: onTap),
        ],
      ),
    );
  }
}