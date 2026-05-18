import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CodeInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const CodeInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF6C63FF).withAlpha(77),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withAlpha(26),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        minLines: 8,
        style: GoogleFonts.jetBrainsMono(
          color: const Color(0xFFE0E0E0),
          fontSize: 14,
          height: 1.6,
        ),
        decoration: InputDecoration(
          hintText: 'Paste your C++ or Python code here...',
          hintStyle: GoogleFonts.jetBrainsMono(
            color: const Color(0xFF666680),
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        cursorColor: const Color(0xFF6C63FF),
      ),
    );
  }
}
