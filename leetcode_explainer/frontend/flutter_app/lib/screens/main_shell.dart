import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'ds_library_screen.dart';

final _navIndexProvider = StateProvider<int>((ref) => 0);

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const _screens = [HomeScreen(), DSLibraryScreen(), AlgoLibraryScreen()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(_navIndexProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: IndexedStack(index: idx, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF161625),
          border: Border(top: BorderSide(color: const Color(0xFF2A2A40), width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: 20,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.psychology_rounded,
                  label: 'AI Explainer',
                  selected: idx == 0,
                  onTap: () => ref.read(_navIndexProvider.notifier).state = 0,
                ),
                _NavItem(
                  icon: Icons.account_tree_rounded,
                  label: 'Data Structures',
                  selected: idx == 1,
                  onTap: () => ref.read(_navIndexProvider.notifier).state = 1,
                ),
                _NavItem(
                  icon: Icons.bolt_rounded,
                  label: 'Algorithms',
                  selected: idx == 2,
                  onTap: () => ref.read(_navIndexProvider.notifier).state = 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF6C63FF) : const Color(0xFF555577);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF6C63FF).withAlpha(30)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                  color: color,
                  fontSize: 10,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
