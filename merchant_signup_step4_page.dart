import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:file_picker/file_picker.dart';
import 'package:peeco/core/core.dart';
import 'package:peeco/commerce/commerce.dart';
import 'package:peeco/client/client.dart';
import 'package:path/path.dart' as p;

class MerchantSignupStep4Page extends StatefulWidget {
  final String prenom;
  final String nom;
  final String email;
  final String phone;
  final String password;
  final String nomCommerce;
  final String typeCommerce;
  final String ouverture;
  final String fermeture;
  final String adresse;
  final String wilaya;
  final String commune;
  final String codePostal;
  final String gps;

  const MerchantSignupStep4Page({
    super.key,
    required this.prenom,
    required this.nom,
    required this.email,
    required this.phone,
    required this.password,
    required this.nomCommerce,
    required this.typeCommerce,
    required this.ouverture,
    required this.fermeture,
    required this.adresse,
    required this.wilaya,
    required this.commune,
    required this.codePostal,
    required this.gps,
  });

  @override
  State<MerchantSignupStep4Page> createState() => _MerchantSignupStep4PageState();
}

class _MerchantSignupStep4PageState extends State<MerchantSignupStep4Page> {
  static const _errorPadding = EdgeInsets.only(left: 14, top: 5, bottom: 2);

  final _rcController = TextEditingController();
  final _rcFocus = FocusNode();

  bool _acceptedTerms = false;

  File? _cinFile;
  File? _extraitRcFile;

  String? _rcError;
  String? _cinError;
  String? _extraitRcError;
  String? _termsError;

  @override
  void initState() {
    super.initState();
    _rcFocus.addListener(() {
      if (!_rcFocus.hasFocus) {
        setState(() => _rcError = InputValidator.numeroRC(_rcController.text));
      }
    });
  }

  @override
  void dispose() {
    _rcController.dispose();
    _rcFocus.dispose();
    super.dispose();
  }

  bool _isPdf(File file) => p.extension(file.path).toLowerCase() == '.pdf';

  Future<void> _pickFile(bool isCin) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        final file = File(result.files.single.path!);
        if (isCin) {
          _cinFile = file;
          _cinError = null;
        } else {
          _extraitRcFile = file;
          _extraitRcError = null;
        }
      });
    }
  }

  void _handleSubmit() {
    final rcError = InputValidator.numeroRC(_rcController.text);
    final cinError = InputValidator.documentRequired(_cinFile, 'votre CIN ou Passeport');
    final extraitRcError = InputValidator.documentRequired(_extraitRcFile, 'l\'extrait RC');
    final termsError = _acceptedTerms ? null : 'Veuillez accepter les conditions d\'utilisation';

    setState(() {
      _rcError = rcError;
      _cinError = cinError;
      _extraitRcError = extraitRcError;
      _termsError = termsError;
    });

    if (rcError != null || cinError != null || extraitRcError != null || termsError != null) {
      return;
    }

    _showVerificationSheet();
  }

  void _showVerificationSheet() {
    final identifier = widget.email;
    final displayIdentifier = identifier;

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
              displayIdentifier,
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MerchantHomePage()),
                      (route) => false,
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

  void _go(Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  Widget _fieldError(String message) {
    return buildFieldError(message, padding: _errorPadding);
  }

  Widget _uploadBox({required File? file, required VoidCallback onTap}) {
    Widget content;

    if (file == null) {
      content = Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(10, 0, 0, 0),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.upload_file_outlined, size: 32, color: Colors.black38),
              SizedBox(height: 8),
              Text(
                'Appuyer pour joindre un fichier',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13,
                  color: Colors.black45,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'JPG, PNG ou PDF',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 11,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (_isPdf(file)) {
      final fileName = p.basename(file.path);
      content = Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 248, 176, 104),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(20, 248, 176, 104),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Container(
              width: 48,
              height: 64,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 230, 163, 97),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.white, size: 26),
                  SizedBox(height: 4),
                  Text(
                    'PDF',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Fichier PDF joint ✓',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 11,
                      color: Color.fromARGB(255, 100, 160, 100),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.edit_outlined, size: 18, color: Colors.black38),
            ),
          ],
        ),
      );
    } else {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.file(
              file,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(onTap: onTap, child: content);
  }

  @override
  Widget build(BuildContext context) {
    return commercePageScaffold(
      context: context,
      step: 4,
      children: [
        sectionTitle('Documents du gérant'),

        const Padding(
          padding: EdgeInsets.only(left: 14, bottom: 8),
          child: Text(
            'CIN ou Passeport',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        _uploadBox(file: _cinFile, onTap: () => _pickFile(true)),
        if (_cinError != null) _fieldError(_cinError!),
        const SizedBox(height: 20),

        sectionTitle('Documents du commerce'),

        const Padding(
          padding: EdgeInsets.only(left: 14, bottom: 8),
          child: Text(
            'Numéro du Registre du Commerce (RC)',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          height: 42,
          decoration: inputBoxDecoration(),
          child: TextField(
            controller: _rcController,
            focusNode: _rcFocus,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 15,
              color: Colors.black,
            ),
            onChanged: (_) {
              if (_rcError != null) setState(() => _rcError = null);
            },
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: 11,
                horizontal: 16,
              ),
              hintText: 'ex : 16/0012345',
              hintStyle: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                color: Color.fromARGB(120, 0, 0, 0),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 14, right: 8),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: Colors.black45,
                  size: 20,
                ),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            ),
          ),
        ),
        if (_rcError != null) _fieldError(_rcError!),
        const SizedBox(height: 10),

        const Padding(
          padding: EdgeInsets.only(left: 14, bottom: 8),
          child: Text(
            'Extrait RC',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        _uploadBox(file: _extraitRcFile, onTap: () => _pickFile(false)),
        if (_extraitRcError != null) _fieldError(_extraitRcError!),
        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _acceptedTerms,
                onChanged: (val) => setState(() {
                  _acceptedTerms = val ?? false;
                  if (_acceptedTerms) _termsError = null;
                }),
                activeColor: const Color.fromARGB(255, 248, 176, 104),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: BorderSide(
                  color: _termsError != null ? Colors.red : Colors.black54,
                ),
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
                        ..onTap = () => _go(const ConditionsPage()),
                    ),
                    const TextSpan(text: ' de Peeco, la '),
                    TextSpan(
                      text: 'politique de confidentialité',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 230, 163, 97),
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _go(const PolitiqueConfidentialitePage()),
                    ),
                    const TextSpan(text: ' et le '),
                    TextSpan(
                      text: 'contrat de licence utilisateur',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 230, 163, 97),
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _go(const ContratLicencePage()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (_termsError != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: _fieldError(_termsError!),
          ),
        const SizedBox(height: 24),

        actionButton(label: 'Créer un compte', onPressed: _handleSubmit),
      ],
    );
  }
}