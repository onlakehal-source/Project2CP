import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:peeco/core/core.dart';
import 'package:peeco/client/client.dart';


class ClientSignupPage extends StatefulWidget {
  const ClientSignupPage({super.key});

  @override
  State<ClientSignupPage> createState() => _ClientSignupPageState();
}

class _ClientSignupPageState extends State<ClientSignupPage> {
  static const _errorPadding = EdgeInsets.only(left: 14, top: 5, bottom: 2);

  final _prenomController = TextEditingController();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _prenomFocus = FocusNode();
  final _nomFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  String? _prenomError;
  String? _nomError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;

  @override
  void initState() {
    super.initState();

    _prenomFocus.addListener(() {
      if (!_prenomFocus.hasFocus) {
        setState(
          () => _prenomError = InputValidator.prenom(_prenomController.text),
        );
      }
    });

    _nomFocus.addListener(() {
      if (!_nomFocus.hasFocus) {
        setState(() => _nomError = InputValidator.nom(_nomController.text));
      }
    });

    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) {
        setState(
          () => _emailError = InputValidator.email(_emailController.text),
        );
      }
    });

    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus) {
        setState(
          () => _passwordError = InputValidator.newPassword(
            _passwordController.text,
          ),
        );
      }
    });

    _confirmFocus.addListener(() {
      if (!_confirmFocus.hasFocus) {
        setState(
          () => _confirmError = InputValidator.confirmPassword(
            _confirmPasswordController.text,
            _passwordController.text,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _prenomController.dispose();
    _nomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _prenomFocus.dispose();
    _nomFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  void _handleSignup() {
    setState(() {
      _prenomError = InputValidator.prenom(_prenomController.text);
      _nomError = InputValidator.nom(_nomController.text);
      _emailError = InputValidator.email(_emailController.text);
      _passwordError = InputValidator.newPassword(_passwordController.text);
      _confirmError = InputValidator.confirmPassword(
        _confirmPasswordController.text,
        _passwordController.text,
      );
    });

    if (_prenomError != null ||
        _nomError != null ||
        _emailError != null ||
        _passwordError != null ||
        _confirmError != null)
      return;

    _showVerificationSheet();
  }

  void _showVerificationSheet() {
    final identifier = _emailController.text.trim();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFB5C99A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const Icon(
              Icons.mark_email_unread_outlined,
              size: 48,
              color: Color.fromARGB(255, 248, 176, 104),
            ),
            const SizedBox(height: 16),

            const Text(
              'Un code de vérification sera envoyé à votre adresse e-mail',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              identifier,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);

                  // TODO API: POST /auth/send-code  body: { identifier }

                  final verified = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VerificationCodePage(
                        identifier: identifier,
                        mode: VerificationMode.emailVerification,
                      ),
                    ),
                  );

                  if (verified == true && mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompleteProfilePage(
                          prenom: _prenomController.text.trim(),
                          nom: _nomController.text.trim(),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 248, 176, 104),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Confirmer',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _go(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _fieldError(String message) {
    return buildFieldError(message, padding: _errorPadding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: appGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 10),

                const Center(
                  child: Text(
                    'S\'inscrire',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'Créez votre compte Peeco',
                    style: TextStyle(
                      fontFamily: 'NotoLoopedThai',
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                const SizedBox(height: 55),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomInputField(
                                  label: 'Prénom',
                                  icon: Icons.person_outline,
                                  controller: _prenomController,
                                  focusNode: _prenomFocus,
                                  onChanged: (_) {
                                    if (_prenomError != null)
                                      setState(() => _prenomError = null);
                                  },
                                ),
                                if (_prenomError != null)
                                  _fieldError(_prenomError!),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomInputField(
                                  label: 'Nom',
                                  icon: Icons.person_outline,
                                  controller: _nomController,
                                  focusNode: _nomFocus,
                                  onChanged: (_) {
                                    if (_nomError != null)
                                      setState(() => _nomError = null);
                                  },
                                ),
                                if (_nomError != null) _fieldError(_nomError!),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      CustomInputField(
                        label: 'Adresse e-mail',
                        icon: Icons.mail_outline,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) {
                          if (_emailError != null)
                            setState(() => _emailError = null);
                        },
                      ),
                      if (_emailError != null) _fieldError(_emailError!),
                      const SizedBox(height: 10),

                      CustomInputField(
                        label: 'Mot de passe',
                        icon: Icons.lock_outline,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        obscureText: _obscurePassword,
                        onChanged: (_) {
                          if (_passwordError != null)
                            setState(() => _passwordError = null);
                          if (_confirmError != null) {
                            setState(
                              () => _confirmError =
                                  InputValidator.confirmPassword(
                                    _confirmPasswordController.text,
                                    _passwordController.text,
                                  ),
                            );
                          }
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.black54,
                            size: 20,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      if (_passwordError != null) _fieldError(_passwordError!),
                      const SizedBox(height: 10),

                      CustomInputField(
                        label: 'Confirmer le mot de passe',
                        icon: Icons.lock_outline,
                        controller: _confirmPasswordController,
                        focusNode: _confirmFocus,
                        obscureText: _obscureConfirm,
                        onChanged: (_) {
                          if (_confirmError != null)
                            setState(() => _confirmError = null);
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.black54,
                            size: 20,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                      ),
                      if (_confirmError != null) _fieldError(_confirmError!),
                      const SizedBox(height: 15),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _acceptedTerms,
                              onChanged: (val) =>
                                  setState(() => _acceptedTerms = val ?? false),
                              activeColor: const Color.fromARGB(
                                255,
                                248,
                                176,
                                104,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: const BorderSide(color: Colors.black54),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontFamily: 'NotoLoopedThai',
                                  fontSize: 11,
                                  color: Colors.black87,
                                ),
                                children: [
                                  const TextSpan(text: 'J\'accepte les '),
                                  TextSpan(
                                    text: 'conditions d\'utilisation',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 230, 163, 97),
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () =>
                                          _go(const ConditionsPage()),
                                  ),
                                  const TextSpan(text: ' de Peeco, la '),
                                  TextSpan(
                                    text: 'politique de confidentialité',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 230, 163, 97),
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => _go(
                                        const PolitiqueConfidentialitePage(),
                                      ),
                                  ),
                                  const TextSpan(text: ' et le '),
                                  TextSpan(
                                    text: 'contrat de licence utilisateur',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 230, 163, 97),
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () =>
                                          _go(const ContratLicencePage()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _acceptedTerms ? _handleSignup : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              248,
                              176,
                              104,
                            ),
                            disabledBackgroundColor: const Color.fromARGB(
                              160,
                              248,
                              176,
                              104,
                            ),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Créer un compte',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 40,
                            child: Divider(color: Colors.black26, thickness: 1),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'ou',
                              style: TextStyle(
                                fontFamily: 'NotoLoopedThai',
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: Divider(color: Colors.black26, thickness: 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Center(
                        child: GestureDetector(
                          onTap: () async {},
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 210, 213, 178),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(
                                    130,
                                    255,
                                    255,
                                    255,
                                  ).withValues(alpha: 0.6),
                                  blurRadius: 0,
                                  spreadRadius: 1,
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/google.png',
                                  width: 22,
                                  height: 22,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Continuer avec Google',
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 15,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Vous avez déjà un compte ? ',
                      style: const TextStyle(
                        fontFamily: 'NotoLoopedThai',
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'Se connecter',
                          style: const TextStyle(
                            fontFamily: 'NotoLoopedThai',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
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
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
