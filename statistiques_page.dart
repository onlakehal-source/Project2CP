import 'package:flutter/material.dart';
import 'profile/profil_commercant.dart';

class StatistiquesPage extends StatefulWidget {
  const StatistiquesPage({super.key});

  @override
  State<StatistiquesPage> createState() => _StatistiquesPageState();
}

class _StatistiquesPageState extends State<StatistiquesPage> {
  int _selectedPeriod = 0;
  int _selectedNavIndex = 3;

  static const Color topBarColor = Color(0xFFCCD5AE);
  static const Color backgroundColor = Color(0xFFFEFAE0);
  static const Color cardColor = Color(0xFFE9EDC9);
  static const Color orangeColor = Color(0xFFE8824A);
  static const Color brownColor = Color(0xFF5D4E37);
  static const Color selectedNavColor = Color(0xFFDDCD9E);
  static const Color unselectedNavColor = Color(0xFFE9EDC9);
  static const Color darkCardColor = Color(0xFF8B9E6B);

  final List<String> periods = ['7 jours', '30 jours', '3 mois', '1 an'];

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
                    const Text(
                      'Statistiques',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3E2723),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPeriodSelector(),
                    const SizedBox(height: 16),
                    _buildRevenusCard(),
                    const SizedBox(height: 12),
                    _buildEvolutionCard(),
                    const SizedBox(height: 12),
                    _buildOffresNotesRow(),
                    const SizedBox(height: 12),
                    _buildVuesClientsRow(),
                    const SizedBox(height: 16),
                    _buildPerformanceCreneaux(),
                    const SizedBox(height: 16),
                    _buildMeilleuresOffres(),
                    const SizedBox(height: 16),
                    _buildSatisfactionClients(),
                    const SizedBox(height: 16),
                    _buildClientsFideles(),
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

  Widget _buildPeriodSelector() {
    return Row(
      children: List.generate(periods.length, (i) {
        final isSelected = _selectedPeriod == i;
        return GestureDetector(
          onTap: () => setState(() => _selectedPeriod = i),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? orangeColor : cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              periods[i],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : brownColor,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRevenusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenus récupérés',
            style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                '124 400',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3E2723),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4, left: 2),
                child: Text(
                  'DA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3E2723),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDFF0D8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '↑ +35%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4CAF50),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildMiniStat('712', 'Réservations'),
              _buildDivider(),
              _buildMiniStat('90%', 'Taux retrait'),
              _buildDivider(),
              _buildMiniStat('174DA', 'Moy./cmd'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3E2723),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 30,
      color: const Color(0xFFD0C8B0),
    );
  }

  Widget _buildEvolutionCard() {
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
            children: const [
              Icon(Icons.show_chart, size: 16, color: brownColor),
              SizedBox(width: 6),
              Text(
                'Évolution des revenus',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3E2723),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: CustomPaint(
              size: const Size(double.infinity, 80),
              painter: _LineChartPainter(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam']
                .map((d) => Text(d,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF9E9E9E))))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOffresNotesRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatSquare(
            icon: Icons.check_box_outlined,
            value: '7',
            label: 'Offres publiées',
            iconBg: cardColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatSquare(
            icon: Icons.star,
            value: '4.7',
            label: 'Note moyenne',
            iconBg: darkCardColor,
            iconColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildVuesClientsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatSquare(
            icon: Icons.remove_red_eye_outlined,
            value: '380',
            label: 'Vues des offres',
            iconBg: cardColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatSquare(
            icon: Icons.people_outline,
            value: '13',
            label: 'Clients uniques',
            iconBg: cardColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatSquare({
    required IconData icon,
    required String value,
    required String label,
    required Color iconBg,
    Color iconColor = const Color(0xFF5D4E37),
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3E2723),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCreneaux() {
    final creneaux = [
      {'label': '07h–09h', 'value': 0.45},
      {'label': '09h–11h', 'value': 0.62},
      {'label': '12h–14h', 'value': 0.78},
      {'label': '17h–19h', 'value': 1.0},
      {'label': '19h–21h', 'value': 0.85},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.access_time, size: 16, color: brownColor),
            SizedBox(width: 6),
            Text(
              'Performance par créneau',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3E2723),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ...creneaux.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text(
                            c['label'] as String,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF757575)),
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: c['value'] as double,
                              minHeight: 8,
                              backgroundColor: const Color(0xFFD7CFC0),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                c['value'] == 1.0 ? orangeColor : brownColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${((c['value'] as double) * 100).toInt()}%',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF3E2723)),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F0E0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '★  Meilleur créneau : 17h–19h (100% de retrait)',
                  style: TextStyle(fontSize: 12, color: brownColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMeilleuresOffres() {
    final offres = [
      {
        'rank': '1',
        'title': 'Panier boulangerie',
        'price': '180DA',
        'res': '10 réservations'
      },
      {
        'rank': '2',
        'title': 'Box viennoiseries',
        'price': '120 DA',
        'res': '5 réservations'
      },
      {
        'rank': '3',
        'title': 'Panier surprise',
        'price': '160DA',
        'res': '10 reservations'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.star_border, size: 16, color: brownColor),
            SizedBox(width: 6),
            Text(
              'Meilleures offres',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3E2723),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...offres.map((o) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: brownColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        o['rank']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7CFC0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.bakery_dining,
                        size: 24, color: Color(0xFF8B7355)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          o['title']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF3E2723),
                          ),
                        ),
                        Text(
                          o['res']!,
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF9E9E9E)),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        o['price']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: orangeColor,
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          size: 18, color: Color(0xFFBDBDBD)),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildSatisfactionClients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.favorite_border, size: 16, color: brownColor),
            SizedBox(width: 6),
            Text(
              'Satisfaction clients',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3E2723),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '4.8',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w700,
                      color: orangeColor,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(Icons.star, color: orangeColor, size: 16),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('67 avis',
                      style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E))),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _buildRatingBar(5, 0.72, '72%'),
                    const SizedBox(height: 5),
                    _buildRatingBar(4, 0.18, '18%'),
                    const SizedBox(height: 5),
                    _buildRatingBar(3, 0.07, '7%'),
                    const SizedBox(height: 5),
                    _buildRatingBar(2, 0.02, '2%'),
                    const SizedBox(height: 5),
                    _buildRatingBar(1, 0.01, '1%'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBar(int star, double value, String label) {
    return Row(
      children: [
        Text('★ $star',
            style: const TextStyle(fontSize: 11, color: Color(0xFF757575))),
        const SizedBox(width: 6),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: const Color(0xFFE0D8C8),
              valueColor: AlwaysStoppedAnimation<Color>(
                star >= 4 ? orangeColor : brownColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 28,
          child: Text(label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF757575)),
              textAlign: TextAlign.right),
        ),
      ],
    );
  }

  Widget _buildClientsFideles() {
    final clients = [
      {
        'initial': 'A',
        'name': 'Amina B',
        'visits': '5 visites',
        'note': '4.9 laissée',
        'cmds': '5 commandes',
        'amount': '1200Da',
      },
      {
        'initial': 'R',
        'name': 'Rania M',
        'visits': '4 visites',
        'note': '4.8 laissée',
        'cmds': '4 commandes',
        'amount': '1020Da',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.people_outline, size: 16, color: brownColor),
            SizedBox(width: 6),
            Text(
              'Clients les plus fidèles',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3E2723),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...clients.map((c) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
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
                      child: Text(
                        c['initial']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: brownColor,
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
                          c['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF3E2723),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${c['visits']} · ★ ${c['note']}   ${c['cmds']}',
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF9E9E9E)),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        c['amount']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: orangeColor,
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          size: 18, color: Color(0xFFBDBDBD)),
                    ],
                  ),
                ],
              ),
            )),
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
              if (index == 2) {
                Navigator.pop(context);
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

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE8824A)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final points = [
      Offset(0, size.height * 0.6),
      Offset(size.width * 0.15, size.height * 0.3),
      Offset(size.width * 0.3, size.height * 0.5),
      Offset(size.width * 0.45, size.height * 0.2),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.75, size.height * 0.25),
      Offset(size.width, size.height * 0.45),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final cp1 = Offset(
        (points[i].dx + points[i + 1].dx) / 2,
        points[i].dy,
      );
      final cp2 = Offset(
        (points[i].dx + points[i + 1].dx) / 2,
        points[i + 1].dy,
      );
      path.cubicTo(
          cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i + 1].dx, points[i + 1].dy);
    }

    canvas.drawPath(path, paint);

    // dots
    final dotPaint = Paint()
      ..color = const Color(0xFFE8824A)
      ..style = PaintingStyle.fill;
    for (final p in points) {
      canvas.drawCircle(p, 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
