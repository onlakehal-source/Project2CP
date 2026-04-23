import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:peeco/core/core.dart';
import 'package:peeco/client/client.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String? _emailError;
  String? _passwordError;
  String? _generalError;
  bool _isForgotLoading = false;

  @override
  void initState() {
    super.initState();

    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus && _emailController.text.isNotEmpty) {
        setState(() {
          _emailError = InputValidator.emailOrPhone(_emailController.text);
        });
      }
    });

    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus && _passwordController.text.isNotEmpty) {
        setState(() {
          _passwordError = InputValidator.password(_passwordController.text);
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return '${'*' * name.length}@$domain';
    return '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}@$domain';
  }

  Future<void> _handleForgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _emailError = 'Veuillez entrer votre e-mail ou téléphone d\'abord';
      });
      return;
    }

    final formatError = InputValidator.emailOrPhone(_emailController.text);
    if (formatError != null) {
      setState(() => _emailError = formatError);
      return;
    }

    final input = _emailController.text.trim();
    final bool isPhone = !input.contains('@');

    setState(() => _isForgotLoading = true);

    try {
      String resolvedEmail;
      bool shouldMask;

      if (isPhone) {
        // TODO API: phone -> email lookup
        // POST /auth/lookup-email  body: { phone: input }
        // Expected response: { email: "user@example.com" }
        // If account not found → throw an exception
        await Future.delayed(const Duration(seconds: 1));
        resolvedEmail = 'user@example.com';
        shouldMask = true;
      } else {
        // TODO API: check email exists + send code
        // POST /auth/forgot-password  body: { email: input }
        // If account not found → throw an exception
        await Future.delayed(const Duration(seconds: 1));
        resolvedEmail = input;
        shouldMask = false;
      }

      setState(() => _isForgotLoading = false);
      if (!mounted) return;
      _showConfirmationSheet(resolvedEmail, masked: shouldMask);
    } catch (e) {
      setState(() {
        _emailError = 'Aucun compte associé à cet identifiant.';
        _isForgotLoading = false;
      });
    }
  }

  void _showConfirmationSheet(String resolvedEmail, {bool masked = false}) {
    final displayEmail = masked ? _maskEmail(resolvedEmail) : resolvedEmail;

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
              'Le code sera envoyé à',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              displayEmail,
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
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VerificationCodePage(
                        identifier: resolvedEmail,
                        mode: VerificationMode.forgotPassword,
                      ),
                    ),
                  );
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

  void _handleLogin() {
    setState(() {
      _emailError = InputValidator.emailOrPhone(_emailController.text);
      _passwordError = InputValidator.password(_passwordController.text);
      _generalError = null;
    });

    if (_emailError != null || _passwordError != null) return;

    const fakeEmail = 'test@peeco.com';
    const fakePhone = '0612345678';
    const fakePassword = 'password123';

    final input = _emailController.text.trim();
    final pass = _passwordController.text;

    if (input != fakeEmail && input != fakePhone) {
      setState(() => _generalError = 'Identifiant ou mot de passe incorrect');
      return;
    }
    if (pass != fakePassword) {
      setState(() => _generalError = 'Identifiant ou mot de passe incorrect');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ClientHome()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: appGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 24,
                  ),
                ),

                const SizedBox(height: 40),

                const Center(
                  child: Text(
                    'Se connecter',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'Connectez-vous à votre compte Peeco',
                    style: TextStyle(
                      fontFamily: 'NotoLoopedThai',
                      fontSize: 16,
                      color: Color.fromARGB(217, 0, 0, 0),
                    ),
                  ),
                ),

                const SizedBox(height: 150),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomInputField(
                        label: 'Adresse e-mail / Numéro de téléphone',
                        icon: Icons.mail_outline,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) {
                          if (_emailError != null || _generalError != null) {
                            setState(() {
                              _emailError = null;
                              _generalError = null;
                            });
                          }
                        },
                      ),

                      if (_emailError != null) buildFieldError(_emailError!),

                      const SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.only(
                          left: 14,
                          right: 4,
                          bottom: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Mot de passe',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            GestureDetector(
                              onTap: _isForgotLoading
                                  ? null
                                  : _handleForgotPassword,
                              child: _isForgotLoading
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                  : const Text(
                                      'Mot de passe oublié ?',
                                      style: TextStyle(
                                        fontFamily: 'NotoLoopedThai',
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),

                      Container(
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
                        child: TextField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          obscureText: _obscurePassword,
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: (_) {
                            if (_passwordError != null ||
                                _generalError != null) {
                              setState(() {
                                _passwordError = null;
                                _generalError = null;
                              });
                            }
                          },
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 15,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 11,
                              horizontal: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Color.fromARGB(208, 0, 0, 0),
                              size: 24,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color.fromARGB(180, 0, 0, 0),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),

                      if (_passwordError != null)
                        buildFieldError(_passwordError!),
                    ],
                  ),
                ),

                if (_generalError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 19,
                      vertical: 14,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              _generalError!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 13,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: _generalError != null ? 14 : 58),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          248,
                          176,
                          104,
                        ),
                        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Vous n\'avez pas de compte ? ',
                      style: const TextStyle(
                        fontFamily: 'NotoLoopedThai',
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      children: [
                        TextSpan(
                          text: 'S\'inscrire',
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
                                  builder: (_) => const ChoicePage(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
