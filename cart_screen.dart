// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
// MODÈLE — Article du panier
// ─────────────────────────────────────────────
class CartItem {
  final String id;
  final String nom;
  final String commercant;
  final String categorie;
  final String imageAsset;
  final double prix;
  final double prixOriginal;

  int quantite;

  CartItem({
    required this.id,
    required this.nom,
    required this.commercant,
    required this.categorie,
    required this.imageAsset,
    required this.prix,
    required this.prixOriginal,
    this.quantite = 1, 
    
  });

  double get sousTotal => prix * quantite;
}

// ─────────────────────────────────────────────
// COULEURS (reprises de AppColors dans peeco_app.dart)
// ─────────────────────────────────────────────
class _C {
  static const scaffold    = Color(0xFFE8E0CE);
  static const accent      = Color(0xFFE07B39);
  static const cardBg      = Color(0xFFF5F0E3);
  static const textDark    = Color(0xFF2C2814);
  static const textMuted   = Color(0xFF8A8070);
  static const navBg       = Color(0xFFB5C49E);
  static const white       = Color(0xFFFFFFFF);
  static const divider     = Color(0xFFD9D0BF);
  static const chipDark    = Color(0xFF6B7C4E);
  static const danger      = Color(0xFFD64545);
  static const appBarBg    = Color(0xFFCCD5AE);
  static const appBarBorder= Color(0xFFC8B99A);
}

// ─────────────────────────────────────────────
// CART SCREEN
// ─────────────────────────────────────────────
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  // ── données fictives (à remplacer par votre provider / state management) ──
  final List<CartItem> _items = [
    CartItem(
      id: '1',
      nom: 'Corbeille du Matin',
      commercant: 'Le Moulin Doré',
      categorie: 'Boulangerie',
      imageAsset: 'assets/images/corbeille_matin.png',
      prix: 350,
      prixOriginal: 600,
      quantite: 1,
     
    ),
    CartItem(
      id: '2',
      nom: 'Burger Maison + Frites',
      commercant: "L'Assiette des Angles",
      categorie: 'Restaurant',
      imageAsset: 'assets/images/burger_house2.png',
      prix: 780,
      prixOriginal: 1100,
      quantite: 2,
    ),
    CartItem(
      id: '3',
      nom: 'Panier Légumes Frais',
      commercant: 'Le Panier Frais',
      imageAsset: 'assets/images/legumes_frais.png',
      categorie: 'Superette',
      prix: 450,
      prixOriginal: 700,
      quantite: 1,
    ),
    CartItem(
     id: '4',
    nom: 'Le Moulin Doré',
    commercant: '',
    imageAsset: 'assets/images/moulin_dore.png', 
    categorie: 'Boulangerie',
    prix:450 ,
    prixOriginal: 700,
    quantite: 2,       
    ),
    CartItem(
     id: '5',
     nom: 'Burger House',
      categorie: 'Restaurant',
      commercant: 'Vieux Kouba, Kouba, Alger',
      prix:500,
      prixOriginal: 1.5,
      quantite: 4,
      imageAsset: 'assets/images/burger_house2.png',
    ),
  ];

  // ── totaux ──
  double get _sousTotal  => _items.fold(0, (s, i) => s + i.sousTotal);
  double get _economies  => _items.fold(0, (s, i) => (i.prixOriginal - i.prix) * i.quantite);
  double get _total      => _sousTotal;

  // ── couleur catégorie ──
  Color _catColor(String c) {
    switch (c) {
      case 'Boulangerie': return _C.accent;
      case 'Restaurant':  return _C.chipDark;
      case 'Superette':   return const Color(0xFF5A9E8B);
      default:            return _C.textMuted;
    }
  }

  Object _catIcon(String c) {
    switch (c) {
      case 'Boulangerie': return Image.asset('assets/images/corbeille_matin.png');
      case 'Restaurant':  return Image.asset('assets/images/burger_house.png');
      case 'Superette':   return Image.asset('assets/images/legumes_frais.png');
      default:            return Icons.storefront_outlined;
    }
  }

  void _incrementer(CartItem item) => setState(() => item.quantite++);

  void _decrementer(CartItem item) {
    setState(() {
      if (item.quantite > 1) {
        item.quantite--;
      } else {
        _items.remove(item);
      }
    });
  }

  void _supprimer(CartItem item) {
    setState(() => _items.remove(item));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.nom} retiré du panier'),
        backgroundColor: _C.textDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmerCommande() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ConfirmationSheet(
        total: _total,
        nbArticles: _items.fold(0, (s, i) => s + i.quantite),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: _C.scaffold,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _appBar()),
              if (_items.isEmpty)
                SliverFillRemaining(child: _emptyState())
              else ...[
                SliverToBoxAdapter(child: _badgeEconomies()),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _articleCard(_items[i]),
                    childCount: _items.length,
                  ),
                ),
                SliverToBoxAdapter(child: _recapCommande()),
                const SliverToBoxAdapter(child: SizedBox(height: 130)),
              ],
            ],
          ),
          if (_items.isNotEmpty)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _boutonCommander(),
            ),
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
        bottom: 14,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          // Retour
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
          const Text(
            'Mon Panier',
            style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800,
              color: _C.textDark,
            ),
          ),
          const Spacer(),
          // Badge nombre d'articles
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: _C.accent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${_items.fold(0, (s, i) => s + i.quantite)}',
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w800,
                    color: _C.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BADGE ÉCONOMIES
  // ─────────────────────────────────────────────
  Widget _badgeEconomies() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFD4EBC5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF8AB87A).withOpacity(0.5)),
        ),
        child: Row(
          children: [
          //  const Icon(Icons.savings_outlined, size: 18, color: Color(0xFF3B6D11)),
            const SizedBox(width: 8),
            Text(
              'Vous économisez ${_economies.toStringAsFixed(0)} DA sur cette commande !',
              style: const TextStyle(
                fontSize: 12.5, fontWeight: FontWeight.w700,
                color: Color(0xFF3B6D11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CARTE ARTICLE
  // ─────────────────────────────────────────────
  Widget _articleCard(CartItem item) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        decoration: BoxDecoration(
          color: _C.danger,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: _C.white, size: 26),
      ),
      onDismissed: (_) => _supprimer(item),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.divider.withOpacity(0.6)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icône catégorie
            Container(
              width: 100, height:100,
              decoration: BoxDecoration(
                color: _catColor(item.categorie).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: _catColor(item.categorie).withOpacity(0.3)),
              ),
              child: _catIcon(item.categorie) as Widget,
            ),
            const SizedBox(width: 12),

            // Infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.nom,
                      style: const TextStyle(
                          fontSize: 13.5, fontWeight: FontWeight.w800,
                          color: _C.textDark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(item.commercant,
                      style: const TextStyle(
                          fontSize: 11.5, color: _C.textMuted)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('${item.prix.toStringAsFixed(0)} DA',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w800,
                              color: _C.accent)),
                      const SizedBox(width: 6),
                      Text('${item.prixOriginal.toStringAsFixed(0)} DA',
                          style: const TextStyle(
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                              color: _C.textMuted)),
                    ],
                  ),
                ],
              ),
            ),

            // Contrôle quantité
            Column(
              children: [
                _qtyButton(Icons.add, () => _incrementer(item)),
                const SizedBox(height: 4),
                Text('${item.quantite}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800,
                        color: _C.textDark)),
                const SizedBox(height: 4),
                _qtyButton(
                  item.quantite == 1 ? Icons.delete_outline : Icons.remove,
                  () => _decrementer(item),
                  danger: item.quantite == 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap,
      {bool danger = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(
          color: danger
              ? _C.danger.withOpacity(0.1)
              : _C.navBg.withOpacity(0.45),
          shape: BoxShape.circle,
          border: Border.all(
              color: danger
                  ? _C.danger.withOpacity(0.3)
                  : _C.divider,
              width: 0.8),
        ),
        child: Icon(icon,
            size: 15,
            color: danger ? _C.danger : _C.textDark),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // RÉCAP COMMANDE
  // ─────────────────────────────────────────────
  Widget _recapCommande() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _C.divider.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Récapitulatif',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w800,
                  color: _C.textDark)),
          const SizedBox(height: 12),
          _ligneRecap('Sous-total',
              '${_sousTotal.toStringAsFixed(0)} DA'),
          const SizedBox(height: 6),
          _ligneRecap('Économies',
              '- ${_economies.toStringAsFixed(0)} DA',
              valueColor: const Color(0xFF3B6D11)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: _C.divider, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w800,
                      color: _C.textDark)),
              Text('${_total.toStringAsFixed(0)} DA',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w900,
                      color: _C.accent)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ligneRecap(String label, String valeur, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: _C.textMuted)),
        Text(valeur,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: valueColor ?? _C.textDark)),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // ÉTAT VIDE
  // ─────────────────────────────────────────────
  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                color: _C.navBg.withOpacity(0.35),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_cart_outlined,
                  size: 44, color: _C.textMuted),
            ),
            const SizedBox(height: 20),
            const Text('Votre panier est vide',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800,
                    color: _C.textDark)),
            const SizedBox(height: 10),
            const Text(
              'Ajoutez des offres depuis la page principale pour les retrouver ici.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13, color: _C.textMuted, height: 1.55),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: _C.accent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text('Explorer les offres',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: _C.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BOUTON COMMANDER (sticky bottom)
  // ─────────────────────────────────────────────
  Widget _boutonCommander() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: _C.scaffold,
        border: Border(
            top: BorderSide(color: _C.divider.withOpacity(0.5))),
      ),
      child: GestureDetector(
        onTap: _confirmerCommande,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: _C.accent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: _C.accent.withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline,
                  color: _C.white, size: 20),
              const SizedBox(width: 10),
              const Text('Confirmer la commande',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _C.white)),
              const SizedBox(width: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _C.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${_total.toStringAsFixed(0)} DA',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _C.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BOTTOM SHEET — CONFIRMATION
// ─────────────────────────────────────────────
class _ConfirmationSheet extends StatelessWidget {
  final double total;
  final int nbArticles;

  const _ConfirmationSheet({
    required this.total,
    required this.nbArticles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).padding.bottom + 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F0E3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFD9D0BF),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            width: 64, height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFD4EBC5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_bag_outlined,
                size: 30, color: Color(0xFF3B6D11)),
          ),
          const SizedBox(height: 16),
          const Text('Confirmer votre commande ?',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800,
                  color: Color(0xFF2C2814))),
          const SizedBox(height: 8),
          Text(
            '$nbArticles article${nbArticles > 1 ? 's' : ''} · ${total.toStringAsFixed(0)} DA',
            style: const TextStyle(
                fontSize: 13.5, color: Color(0xFF8A8070)),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E0CE),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: const Color(0xFFD9D0BF)),
                    ),
                    child: const Center(
                      child: Text('Annuler',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Color(0xFF2C2814))),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Commande envoyée avec succès !'),
                        backgroundColor: const Color(0xFF3B6D11),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE07B39),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(
                      child: Text('Commander',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}