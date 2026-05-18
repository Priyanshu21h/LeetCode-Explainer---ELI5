import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/code_provider.dart';
import '../widgets/code_input_widget.dart';
import '../widgets/eli5_toggle.dart';
import '../widgets/tab_output_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onExplain() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please paste some code first.',
              style: GoogleFonts.poppins()),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }
    final isEli5 = ref.read(eli5Provider);
    ref.read(codeProvider.notifier).explainCode(code, isEli5);
  }

  @override
  Widget build(BuildContext context) {
    final codeState = ref.watch(codeProvider);

    // Show errors as snackbar
    ref.listen<CodeState>(codeProvider, (prev, next) {
      if (next is CodeError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message, style: GoogleFonts.poppins()),
            backgroundColor: const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.code, color: Color(0xFF6C63FF), size: 28),
            const SizedBox(width: 10),
            Text(
              'LeetCode Explainer',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF161625),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Code input
            CodeInputWidget(controller: _codeController),
            const SizedBox(height: 16),

            // ELI5 toggle
            const Eli5Toggle(),
            const SizedBox(height: 16),

            // Explain button
            _buildExplainButton(codeState),
            const SizedBox(height: 24),

            // Output area
            _buildOutput(codeState),
          ],
        ),
      ),
    );
  }

  Widget _buildExplainButton(CodeState state) {
    final isLoading = state is CodeLoading;
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : _onExplain,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C63FF),
          disabledBackgroundColor: const Color(0xFF6C63FF).withAlpha(100),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          shadowColor: const Color(0xFF6C63FF).withAlpha(100),
        ),
        child: isLoading
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text('Analyzing code...',
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
              ])
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.play_arrow_rounded, size: 24),
                const SizedBox(width: 8),
                Text('Explain',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
              ]),
      ),
    );
  }

  Widget _buildOutput(CodeState state) {
    if (state is CodeLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            CircularProgressIndicator(color: Color(0xFF6C63FF)),
            SizedBox(height: 16),
            Text('Analyzing code...', style: TextStyle(color: Color(0xFF888888), fontSize: 14)),
          ],
        ),
      );
    }
    if (state is CodeSuccess) {
      return TabOutputWidget(explanation: state.explanation);
    }
    return const SizedBox.shrink();
  }
}
