import 'package:flutter/material.dart';
import 'package:peeco/core/core.dart';
import 'package:peeco/client/client.dart';
import 'package:flutter/gestures.dart';
import 'package:peeco/commerce/commerce.dart';

class ChoicePage extends StatefulWidget {
  const ChoicePage({super.key});

  @override
  State<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  static const _clientHighlights = [
    'Découvrez des plats locaux',
    'Commandez rapidement',
    'Profitez des meilleures offres',
  ];
  static const _merchantHighlights = [
    'Augmentez vos ventes',
    'Présentez votre menu en ligne',
    'Touchez plus de clients',
  ];

  String? selectedRole;
  bool showError = false;

  void _handleContinue() {
    if (selectedRole == null) {
      setState(() => showError = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => showError = false);
      });
      return;
    }
    if (selectedRole == 'client') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ClientSignupPage()),
      );
    } else if (selectedRole == 'commercant') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MerchantSignupStep1Page()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: appGradient,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
            child: Column(
              children: [
                const Text(
                  'Bienvenue ! Qui êtes-vous ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 31,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Choisissez votre profil pour créer\nvotre compte adapté à vos besoins.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'NotoLoopedThai',
                    fontSize: 17,
                    color: Color.fromARGB(255, 56, 56, 56),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 65),

                Row(
                  children: [
                    Expanded(
                      child: _ChoiceCard(
                        icon: Icons.person_outline,
                        title: 'Client',
                        description:
                            'Explorez des repas près de vous et commandez en quelques clics.',
                        color: const Color(0xFFB5C99A),
                        isSelected: selectedRole == 'client',
                        onTap: () {
                          setState(() {
                            selectedRole = 'client';
                            showError = false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _ChoiceCard(
                        icon: Icons.storefront_outlined,
                        title: 'Commerçant',
                        description:
                            'Présentez vos plats et développez votre activité grâce à nos outils.',
                        color: const Color.fromARGB(255, 248, 176, 104),
                        isSelected: selectedRole == 'commercant',
                        onTap: () {
                          setState(() {
                            selectedRole = 'commercant';
                            showError = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (showError)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.error_outline, color: Colors.red, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Veuillez choisir votre profil d\'abord',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 8),

                if (selectedRole != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: selectedRole == 'client'
                            ? const Color(0xFFB5C99A).withValues(alpha: 0.25)
                            : const Color.fromARGB(
                                255,
                                248,
                                176,
                                104,
                              ).withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final point
                              in selectedRole == 'client'
                                  ? _clientHighlights
                                  : _merchantHighlights)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.circle,
                                    size: 6,
                                    color: Color(0xFF7A6640),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    point,
                                    style: const TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 13,
                                      color: Color(0xFF5C4A1E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: selectedRole != null ? 40 : 85),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedRole == 'client'
                          ? const Color(0xFFB5C99A)
                          : const Color.fromARGB(255, 248, 176, 104),
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      selectedRole == null
                          ? 'Créer mon Compte'
                          : selectedRole == 'client'
                          ? 'Créer mon Compte Client'
                          : 'Créer mon Compte Commerçant',
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                RichText(
                  text: TextSpan(
                    text: 'Vous avez déjà un compte ? ',
                    style: const TextStyle(
                      fontFamily: 'NotoLoopedThai',
                      fontSize: 15,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    children: [
                      TextSpan(
                        text: 'Se connecter',
                        style: const TextStyle(
                          fontFamily: 'NotoLoopedThai',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final Color color;
  final bool isSelected;

  const _ChoiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 190,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color : const Color.fromARGB(134, 183, 192, 157),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: const Color.fromARGB(255, 0, 0, 0),
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 13,
                color: Color.fromARGB(164, 0, 0, 0),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
