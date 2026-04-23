import 'package:flutter/material.dart';
import 'package:peeco/core/core.dart';
import 'package:peeco/client/client.dart';

class NewPasswordPage extends StatefulWidget {
  final String identifier;

  const NewPasswordPage({super.key, required this.identifier});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  String? _passwordError;
  String? _confirmError;
  String? _generalError;

  @override
  void initState() {
    super.initState();

    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus && _passwordController.text.isNotEmpty) {
        setState(() {
          _passwordError = InputValidator.newPassword(_passwordController.text);
        });
      }
    });

    _confirmFocus.addListener(() {
      if (!_confirmFocus.hasFocus && _confirmController.text.isNotEmpty) {
        setState(() {
          _confirmError = InputValidator.confirmPassword(
            _confirmController.text,
            _passwordController.text,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    setState(() {
      _passwordError = InputValidator.newPassword(_passwordController.text);
      _confirmError = InputValidator.confirmPassword(
        _confirmController.text,
        _passwordController.text,
      );
      _generalError = null;
    });

    if (_passwordError != null || _confirmError != null) return;

    // TODO API: POST /auth/reset-password with:
    // { identifier: widget.identifier, newPassword: _passwordController.text }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Mot de passe modifié avec succès !',
          style: TextStyle(fontFamily: 'PlusJakartaSans', color: Colors.black),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color.fromARGB(255, 248, 176, 104),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
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
                    color: Colors.black,
                    size: 24,
                  ),
                ),

                const SizedBox(height: 40),

                const Center(
                  child: Text(
                    'Nouveau mot de passe',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 38,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Choisissez un nouveau mot de passe pour votre compte',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'NotoLoopedThai',
                        fontSize: 16,
                        color: Color.fromARGB(217, 0, 0, 0),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 100),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomInputField(
                        label: 'Nouveau mot de passe',
                        icon: Icons.lock_outline,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        obscureText: _obscurePassword,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          child: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color.fromARGB(180, 0, 0, 0),
                            size: 20,
                          ),
                        ),
                        onChanged: (_) {
                          if (_passwordError != null || _generalError != null) {
                            setState(() {
                              _passwordError = null;
                              _generalError = null;
                            });
                          }
                        },
                      ),

                      if (_passwordError != null)
                        buildFieldError(_passwordError!),

                      const SizedBox(height: 16),

                      CustomInputField(
                        label: 'Confirmer le mot de passe',
                        icon: Icons.lock_outline,
                        controller: _confirmController,
                        focusNode: _confirmFocus,
                        obscureText: _obscureConfirm,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                          child: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color.fromARGB(180, 0, 0, 0),
                            size: 20,
                          ),
                        ),
                        onChanged: (_) {
                          if (_confirmError != null || _generalError != null) {
                            setState(() {
                              _confirmError = null;
                              _generalError = null;
                            });
                          }
                        },
                      ),

                      if (_confirmError != null)
                        buildFieldError(_confirmError!),
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

                SizedBox(height: _generalError != null ? 14 : 48),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
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
                        'Confirmer',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
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
