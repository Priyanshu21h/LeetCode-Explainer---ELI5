import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/code_provider.dart';

class Eli5Toggle extends ConsumerWidget {
  const Eli5Toggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEli5 = ref.watch(eli5Provider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: isEli5
                    ? const Color(0xFFFFD54F)
                    : const Color(0xFF888888),
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Explain Like I\'m 5',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFE0E0E0),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Switch(
            value: isEli5,
            onChanged: (val) => ref.read(eli5Provider.notifier).state = val,
            activeThumbColor: const Color(0xFF6C63FF),
            activeTrackColor: const Color(0xFF6C63FF).withAlpha(100),
            inactiveThumbColor: const Color(0xFF888888),
            inactiveTrackColor: const Color(0xFF444444),
          ),
        ],
      ),
    );
  }
}
