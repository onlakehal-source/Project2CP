import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peeco/core/core.dart';
import 'package:peeco/client/client.dart';

enum VerificationMode { forgotPassword, emailVerification }

class VerificationCodePage extends StatefulWidget {
  final String identifier;
  final VerificationMode mode;

  const VerificationCodePage({
    super.key,
    required this.identifier,
    required this.mode,
  });

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _hasError = false;

  int _secondsRemaining = 60;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String get _fullCode => _controllers.map((c) => c.text).join();

  void _resetCodeInputs({required bool setError}) {
    for (final c in _controllers) {
      c.clear();
    }
    setState(() => _hasError = setError);
    FocusScope.of(context).requestFocus(_focusNodes[0]);
  }

  void _onDigitEntered(int index, String value) {
    if (_hasError) setState(() => _hasError = false);

    if (value.length == 1 && index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }

    if (_fullCode.length == 6) {
      _handleVerify();
    }
  }

  void _onBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _controllers[index - 1].clear();
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  void _handleVerify() {
    final code = _fullCode;
    if (code.length < 6) return;

    // TODO API: POST /auth/verify-code with { identifier, code }
    const fakeValidCode = '123456';

    if (code == fakeValidCode) {
      setState(() {
        _hasError = false;
      });

      if (widget.mode == VerificationMode.forgotPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => NewPasswordPage(identifier: widget.identifier),
          ),
        );
      } else {
        Navigator.pop(context, true);
      }
    } else {
      _resetCodeInputs(setError: true);
    }
  }

  void _handleResend() {
    if (!_canResend) return;
    // TODO API: POST /auth/resend-code with { identifier }
    _resetCodeInputs(setError: false);
    _startTimer();
  }

  String get _timerDisplay {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildCodeBox(int index) {
    return SizedBox(
      width: 46,
      height: 54,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            _onBackspace(index);
          }
        },
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: const Color.fromARGB(255, 210, 213, 178),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: _hasError ? Colors.red : Colors.transparent,

                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: _hasError
                    ? Colors.red
                    : const Color.fromARGB(255, 248, 176, 104),
                width: 2,
              ),
            ),
          ),
          onChanged: (value) => _onDigitEntered(index, value),
        ),
      ),
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
                    'Code de vérification',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Entrez le code envoyé à votre adresse\ne-mail / numéro de téléphone',
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (i) {
                    return Padding(
                      padding: EdgeInsets.only(right: i < 5 ? 10 : 0),
                      child: _buildCodeBox(i),
                    );
                  }),
                ),

                const SizedBox(height: 12),

                if (_hasError)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Le code que vous avez saisi est incorrect.\nVeuillez réessayer.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'NotoLoopedThai',
                          fontSize: 13,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  )
                else if (!_canResend)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      _timerDisplay,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14,
                        color: Color.fromARGB(180, 0, 0, 0),
                      ),
                    ),
                  ),

                const SizedBox(height: 180),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _hasError
                          ? () {
                              _resetCodeInputs(setError: false);
                            }
                          : _handleVerify,
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
                      child: Text(
                        _hasError ? 'Réessayer' : 'Vérifier',
                        style: const TextStyle(
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
                  child: GestureDetector(
                    onTap: _canResend ? _handleResend : null,
                    child: RichText(
                      text: TextSpan(
                        text: 'Vous n\'avez pas reçu le code ? ',
                        style: TextStyle(
                          fontFamily: 'NotoLoopedThai',
                          fontSize: 15,
                          color: _canResend
                              ? Colors.black
                              : const Color.fromARGB(120, 0, 0, 0),
                        ),
                        children: [
                          TextSpan(
                            text: 'Renvoyer le code',
                            style: TextStyle(
                              fontFamily: 'NotoLoopedThai',
                              fontWeight: FontWeight.bold,
                              color: _canResend
                                  ? Colors.black
                                  : const Color.fromARGB(120, 0, 0, 0),
                            ),
                          ),
                        ],
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
