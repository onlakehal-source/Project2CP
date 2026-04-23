import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildFieldError(String message, {EdgeInsets? padding}) {
  return Padding(
    padding: padding ?? const EdgeInsets.only(left: 14, top: 5),
    child: Row(
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 14),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            message,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 12,
              color: Colors.red,
            ),
          ),
        ),
      ],
    ),
  );
}

class CustomInputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final int? maxLength;
  final int? maxLines;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  const CustomInputField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLength,
    this.maxLines = 1,
    this.hintText,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 16,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
        if (label.isNotEmpty) const SizedBox(height: 8),
        Container(
          height: maxLines != null && maxLines! > 1 ? null : 42,
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
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLength: maxLength,
            maxLines: obscureText ? 1 : maxLines,
            textAlignVertical: TextAlignVertical.center,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 15,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              counterText: '',
              contentPadding: const EdgeInsets.symmetric(
                vertical: 11,
                horizontal: 16,
              ),
              hintText: hintText,
              hintStyle: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 15,
                color: Color.fromARGB(120, 0, 0, 0),
              ),
              prefixIcon: Icon(
                icon,
                color: const Color.fromARGB(208, 0, 0, 0),
                size: 24,
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
