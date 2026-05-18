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

    ref.listen<CodeState>(codeProvider, (prev, next) {
      if (next is CodeError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message, style: GoogleFonts.poppins()),
            backgroundColor: const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              // Hero header
              _buildHeroHeader(),
              const SizedBox(height: 20),

              // Code input
              _buildCodeSection(),
              const SizedBox(height: 14),

              // ELI5 toggle
              const Eli5Toggle(),
              const SizedBox(height: 14),

              // Explain button
              _buildExplainButton(codeState),
              const SizedBox(height: 24),

              // Output
              _buildOutput(codeState),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A35), Color(0xFF12122A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A2A50), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.psychology_rounded,
                        color: Color(0xFF6C63FF), size: 22),
                    const SizedBox(width: 8),
                    Text('AI Explainer',
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF6C63FF),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5)),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Paste any code.\nGet an ELI5 explanation.',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 1.35)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    _chip('⚡ Instant'),
                    _chip('🧠 ELI5 Mode'),
                    _chip('📊 Complexity'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withAlpha(80),
                  blurRadius: 16,
                )
              ],
            ),
            child: const Icon(Icons.code_rounded, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF).withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6C63FF).withAlpha(60)),
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
              color: const Color(0xFFBBBBFF), fontSize: 11)),
    );
  }

  Widget _buildCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.terminal_rounded,
                color: Color(0xFF3ECFCF), size: 18),
            const SizedBox(width: 8),
            Text('Your Code',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 10),
        CodeInputWidget(controller: _codeController),
      ],
    );
  }

  Widget _buildExplainButton(CodeState state) {
    final isLoading = state is CodeLoading;
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withAlpha(isLoading ? 40 : 80),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _onExplain,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C63FF),
          disabledBackgroundColor: const Color(0xFF6C63FF).withAlpha(100),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: isLoading
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text('Analyzing code...',
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ])
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.auto_awesome_rounded, size: 20),
                const SizedBox(width: 10),
                Text('Explain This Code',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ]),
      ),
    );
  }

  Widget _buildOutput(CodeState state) {
    if (state is CodeLoading) {
      return Column(
        children: [
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF161625),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF2A2A40)),
            ),
            child: Column(
              children: [
                const CircularProgressIndicator(color: Color(0xFF6C63FF)),
                const SizedBox(height: 16),
                Text('AI is thinking...',
                    style: GoogleFonts.poppins(
                        color: const Color(0xFF888888), fontSize: 14)),
                const SizedBox(height: 4),
                Text('This may take up to 30 seconds',
                    style: GoogleFonts.poppins(
                        color: const Color(0xFF555577), fontSize: 12)),
              ],
            ),
          ),
        ],
      );
    }
    if (state is CodeSuccess) {
      return TabOutputWidget(explanation: state.explanation);
    }
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF161625),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Column(
        children: [
          const Icon(Icons.tips_and_updates_outlined,
              color: Color(0xFF444466), size: 40),
          const SizedBox(height: 12),
          Text('Paste code above and tap Explain',
              style: GoogleFonts.poppins(
                  color: const Color(0xFF666688), fontSize: 14)),
          const SizedBox(height: 4),
          Text('or browse DS / Algo tabs for examples',
              style: GoogleFonts.poppins(
                  color: const Color(0xFF444466), fontSize: 12)),
        ],
      ),
    );
  }
}
