import 'package:flutter/material.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  static const Color backgroundColor = Color(0xFFFEFAE0);
  static const Color cardColor = Color(0xFFFAF8F5);
  static const Color iconBgColor = Color(0xFFCCD5AE);
  static const Color warningBorderColor = Color(0xFFE8A87C);
  static const Color warningTextColor = Color(0xFFD4845F);
  static const Color expireSoonColor = Color(0xFFE8A87C);
  static const Color validColor = Color(0xFF8BC34A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF3E2723),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Documents',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                ],
              ),
            ),

            // Green divider line
            Container(
              height: 4,
              color: iconBgColor,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Warning Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(30),
                        border:
                            Border.all(color: warningBorderColor, width: 1.5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: warningTextColor,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Votre extrait RC expire dans 23 jours. Mettez-le à jour pour éviter la suspension de votre compte.',
                              style: TextStyle(
                                fontSize: 13,
                                color: warningTextColor,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Document Card 1 - Extrait Registre de Commerce
                    _buildDocumentCard(
                      context: context,
                      icon: Icons.description_outlined,
                      title: 'Extrait Registre de Commerce',
                      subtitle: 'Expire 12 avril 2026',
                      statusText: 'Expire bientôt',
                      statusColor: expireSoonColor,
                      onTap: () => _handleDocumentTap(context, 'rc'),
                      onUpdate: () => _handleUpdateTap(context, 'rc'),
                    ),

                    const SizedBox(height: 16),

                    // Document Card 2 - CIN ou Passeport
                    _buildDocumentCard(
                      context: context,
                      icon: Icons.credit_card_outlined,
                      title: 'CIN ou Passeport',
                      subtitle: 'Valide jusqu\'en 2029',
                      statusText: 'Valide',
                      statusColor: validColor,
                      onTap: () => _handleDocumentTap(context, 'cin'),
                      onUpdate: () => _handleUpdateTap(context, 'cin'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String statusText,
    required Color statusColor,
    required VoidCallback onTap,
    required VoidCallback onUpdate,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Document Icon
                Container(
                  width: 70,
                  height: 80,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 36,
                    color: const Color(0xFF5D6E3F),
                  ),
                ),

                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Update link
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: onUpdate,
                          child: Text(
                            'Mettre à jour',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),

                      // Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3E2723),
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Subtitle
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Status badge
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Chevron
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleDocumentTap(BuildContext context, String docType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ouvrir document: $docType'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleUpdateTap(BuildContext context, String docType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mettre à jour: $docType'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
