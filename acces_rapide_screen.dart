// ─────────────────────────────────────────────
//  ACCÈS RAPIDE — Adresses favorites
//  - Liste avec mode édition
//  - Ajouter / Modifier / Supprimer
// ─────────────────────────────────────────────
// ignore_for_file: recursive_getters, non_constant_identifier_names, unused_element, no_leading_underscores_for_local_identifiers, prefer_final_fields, unused_field, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:laaisraf/home_client_screen.dart';

// ─────────────────────────────────────────────
// COULEURS
// ─────────────────────────────────────────────
class _C {
  static const bg       = Color(0xFFFAEDCD);
  static const card     = Color(0xFFFFFFFF);
  static const accent   = Color(0xE4F9AE63);
  static const accentBg = Color(0xFFFAEEDA);
  static const textDark = Color(0xFF2C2814);
  static const textMut  = Color(0xFF8A8070);
  static const divider  = Color(0xFFD9D0BF);
  static const input    = Color(0xFFFAEDCD);
  static const iconBg   = Color(0xFFFAEDCD);
}

// ─────────────────────────────────────────────
// MODÈLE
// ─────────────────────────────────────────────
enum TypeAdresse { maison, universite, famille, travail, autre }

extension TypeAdresseExt on TypeAdresse {
  String get label {
    switch (this) {
      case TypeAdresse.maison:     return 'Maison';
      case TypeAdresse.universite: return 'Université';
      case TypeAdresse.famille:    return 'Chez la famille';
      case TypeAdresse.travail:    return 'Travail';
      case TypeAdresse.autre:      return 'Autre';
    }
  }

String get ImagePath {
    switch (this) {
      case TypeAdresse.maison:     return 'lib/images/home.png';
      case TypeAdresse.universite: return 'lib/images/univ.png';
      case TypeAdresse.famille:    return 'lib/images/famille.png';
      case TypeAdresse.travail:    return 'lib/images/travail.png';
      case TypeAdresse.autre:      return 'lib/images/autre.png';
      
    }
  }
}

class AdresseFavorite {
  final String id;
  String nom;
  String adresse;
  TypeAdresse type;
   final String? ImageWidget;
 
   AdresseFavorite({
    required this.id,
    required this.nom,
    required this.adresse,
    required this.type, 
    this.ImageWidget,
  });
}

// ─────────────────────────────────────────────
// DONNÉES FICTIVES
// ─────────────────────────────────────────────
final List<AdresseFavorite> _adresses = [
  AdresseFavorite(
    id: 'a1',
    nom: 'Maison',
    adresse: 'Laprovale, Kouba, Alger',
    type: TypeAdresse.maison,
    
  ),
  AdresseFavorite(
    id: 'a2',
    nom: 'Université',
    adresse: 'Ouad Smar, El harach, Alger',
    type: TypeAdresse.universite,
  ),
  AdresseFavorite(
    id: 'a3',
    nom: 'Chez la famille',
    adresse: 'Aïn Naadja',
    type: TypeAdresse.famille,
  ),
];
// ─────────────────────────────────────────────
// ACCÈS RAPIDE SCREEN
// ─────────────────────────────────────────────
class AccesRapideScreen extends StatefulWidget {
  const AccesRapideScreen({super.key});

  @override
  State<AccesRapideScreen> createState() =>
      _AccesRapideScreenState();
}
class _AccesRapideScreenState extends State<AccesRapideScreen> {
  bool _modeEdition = false;
  
  final _rechercheCtrl = TextEditingController();
  
  @override
  void dispose() {
    _rechercheCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 237, 205),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _appBar(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text('Accès rapide',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: _C.textDark)),
                    const SizedBox(height: 14),
                    // Liste adresses
                    ..._adresses
                        .map((a) => _adresseItem(a))
                        ,
                    const SizedBox(height: 8),
                    // Bouton Ajouter
                    if (!_modeEdition)
                      _boutonAjouter(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
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
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.offerCardBg, width: 3),
    ),
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top + 20,
      bottom: 20,
      left: 20,
      right: 20,
    ),
    child: Column(
      children: [

        // ── Ligne 1 : Logo + Localisation ──
        Row(
          children: [
            Image.asset(
              'lib/images/laaisraf_logo.png',
              height: 50,
              errorBuilder: (_, __, ___) => Container(
                width: 45, height: 50,
                decoration: const BoxDecoration(
                  color: AppColors.accent, shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── Ligne 2 : Search Bar + Modifier (même Row) ──
        Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFCCD1AE),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.white, width: 0.5),
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 5),
                    Icon(Icons.search, color: AppColors.chipDark, size: 20),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ── Bouton Modifier / Terminer ──
            GestureDetector(
              onTap: () => setState(() => _modeEdition = !_modeEdition),
              child: Text(
                _modeEdition ? 'Terminer' : 'Modifier',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _C.textDark,
                ),
              ),
            ),
          ],
        ),

      ],
    ),
  );
}
   // ─────────────────────────────────────────────
  // ITEM ADRESSE
  // ─────────────────────────────────────────────
  Widget _adresseItem(AdresseFavorite a) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color:  const Color.fromARGB(70, 250, 170, 80), 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: _C.textDark.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          // Icône type
          Container(
            width: 50, height:50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(228, 250, 200, 130),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
              color: const Color.fromARGB(255, 67, 65, 63).withOpacity(0.5)),
            ),
            child: Image.asset(a.type.ImagePath,
                width: 22),
          ),
          const SizedBox(width: 12),
          // Infos
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.nom,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _C.textDark)),
                const SizedBox(height: 2),
                Text(a.adresse,
                    style: const TextStyle(
                        fontSize: 11.5,
                        color: _C.textMut),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          // Actions en mode édition
          if (_modeEdition) ...[
            const SizedBox(width: 8),
            // Modifier
            GestureDetector(
              onTap: () => _ouvrirModifier(a),
              child: Container(
                width: 34, height: 34,
                decoration: BoxDecoration(
                  color: _C.iconBg,
                  borderRadius: BorderRadius.circular(10),
                 border: Border.all(
              color: const Color.fromARGB(255, 67, 65, 63).withOpacity(0.5)), 
                ),
                child: const Icon(Icons.edit_outlined,
                    size: 16, color: _C.textDark),
              ),
            ),
            const SizedBox(width: 8),
            // Supprimer
            GestureDetector(
              onTap: () => _confirmerSuppression(a),
              child: Container(
                width: 34, height: 34,
                decoration: BoxDecoration(
                  color: _C.accentBg,
                  borderRadius: BorderRadius.circular(10),
                border: Border.all(
              color: const Color.fromARGB(255, 67, 65, 63).withOpacity(0.5)),  
                ),
                child: const Icon(Icons.delete_outline,
                    size: 16, color: _C.accent),
              ),
            ),
          ],
        ],
      ),
    );
  }
  // ─────────────────────────────────────────────
  // BOUTON AJOUTER
  // ─────────────────────────────────────────────
  Widget _boutonAjouter() {
    return GestureDetector(
      onTap: () => _ouvrirAjouter(),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical:20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(228, 250, 220, 180),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: const Color.fromARGB(255, 67, 65, 63).withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: const Color.fromARGB(228, 250, 237, 205),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color.fromARGB(255, 53, 52, 50).withOpacity(0.5)),
              ),
              child: const Icon(Icons.add,
                  size: 40, color: _C.textDark),
            ),
            const SizedBox(width: 12),
            const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ajouter une adresse',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _C.textDark)),
                SizedBox(height: 2),
                Text('Maison, travail ou lieu personnalisé',
                    style: TextStyle(
                        fontSize: 11.5,
                        color: _C.textMut)),

              ],
            ),
          ],
        ),
        
      ),
      
    );
    
  }

  // ─────────────────────────────────────────────
  // BOTTOM SHEET — SUPPRIMER
  // ─────────────────────────────────────────────
  void _confirmerSuppression(AdresseFavorite a) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(
            20, 24, 20,
            MediaQuery.of(context).padding.bottom + 24),
        decoration: const BoxDecoration(
           
          color: Color(0xFFFAEDCD),
          borderRadius: BorderRadius.vertical( top: Radius.circular(28),),  

              
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Poignée
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                  color: _C.divider,
                  borderRadius: BorderRadius.circular(2)),
            ),
            // Icône
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: _C.accentBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_forever,
                  size: 60, color: _C.accent),
            ),
            const SizedBox(height: 20),
            const Text('Supprimer ce lieu ?',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _C.textDark)),
            const SizedBox(height: 8),
            Text(
              'Voulez-vous supprimer "${a.nom}" de vos adresses ?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13,
                  color: _C.textMut,
                  height: 1.5),
            ),
            const SizedBox(height: 24),
            // Bouton Oui
            GestureDetector(
              onTap: () {
                setState(() => _adresses.remove(a));
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: _C.accent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text('Oui, Supprimer',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Bouton Annuler
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: _C.input,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text('Annuler',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _C.textDark)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BOTTOM SHEET — MODIFIER
  // ─────────────────────────────────────────────
  void _ouvrirModifier(AdresseFavorite a) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FormulaireAdresse(
        adresse: a,
        onSave: (nom, adresseText, type) {
          setState(() {
            a.nom = nom;
            a.adresse = adresseText;
            a.type = type;
          });
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BOTTOM SHEET — AJOUTER
  // ─────────────────────────────────────────────
  void _ouvrirAjouter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FormulaireAdresse(
        adresse: null,
        onSave: (nom, adresseText, type) {
          setState(() {
            _adresses.add(AdresseFavorite(
              id: DateTime.now()
                  .millisecondsSinceEpoch
                  .toString(),
              nom: nom,
              adresse: adresseText,
              type: type,
            ));
          });
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FORMULAIRE ADRESSE (Ajouter & Modifier)
// ─────────────────────────────────────────────
class _FormulaireAdresse extends StatefulWidget {
  final AdresseFavorite? adresse;
  final void Function(String nom, String adresse,
      TypeAdresse type) onSave;

  const _FormulaireAdresse({
    required this.adresse,
    required this.onSave,
  });

  @override
  State<_FormulaireAdresse> createState() =>
      _FormulaireAdresseState();
}

class _FormulaireAdresseState
    extends State<_FormulaireAdresse> {
  late final TextEditingController _nomCtrl;
  late final TextEditingController _adresseCtrl;
  late TypeAdresse _typeSelectionne;

  bool get _estModif => widget.adresse != null;

  @override
  void initState() {
    super.initState();
    _nomCtrl = TextEditingController(
        text: widget.adresse?.nom ?? '');
    _adresseCtrl = TextEditingController(
        text: widget.adresse?.adresse ?? '');
    _typeSelectionne =
        widget.adresse?.type ?? TypeAdresse.maison;
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _adresseCtrl.dispose();
    super.dispose();
  }

  void _enregistrer() {
    if (_nomCtrl.text.trim().isEmpty ||
        _adresseCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Remplissez le nom et l\'adresse.'),
          backgroundColor: Color(0xFFD64545),
        ),
      );
      return;
    }
    widget.onSave(
      _nomCtrl.text.trim(),
      _adresseCtrl.text.trim(),
      _typeSelectionne,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F0E3),
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              20, 16, 20,
              MediaQuery.of(context).padding.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poignée + icône
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: const Color(0xFFD9D0BF),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Center(
                child: Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: _C.accentBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _estModif
                        ? Icons.edit_outlined
                        : Icons.add_location_alt_outlined,
                    size: 30,
                    color: _C.accent,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Chips type (uniquement à l'ajout)
              if (!_estModif) ...[
                const Text('Ajouter une adresse',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _C.textDark)),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: TypeAdresse.values
                        .map((t) => GestureDetector(
                              onTap: () => setState(
                                  () => _typeSelectionne = t),
                              child: AnimatedContainer(
                                duration: const Duration(
                                    milliseconds: 180),
                                margin: const EdgeInsets.only(
                                    right: 8),
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8),
                                decoration: BoxDecoration(
                                  color: _typeSelectionne == t
                                      ? _C.accentBg
                                      : _C.input,
                                  borderRadius:
                                      BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _typeSelectionne == t
                                        ? _C.accent
                                            .withOpacity(0.5)
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(t.ImagePath,
                                        width: 60,
                                      //  color:
                                         //   _typeSelectionne == t
                                               // ? _C.accent
                                               // : _C.textMut
                                                ),
                                    const SizedBox(height: 4),
                                    Text(t.label,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight:
                                                FontWeight.w600,
                                            color:
                                                _typeSelectionne == t
                                                    ? _C.accent
                                                    : _C.textMut)),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Nom du lieu
              const Text('Nom du lieu',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _C.textDark)),
              const SizedBox(height: 8),
              _champ(_nomCtrl, 'Travail'),

              const SizedBox(height: 16),

              // Adresse complète
              const Text('Adresse complète',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _C.textDark)),
              const SizedBox(height: 8),
              _champ(_adresseCtrl,
                  'Rue, commune, Wilaya…'),

              const SizedBox(height: 12),

              // Pinpoint carte
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 46,
                  decoration: BoxDecoration(
                    color: _C.input,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: _C.divider),
                  ),
                  child: const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_outlined,
                          size: 30, color: _C.textMut),
                      SizedBox(width: 8),
                      Text('Pointer sur la carte',
                          style: TextStyle(
                              fontSize: 13,
                              color: _C.textMut,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Bouton Enregistrer
              GestureDetector(
                onTap: _enregistrer,
                child: Container(
                  width: double.infinity,
                  height: 60,
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
                  child: const Center(
                    child: Text('Enregistrer',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _champ(TextEditingController ctrl, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: _C.input,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.divider),
      ),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(
            fontSize: 13, color: _C.textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: _C.textMut.withOpacity(0.7),
              fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 30, vertical:20),
        ),
      ),
    );
  }
   
}