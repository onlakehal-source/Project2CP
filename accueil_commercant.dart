import 'package:flutter/material.dart';
import 'profile/profil_commercant.dart';
import 'statistiques_page.dart';

class AccueilCommercantPage extends StatefulWidget {
  const AccueilCommercantPage({super.key});

  @override
  State<AccueilCommercantPage> createState() => _AccueilCommercantPageState();
}

class _AccueilCommercantPageState extends State<AccueilCommercantPage> {
  int _selectedNavIndex = 2;

  static const Color topBarColor = Color(0xFFCCD5AE);
  static const Color backgroundColor = Color(0xFFFEFAE0);
  static const Color cardColor = Color(0xFFE9EDC9);
  static const Color orangeColor = Color(0xFFE8824A);
  static const Color brownColor = Color(0xFF5D4E37);
  static const Color selectedNavColor = Color(0xFFDDCD9E);
  static const Color unselectedNavColor = Color(0xFFE9EDC9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(height: 8, color: topBarColor),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildSectionLabel('Tableau de bord'),
                    const SizedBox(height: 14),
                    _buildStatsGrid(),
                    const SizedBox(height: 16),
                    _buildAlertBanner(),
                    const SizedBox(height: 20),
                    _buildReservationsSection(),
                    const SizedBox(height: 20),
                    _buildOffresSection(),
                    const SizedBox(height: 20),
                    _buildPerformancesSection(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFF8E1),
            border: Border.all(color: const Color(0xFF8B7355), width: 1.5),
          ),
          child: ClipOval(
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2691E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.lunch_dining,
                        color: Colors.white, size: 16),
                  ),
                  const Text('EL',
                      style: TextStyle(
                          fontSize: 6,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4037))),
                  const Text('BARAKA',
                      style: TextStyle(
                          fontSize: 5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5D4037))),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Boulangerie El Baraka',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3E2723),
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: const [
                Icon(Icons.location_on, size: 13, color: Color(0xFF757575)),
                SizedBox(width: 2),
                Text(
                  'Hussein Dey · Alger',
                  style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String title) {
    return Row(
      children: [
        const Icon(Icons.dashboard_outlined, size: 20, color: brownColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3E2723),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.shopping_bag_outlined,
                value: '8',
                label: 'Réservations\naujourd\'hui',
                badge: '+3 ↑',
                badgePositive: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.monetization_on_outlined,
                value: '4 320',
                subValue: 'DA récupérés\nce mois',
                label: 'DA récupérés\nce mois',
                badge: '+12% ↑',
                badgePositive: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.local_offer_outlined,
                value: '3',
                label: 'Offres actives',
                badge: '-1 ↓',
                badgePositive: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.star_border,
                value: '4.8',
                label: 'Note moyenne ★',
                badge: '+0.2 ↑',
                badgePositive: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    String? subValue,
    required String label,
    required String badge,
    required bool badgePositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 26, color: brownColor),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: badgePositive
                      ? const Color(0xFFDFF0D8)
                      : const Color(0xFFFFE0D0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: badgePositive
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFE53935),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3E2723),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF757575),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_outlined, size: 28, color: brownColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '2 réservations à préparer',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF3E2723),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Retrait dans moins de 1h · 17h00',
                  style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF9E9E9E)),
        ],
      ),
    );
  }

  Widget _buildReservationsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.shopping_cart_outlined, size: 20, color: brownColor),
                SizedBox(width: 8),
                Text(
                  'Réservations du jour',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3E2723),
                  ),
                ),
              ],
            ),
            Text(
              'Voir tout',
              style: TextStyle(
                fontSize: 13,
                color: orangeColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildReservationItem(
                initials: 'MB',
                name: 'Mohamed B.',
                detail: 'Panier boulangerie · 1 panier',
                time: '17h00',
                status: 'Bientôt',
                statusColor: orangeColor,
                hasDivider: true,
              ),
              _buildReservationItem(
                initials: '',
                name: 'karim M.',
                detail: 'Box viennoiseries · 2 paniers',
                time: '17h30',
                status: 'En attente',
                statusColor: const Color(0xFF9E9E9E),
                hasDivider: true,
                isIcon: true,
              ),
              _buildReservationItem(
                initials: 'OB',
                name: 'Omar B.',
                detail: 'Panier boulangerie · 1 panier',
                time: '19h00',
                status: 'Récupéré',
                statusColor: const Color(0xFF9E9E9E),
                hasDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReservationItem({
    required String initials,
    required String name,
    required String detail,
    required String time,
    required String status,
    required Color statusColor,
    required bool hasDivider,
    bool isIcon = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFD7CFC0),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isIcon
                      ? const Icon(Icons.person_outline,
                          size: 22, color: Color(0xFF5D4E37))
                      : Text(
                          initials,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF5D4E37),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF3E2723),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      detail,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF9E9E9E)),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: status == 'Bientôt'
                          ? const Color(0xFFFFE8D6)
                          : const Color(0xFFF0EDE6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (hasDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.white.withOpacity(0.5),
            indent: 14,
            endIndent: 14,
          ),
      ],
    );
  }

  Widget _buildOffresSection() {
    final offres = [
      {
        'title': 'Panier boulangerie',
        'price': '180Da',
        'reservations': '5 réservations',
      },
      {
        'title': 'Box viennoiseries',
        'price': '120 DA',
        'reservations': '2 réservations',
      },
      {
        'title': 'Panier surprise',
        'price': '160Da',
        'reservations': '10 reservations',
      },
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.local_offer_outlined, size: 20, color: brownColor),
                SizedBox(width: 8),
                Text(
                  'Mes offres actives',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3E2723),
                  ),
                ),
              ],
            ),
            Text(
              'Gérer',
              style: TextStyle(
                fontSize: 13,
                color: orangeColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: offres.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final offre = offres[index];
              return _buildOffreCard(
                title: offre['title']!,
                price: offre['price']!,
                reservations: offre['reservations']!,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOffreCard({
    required String title,
    required String price,
    required String reservations,
  }) {
    return Container(
      width: 115,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Container(
              height: 80,
              width: double.infinity,
              color: const Color(0xFFD7CFC0),
              child: const Icon(Icons.bakery_dining,
                  size: 36, color: Color(0xFF8B7355)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3E2723),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: orangeColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  reservations,
                  style:
                      const TextStyle(fontSize: 10, color: Color(0xFF9E9E9E)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformancesSection() {
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    final values = [0.35, 0.50, 0.60, 0.90, 0.45, 0.30, 0.25];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.show_chart, size: 20, color: brownColor),
            SizedBox(width: 8),
            Text(
              'Performances cette semaine',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3E2723),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(days.length, (i) {
              final isHighlighted = i == 3;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 28,
                    height: 80 * values[i],
                    decoration: BoxDecoration(
                      color:
                          isHighlighted ? orangeColor : const Color(0xFFD7CFC0),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    days[i],
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          isHighlighted ? orangeColor : const Color(0xFF9E9E9E),
                      fontWeight:
                          isHighlighted ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    final icons = [
      Icons.shopping_bag_outlined,
      Icons.add,
      Icons.home_outlined,
      Icons.show_chart,
      Icons.person_outline,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: topBarColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(icons.length, (index) {
          final isSelected = _selectedNavIndex == index;
          return GestureDetector(
            onTap: () {
              if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StatistiquesPage()),
                );
                return;
              }

              if (index == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfilCommercant()),
                );
                return;
              }
              setState(() => _selectedNavIndex = index);
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? selectedNavColor : unselectedNavColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFB8C49E), width: 1),
              ),
              child: Icon(
                icons[index],
                size: 24,
                color: isSelected
                    ? const Color(0xFF5D4037)
                    : const Color(0xFF7D7D7D),
              ),
            ),
          );
        }),
      ),
    );
  }
}
