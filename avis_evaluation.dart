import 'package:flutter/material.dart';

class AvisEvaluationsPage extends StatelessWidget {
  const AvisEvaluationsPage({super.key});

  static const Color backgroundColor = Color(0xFFF5F0E8);
  static const Color cardColor = Color(0xFFFEFAF0);
  static const Color orangeColor = Color(0xFFE8824A);
  static const Color replyBgColor = Color(0xFFEEE8D8);
  static const Color topBarColor = Color(0xFFCCD5AE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top green bar
            Container(height: 8, color: topBarColor),
            // App bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: Color(0xFF3E2723), size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Avis & évaluations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Rating summary card
                    _buildRatingSummaryCard(),
                    const SizedBox(height: 20),
                    const Text(
                      '79 avis',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Reviews
                    _buildReviewCard(
                      initial: 'K',
                      initialColor: Color(0xFF8B9E6B),
                      name: 'Karim B',
                      stars: 5,
                      date: '18 mars',
                      comment:
                          'Excellent ! Le panier était très généreux, pain frais et viennoiseries de qualité. Je reviendrai certainement',
                      reply: 'Merci Karim ! On vous attend avec plaisir.',
                      hasReply: true,
                    ),
                    const SizedBox(height: 12),
                    _buildReviewCard(
                      initial: 'S',
                      initialColor: Color(0xFF9E9E9E),
                      name: 'Sarah M',
                      stars: 4,
                      date: '15 mars',
                      comment:
                          "Très bon rapport qualité/prix. Juste un peu d'attente à la caisse mais les produits valaient le détour.",
                      hasReply: false,
                    ),
                    const SizedBox(height: 12),
                    _buildReviewCard(
                      initial: 'A',
                      initialColor: Color(0xFF9E9E9E),
                      name: 'Amina B',
                      stars: 3,
                      date: '02 mars',
                      comment:
                          "Service correct dans l'ensemble. La commande était prête à temps, mais la qualité pourrait être améliorée. Personnel accueillant, mais j'espère une meilleure expérience la prochaine fois.",
                      reply:
                          "Merci pour votre avis. Votre retour est important pour nous. Nous sommes heureux que certains points vous aient satisfait et nous travaillons actuellement à améliorer la qualité de nos services. À très bientôt !",
                      hasReply: true,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Big score
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '4.8',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w700,
                  color: orangeColor,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(
                  5,
                  (i) => const Icon(Icons.star, color: orangeColor, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          // Bars
          Expanded(
            child: Column(
              children: [
                _buildRatingBar(5, 0.72, '72%'),
                const SizedBox(height: 6),
                _buildRatingBar(4, 0.18, '18%'),
                const SizedBox(height: 6),
                _buildRatingBar(3, 0.07, '7%'),
                const SizedBox(height: 6),
                _buildRatingBar(2, 0.02, '2%'),
                const SizedBox(height: 6),
                _buildRatingBar(1, 0.01, '1%'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int star, double value, String label) {
    return Row(
      children: [
        Icon(Icons.star, size: 12, color: orangeColor),
        const SizedBox(width: 4),
        Text(
          '$star',
          style: const TextStyle(fontSize: 11, color: Color(0xFF757575)),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: const Color(0xFFE0D8C8),
              valueColor: AlwaysStoppedAnimation<Color>(
                star >= 4 ? orangeColor : const Color(0xFF5D4E37),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 28,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF757575)),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String initial,
    required Color initialColor,
    required String name,
    required int stars,
    required String date,
    required String comment,
    String? reply,
    required bool hasReply,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Avatar
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: initialColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF3E2723),
                  ),
                ),
              ),
              // Stars
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star,
                    size: 13,
                    color: i < stars ? orangeColor : const Color(0xFFE0D8C8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Comment
          Text(
            comment,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF424242),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          // Reply or respond button
          if (hasReply && reply != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: replyBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Votre reponse',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF5D4E37),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reply,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5D4E37),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            )
          else
            GestureDetector(
              onTap: () {},
              child: const Text(
                'Répondre à cet avis >',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9E9E9E),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
