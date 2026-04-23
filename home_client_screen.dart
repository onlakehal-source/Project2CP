// ignore_for_file: sized_box_for_whitespace, no_leading_underscores_for_local_identifiers, unused_element, avoid_unnecessary_containers, unused_label, dead_code, unnecessary_underscores



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laaisraf/offre_detail_screen.dart';







// ─────────────────────────────────────────────
// COULEURS
// ─────────────────────────────────────────────
class AppColors {
  static const Color scaffold    = Color(0xFFE8E0CE);
  static const Color searchBar   = Color(0xFFC5D4A8);
  static const Color chipDark    = Color(0xFF6B7C4E);
  static const Color accent      = Color(0xFFE07B39);
  static const Color cardBg      = Color(0xFFF5F0E3);
  static const Color offerCardBg = Color(0xFFC8B99A);
  static const Color storeIconBg = Color(0xFFCFC0A4);
  static const Color textDark    = Color(0xFF2C2814);
  static const Color textMuted   = Color(0xFF8A8070);
  static const Color navBg       = Color(0xFFB5C49E);
  static const Color white       = Color(0xFFFFFFFF);
  static const Color divider     = Color(0xFFD9D0BF);
}

// ─────────────────────────────────────────────
// MODÈLE — avec imageAsset pour les vraies images
// ─────────────────────────────────────────────
class NearbyStore {
  final String name;
  final String category;
  final String address;
  final double distance;
  final int offersCount;
  final double rating;

  /// Chemin asset local, ex: 'assets/images/moulin_dore.png'
  /// ou URL réseau, ex: 'https://...'
  final String? imageAsset;

  const NearbyStore({
    required this.name,
    required this.category,
    required this.address,
    required this.distance,
    required this.offersCount,
    required this.rating,
    this.imageAsset,
  });
}

// ─────────────────────────────────────────────
// ÉCRAN — UN SEUL FICHIER, DEUX ÉTATS
//
//  _locationEnabled = false  →  prompt "Activez votre localisation"
//  _locationEnabled = true   →  liste des commerces avec images
//
// ─────────────────────────────────────────────
class HomeClientScreen extends StatefulWidget {
  const HomeClientScreen({super.key});

  @override
  State<HomeClientScreen> createState() => _HomeClientScreenState();
}

class _HomeClientScreenState extends State<HomeClientScreen> {
  bool _locationEnabled = false;
  int  _selectedNavIndex = 2;

  // ── données fictives (remplacer par vos vraies données / API) ──
  final List<NearbyStore> _stores = const [
    NearbyStore(
      name: 'LE MOULIN DORE',
      category: 'Boulangerie',
      address: 'Laprovale, Kouba',
      distance: 0.4,
      offersCount: 3,
      rating: 4.6,
      imageAsset: 'lib/images/moulin_dore.png',   // ← remplacer par votre asset
    ),
    NearbyStore(
      name: "L'ASSIETTE DES ANGLES",
      category: 'Restaurant',
      address: 'Jolie vue, Kouba',
      distance: 1.3,
      offersCount: 4,
      rating: 3.9,
      imageAsset: 'lib/images/assiette_angles.png',
    ),
    NearbyStore(
      name: 'LE PANIER FRAIS',
      category: 'Superette',
      address: 'Laprovale, Kouba',
      distance: 0.9,
      offersCount: 2,
      rating: 4.6,
      imageAsset: 'lib/images/panier_frais.png',
    ),
  ];

  // ── couleur catégorie ──
  Color _catColor(String c) {
    switch (c) {
      case 'Boulangerie': return AppColors.accent;
      case 'Restaurant':  return AppColors.chipDark;
      case 'Superette':   return const Color(0xFF5A9E8B);
      default:            return AppColors.textMuted;
    }
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      
      backgroundColor: AppColors.scaffold,
     
      body: Container(
        child: Stack(
          children: [
            // ── contenu scrollable ──
            CustomScrollView(
              
              slivers: [
                SliverToBoxAdapter(child: _appBar()),
                
                SliverToBoxAdapter(child: _sectionHeader('Catégories', 'Voir tout')),
                
                SliverToBoxAdapter(child: _categories()),
                SliverToBoxAdapter(child: _sectionHeader('Offres spéciales', 'Voir tout')),
                SliverToBoxAdapter(child: _offersCarousel()),
                SliverToBoxAdapter(child: _sectionHeader('Près de vous', 'Voir la carte')),
                SliverToBoxAdapter(child: _minimapSection()),
                // ── SWITCH D'ÉTAT ──
                SliverToBoxAdapter(                  
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: _locationEnabled
                         
                        ? _nearbyList(key: const ValueKey('list'))
                        : _locationPrompt(key: const ValueKey('prompt')),
                  ),
                ),
        
                const SliverToBoxAdapter(child: SizedBox(height: 110)),
              ],
            ),
        
            // ── FAB panier ──
            Positioned(bottom: 74, right: 16, child: _cartFab()),
        
            // ── bottom nav ──
            Positioned(bottom: 0, left: 0, right: 0, child: _bottomNav()),
          ],
        ),
      ),
      
    );
    
  }
 
    
      
// ─────────────────────────────────────────────
  // APP BAR
  // ─────────────────────────────────────────────      
 Widget _appBar() {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFCCD5AE),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.offerCardBg, width: 2),
    ),
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top + 30,
      bottom: 50,
      left: 20,
      right: 20,
    ),
    child: Column(
      children: [

        // ── Ligne 1 : Logo + Localisation + Icône Search ──
        Row(
          children: [
            // Logo
            Image.asset(
              'lib/images/laaisraf_logo.png',
              height: 60,
              errorBuilder: (_, __, ___) => Container(
                width: 30, height: 30,
                decoration: const BoxDecoration(
                  color: AppColors.accent, shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),

            const Spacer(),

            // Localisation
            GestureDetector(
              onTap: () => setState(() => _locationEnabled = !_locationEnabled),
              onLongPress: () => Navigator.pushNamed(context, '/acces_rapide'),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 15, color: AppColors.textDark),
                  const SizedBox(width: 5),
                  Text(
                    _locationEnabled ? 'Kouba, Alger' : 'Localisation',
                    style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 20, color: AppColors.textDark),
                ],
              ),
            ),

            const Spacer(),

            // ── Icône Search (remplace la barre sur cette ligne) ──
            
          ],
        ),

        const SizedBox(height: 20), // ← espace entre les 2 lignes

        // ── Ligne 2 : Barre de recherche complète ──
        Container(
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFCCD1AE),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.white, width: 0.5),
          ),
          child: const Row(
            children: [
              SizedBox(width: 20),
              Icon(Icons.search, color: AppColors.chipDark, size: 20),
              SizedBox(width: 10),
              Text(
                'Rechercher...',
                style: TextStyle(color: AppColors.chipDark, fontSize: 14),
              ),
            ],
          ),
        ),

      ],
    ),
  );
}
 
  // ─────────────────────────────────────────────
  // EN-TÊTE DE SECTION
  // ─────────────────────────────────────────────
  Widget _sectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
            style: const TextStyle(fontSize: 20, 
            fontWeight: FontWeight.w800, 
            color: AppColors.textDark)),
          GestureDetector(
          // ← AJOUTER
          onTap: action == 'Voir la carte'
              ? () => Navigator.pushNamed(context, '/carte')
              : null,

              child:   Text(action,
               style: const TextStyle(
              fontSize: 13, 
              fontWeight: FontWeight.w500,
               color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CATÉGORIES
  // ─────────────────────────────────────────────
  Widget _categories() {
    final cats = ['Boulangerie', 'Restaurant', 'Pâtisserie', 'Superette', 'Café'];
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),          
          decoration: BoxDecoration(color: const Color.fromARGB(255, 204, 213, 174), borderRadius: BorderRadius.circular(20),
          border: Border.all(
          color: AppColors.navBg ,       // ← bordure blanche
          width: 4,
          ),
          ),
          child: Text(cats[i],
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 7, 7, 7))),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CARROUSEL OFFRES SPÉCIALES
  // Ajouter des éléments à _offers pour avoir plusieurs cartes
  // ─────────────────────────────────────────────
  final List<OffreDetail> _offers = const [
  OffreDetail(
    id: 'o1',
    nom: 'Corbeille du Matin',
    commercant: 'La Maison du Pain',
    adresse: 'Laprovale, Kouba',
    prix: '350 DA',
    prixOriginal: '600 DA',
    distance: '0.4 km',
    note: 4.6,
    restants: 5,
    creneau: '07:00 – 10:00',
    categorie: 'Boulangerie',
    imageAsset: 'lib/images/offre_maison_pain.png',
    description:
        'Profitez d\'une corbeille généreuse préparée chaque matin avec nos '
        'pains et viennoiseries du jour. Une belle façon de commencer la '
        'journée tout en évitant le gaspillage alimentaire.',
    contenu: [
      '1 baguette tradition',
      '2 croissants au beurre',
      '1 pain de campagne (250 g)',
      '2 pains au chocolat',
    ],
  ),
  OffreDetail(
    id: 'o2',
    nom: 'Menu Café du Coin',
    commercant: 'Le Café du Coin',
    adresse: 'Jolie vue, Kouba',
    prix: '780 DA',
    prixOriginal: '1100 DA',
    distance: '1.3 km',
    note: 4.2,
    restants: 2,
    creneau: '12:00 – 15:00',
    categorie: 'Restaurant',
    imageAsset: 'lib/images/offre_burger.png',
    description:
        'Notre burger maison préparé avec des ingrédients frais du marché local, '
        'accompagné de frites croustillantes et d\'une boisson au choix. '
        'Quantités limitées — ne tardez pas !',
    contenu: [
      '1 burger maison (bœuf 180 g)',
      '1 portion de frites',
      '1 boisson au choix',
      '1 sauce maison',
    ],
  ),
];

  Widget _offersCarousel() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _offers.length,
        itemBuilder: (_, i) {
  final offre = _offers[i];
  return GestureDetector(
    onTap: () => Navigator.pushNamed(
      context,
      '/offre_detail',
      arguments: offre,           // ← on passe l'objet OffreDetail
    ),
    child: Container(
      width: 240,
      height: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.offerCardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: _activeOfferContent(
        imagePath: offre.imageAsset ?? '',
        title: offre.commercant,
        subtitle: offre.categorie.toUpperCase(),
      ),
    ),
  );
},
      ),
    );
  }
       
Widget _minimapSection() {
  if (!_locationEnabled) return const SizedBox.shrink();
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 10, 8),
    child: GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/carte'),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: AppColors.offerCardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              // Fond vert carte
              Container(
                color: const Color(0xFFD4E6C3),
                child: const Center(
                  child: Icon(Icons.map_outlined,
                      size: 40, color: Color(0xFF6B7C4E)),
                ),
              ),
              // Overlay gradient bas
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.35),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Label bas gauche
              const Positioned(
                bottom: 20, left: 14,
                child: Row(
                  children: [
                    Icon(Icons.location_on,
                        color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text('Voir la carte complète',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              // Marqueur Boulangerie
              Positioned(
                top: 30, left: 80,
                child: Container(
                  width: 28, height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                      Icons.bakery_dining_outlined,
                      color: Colors.white, size: 13),
                ),
              ),
              // Marqueur Restaurant
              Positioned(
                top: 30, right: 90,
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.chipDark,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                      Icons.restaurant_outlined,
                      color: Colors.white, size: 13),
                ),
              ),
              // Marqueur Superette
              Positioned(
                top: 60, left: 140,
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5A9E8B),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                      Icons.shopping_basket_outlined,
                      color: Colors.white, size: 13),
                ),
              ),
              // Point utilisateur (bleu)
              Positioned(
                top: 45, left: 110,
                child: Container(
                  width: 14, height: 14,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
 
  Widget _activeOfferContent({
    required String imagePath,
    required String title,
    required String subtitle,
  }) {
    return Stack(
      children: [
        // ── IMAGE DE FOND pleine carte ─────────────────────────────
        // fit: BoxFit.cover  → remplit toute la carte (recadre si besoin)
        // fit: BoxFit.fill   → étire l'image pour remplir exactement
        // fit: BoxFit.fitWidth → ajuste sur la largeur, peut couper en hauteur
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,     // ← modifier ici pour changer le comportement
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                // Fallback visible pour déboguer (indique le chemin manquant)
                return Container(
                  color: AppColors.offerCardBg,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.broken_image_outlined, size: 40, color: AppColors.textMuted),
                        const SizedBox(height: 6),
                        Text(
                          imagePath.split('/').last,
                          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // ── LABEL flottant sur l'image ─────────────────────────────
        Positioned(
          bottom: 22,
          left: 14,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFD4B896).withOpacity(0.88),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Georgia', fontSize: 15,
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.w700,
                    color: Color(0xFF5C3D1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 7.5, color: Color(0xFF5C3D1E), letterSpacing: 0.8),
                ),
              ],
            ),
          ),
        ),

        // ── Bouton favori ──────────────────────────────────────────
        Positioned(
          top: 10, right: 10,
          child: Container(
            width: 34, height: 34,
            decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
            child: const Icon(Icons.favorite_border, size: 17, color: AppColors.textDark),
          ),
        ),

        // ── Bouton flèche ──────────────────────────────────────────
        Positioned(
        top: 20, right: 10,
        child: Container(
          width: 8, height: 8,
          decoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    ],
  );
  }

  // ─────────────────────────────────────────────
  // ÉTAT 1 — PROMPT LOCALISATION
  // ─────────────────────────────────────────────
  Widget _locationPrompt({Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Container(
              width: 58, height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFFB5C49E).withOpacity(0.45),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.map_outlined, size: 34, color: AppColors.textDark),
            ),
            const SizedBox(height: 2),
            const Text('Activez votre localisation',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark)),
            const SizedBox(height: 10),
            const Text(
              'Activez votre localisation pour découvrir les commerçants près de vous et profiter des meilleures offres autour de vous.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: AppColors.textMuted, height: 1.55),
            ),
            const SizedBox(height: 20),
            // ── bouton principal → bascule vers état 2 ──
            GestureDetector(
              onTap: () => setState(() => _locationEnabled = true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.divider, width: 1.5),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_outlined, size: 15, color: AppColors.textDark),
                    SizedBox(width: 6),
                    Text('Activez votre localisation',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            // ── lien manuel → bascule aussi ──
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/acces_rapide'), // ← MODIFIER
              child: const Text('Entrer une adresse manuellement',
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textMuted,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.textMuted,
                )),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ÉTAT 2 — LISTE DES COMMERCES PROCHES
  // ─────────────────────────────────────────────
  Widget _nearbyList({Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _stores.map(_storeCard).toList(),
      ),
    );
  }

  Widget _storeCard(NearbyStore s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          // ── image du commerce ──
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 60, height: 60,
              child: s.imageAsset != null
                  // Image locale (asset)
                  ? Image.asset(s.imageAsset!, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _storeIconPlaceholder())
                  // Fallback icône
                  : _storeIconPlaceholder(),
            ),
          ),
          const SizedBox(width: 12),

          // ── infos ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(s.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5, fontWeight: FontWeight.w800,
                          color: AppColors.textDark, letterSpacing: 0.2,
                        )),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: AppColors.accent),
                        const SizedBox(width: 2),
                        Text(s.rating.toString(),
                          style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(s.category,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _catColor(s.category))),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 11, color: AppColors.textMuted),
                        const SizedBox(width: 2),
                        Text(s.address,
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                    Row(
                      children: [
                        Text('${s.distance} km',
                          style: const TextStyle(
                            fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('${s.offersCount} offres',
                            style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Fallback quand l'image n'est pas disponible
  Widget _storeIconPlaceholder() {
    return Container(
      color: AppColors.storeIconBg,
      child: const Center(
        child: Icon(Icons.storefront_outlined, color: Color(0xFF7A6A50), size: 28),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // FAB PANIER
  // ─────────────────────────────────────────────
  Widget _cartFab() {
  return GestureDetector(                                     // ← AJOUTER
    onTap: () => Navigator.pushNamed(context, '/cart'),       // ← AJOUTER
    child: Container(
      width: 50, height: 50,
      decoration: BoxDecoration(
        color: AppColors.accent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.shopping_cart_outlined,
        color: AppColors.white,
        size: 22,
      ),
    ),
  );                                                          // ← AJOUTER
}
  // ─────────────────────────────────────────────
  // BOTTOM NAV
  // ─────────────────────────────────────────────
  Widget _bottomNav() {
  final icons = [
    Icons.favorite_border,
    Icons.search,
    Icons.home_outlined,
    Icons.shopping_bag_outlined,   // ← index 3 : réservations
    Icons.person_outline,
    Icons.filter_rounded,
  ];
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
        final bool sel = i == _selectedNavIndex;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedNavIndex = i);
            // ── NAVIGATIONS ──────────────────────────────
            if (i == 0) {
              // ❤️ → Accès rapide (adresses favorites)
              Navigator.pushNamed(context, '/acces_rapide');
            }
            if (i == 1) {
              // 🔍 → Carte / Recherche
              Navigator.pushNamed(context, '/carte');
            }
            if (i == 3) {
              // 🛍️ → Réservations
              Navigator.pushNamed(context, '/reservations');
            }
            if (i == 4) {
              // 👤 → Notifications client (profil à venir)
              Navigator.pushNamed(context, '/notifications_client');
            }
            if (i == 5) {
              // ⚙️ → Filtre client (profil à venir)
              Navigator.pushNamed(context, '/filtre_screen');
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: sel ? AppColors.white : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icons[i],
              size: 22,
              color: sel
                  ? AppColors.textDark
                  : AppColors.textDark.withOpacity(0.55),
            ),
          ),
        );
      }),
    ),
  );
}
}