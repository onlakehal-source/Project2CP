import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:peeco/core/core.dart';
import 'package:peeco/client/client.dart';


BoxDecoration inputBoxDecoration() => BoxDecoration(
  color: const Color.fromARGB(255, 210, 213, 178),
  borderRadius: BorderRadius.circular(25),
  boxShadow: [
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.55),
      blurRadius: 0,
      spreadRadius: 1,
      offset: const Offset(1, 1),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 4,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ],
);

Widget sectionTitle(String text) => Padding(
  padding: const EdgeInsets.only(left: 2, bottom: 14),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 5),
      Container(height: 1, width: double.infinity, color: Colors.black26),
    ],
  ),
);

Widget fieldLabel(String text) => Padding(
  padding: const EdgeInsets.only(left: 14, bottom: 8),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 4),
      Container(height: 1, width: 80, color: Colors.black26),
    ],
  ),
);

Widget actionButton({
  required String label,
  required VoidCallback? onPressed,
}) => Align(
  alignment: Alignment.centerRight,
  child: SizedBox(
    height: 45,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 248, 176, 104),
        disabledBackgroundColor: const Color.fromARGB(160, 248, 176, 104),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    ),
  ),
);

Widget alreadyHaveAccount(BuildContext context) => Center(
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
            ..onTap = () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            ),
        ),
      ],
    ),
  ),
);

Widget commercePageScaffold({
  required BuildContext context,
  required int step,
  required List<Widget> children,
}) => Scaffold(
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
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 45),
            StepIndicator(currentStep: step),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
            const SizedBox(height: 18),
            alreadyHaveAccount(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  ),
);

class StepIndicator extends StatelessWidget {
  final int currentStep;
  const StepIndicator({super.key, required this.currentStep});
  static const _labels = ['Compte', 'Commerce', 'Localisation', 'Documents'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final step = i + 1;
        final isActive = step == currentStep;
        final isDone = step < currentStep;
        return Row(
          children: [
            Column(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive || isDone
                        ? const Color(0xFFB5C99A)
                        : const Color.fromARGB(215, 210, 213, 178),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 6,
                        spreadRadius: 1,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$step',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isActive || isDone
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : Colors.black38,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  _labels[i],
                  style: TextStyle(
                    fontFamily: 'NotoLoopedThai',
                    fontSize: 12,
                    color: isActive || isDone ? Colors.black87 : Colors.black38,
                  ),
                ),
              ],
            ),
            if (step < 4)
              Container(
                width: 30,
                height: 1,
                margin: const EdgeInsets.only(bottom: 18),
                color: isDone
                    ? Colors.black38
                    : const Color.fromARGB(80, 0, 0, 0),
              ),
          ],
        );
      }),
    );
  }
}

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;

  const AppDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: inputBoxDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              color: Color.fromARGB(120, 0, 0, 0),
            ),
          ),
          isExpanded: true,
          menuMaxHeight: 300,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 15,
            color: Colors.black,
          ),
          dropdownColor: const Color.fromARGB(255, 225, 228, 192),
          borderRadius: BorderRadius.circular(16),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel(item)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class UploadBox extends StatelessWidget {
  final File? file;
  final VoidCallback onTap;

  const UploadBox({super.key, required this.file, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 210, 213, 178),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.55),
              blurRadius: 0,
              spreadRadius: 1,
              offset: const Offset(1, 1),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: file != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(file!, fit: BoxFit.cover),
                    Positioned(
                      bottom: 6,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Changer',
                              style: TextStyle(
                                fontFamily: 'NotoLoopedThai',
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.upload_file_outlined,
                      color: Colors.black45,
                      size: 28,
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Glisser & déposer ou parcourir\nJPG, PNG ou PDF — max 5 Mo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'NotoLoopedThai',
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
