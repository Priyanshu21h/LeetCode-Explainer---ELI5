import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import '../models/explanation_model.dart';
import '../services/ai_service.dart';
import '../widgets/tab_output_widget.dart';

// ─── Explain state ────────────────────────────────────────────────────────────

abstract class _ExplainState {}

class _ExplainIdle extends _ExplainState {}

class _ExplainLoading extends _ExplainState {}

class _ExplainSuccess extends _ExplainState {
  final ExplanationModel result;
  _ExplainSuccess(this.result);
}

class _ExplainError extends _ExplainState {
  final String message;
  _ExplainError(this.message);
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class TopicDetailScreen extends StatefulWidget {
  final String title;
  final String code;
  final String description;
  final String icon;
  final String difficulty;
  final String? category;

  const TopicDetailScreen({
    super.key,
    required this.title,
    required this.code,
    required this.description,
    required this.icon,
    required this.difficulty,
    this.category,
  });

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  bool _copied = false;
  bool _eli5 = false;
  _ExplainState _explainState = _ExplainIdle();

  Color get _diffColor {
    switch (widget.difficulty) {
      case 'Beginner':
        return const Color(0xFF4CAF50);
      case 'Intermediate':
        return const Color(0xFFFFB347);
      default:
        return const Color(0xFFFF5252);
    }
  }

  void _copyCode() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  Future<void> _explainWithAI() async {
    setState(() => _explainState = _ExplainLoading());
    try {
      final result = await AiService.explainCode(
        code: widget.code,
        isEli5: _eli5,
      );
      if (mounted) setState(() => _explainState = _ExplainSuccess(result));
    } catch (e) {
      if (mounted) {
        setState(() => _explainState =
            _ExplainError(e.toString().replaceFirst('Exception: ', '')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ──────────────────────────────────────────────
            _buildAppBar(),
            const Divider(color: Color(0xFF1E1E30), height: 1),

            // ── Body ─────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description bar
                    _buildDescriptionBar(),
                    const SizedBox(height: 16),

                    // Code section
                    _buildCodeSection(),
                    const SizedBox(height: 20),

                    // AI Explain CTA
                    _buildExplainCTA(),
                    const SizedBox(height: 16),

                    // AI Output (inline)
                    _buildExplainOutput(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Widgets ────────────────────────────────────────────────────────────────

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      color: const Color(0xFF0D0D1A),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              widget.title,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _diffColor.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _diffColor.withAlpha(60), width: 1),
            ),
            child: Text(widget.difficulty,
                style: GoogleFonts.poppins(
                    color: _diffColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildDescriptionBar() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF13132A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E1E35), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFF6C63FF), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.description,
                    style: GoogleFonts.poppins(
                        color: const Color(0xFFCCCCDD), fontSize: 13)),
                if (widget.category != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.label_outline_rounded,
                          color: Color(0xFF555577), size: 14),
                      const SizedBox(width: 4),
                      Text(widget.category!,
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF555577),
                              fontSize: 11)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
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
            Text('Code',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            const Spacer(),
            // Copy button
            GestureDetector(
              onTap: _copyCode,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _copied
                      ? const Color(0xFF4CAF50).withAlpha(30)
                      : const Color(0xFF1E1E35),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _copied
                        ? const Color(0xFF4CAF50).withAlpha(80)
                        : const Color(0xFF2A2A45),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _copied ? Icons.check_rounded : Icons.copy_rounded,
                      size: 14,
                      color: _copied
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF888888),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _copied ? 'Copied!' : 'Copy',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: _copied
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFF888888),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1E1E35), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: HighlightView(
              widget.code,
              language: 'python',
              theme: atomOneDarkTheme,
              padding: const EdgeInsets.all(16),
              textStyle:
                  GoogleFonts.sourceCodePro(fontSize: 13, height: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExplainCTA() {
    final isLoading = _explainState is _ExplainLoading;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6C63FF).withAlpha(30),
            const Color(0xFF3ECFCF).withAlpha(15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: const Color(0xFF6C63FF).withAlpha(60), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withAlpha(40),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.psychology_rounded,
                color: Color(0xFF6C63FF), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Get AI Explanation',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text('ELI5 · Complexity · Dry Run',
                    style: GoogleFonts.poppins(
                        color: const Color(0xFF888888), fontSize: 11)),
              ],
            ),
          ),
          // ELI5 toggle chip
          GestureDetector(
            onTap: isLoading ? null : () => setState(() => _eli5 = !_eli5),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _eli5
                    ? const Color(0xFFFFB347).withAlpha(40)
                    : const Color(0xFF1E1E35),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _eli5
                      ? const Color(0xFFFFB347).withAlpha(100)
                      : const Color(0xFF2A2A45),
                ),
              ),
              child: Text(
                '🧒 ELI5',
                style: GoogleFonts.poppins(
                    color:
                        _eli5 ? const Color(0xFFFFB347) : const Color(0xFF666688),
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Explain button
          ElevatedButton(
            onPressed: isLoading ? null : _explainWithAI,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              disabledBackgroundColor: const Color(0xFF6C63FF).withAlpha(80),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : Text('Explain',
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildExplainOutput() {
    if (_explainState is _ExplainIdle) {
      return const SizedBox.shrink();
    }

    if (_explainState is _ExplainLoading) {
      return Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF13132A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E1E35)),
        ),
        child: Column(
          children: [
            const CircularProgressIndicator(color: Color(0xFF6C63FF)),
            const SizedBox(height: 14),
            Text('AI is thinking...',
                style: GoogleFonts.poppins(
                    color: const Color(0xFF888888), fontSize: 14)),
            const SizedBox(height: 4),
            Text('This may take up to 30 seconds',
                style: GoogleFonts.poppins(
                    color: const Color(0xFF555577), fontSize: 12)),
          ],
        ),
      );
    }

    if (_explainState is _ExplainError) {
      final msg = (_explainState as _ExplainError).message;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935).withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: const Color(0xFFE53935).withAlpha(60), width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Color(0xFFE53935), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(msg,
                  style: GoogleFonts.poppins(
                      color: const Color(0xFFFF8A80), fontSize: 13)),
            ),
            TextButton(
              onPressed: _explainWithAI,
              child: Text('Retry',
                  style: GoogleFonts.poppins(
                      color: const Color(0xFF6C63FF),
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ),
          ],
        ),
      );
    }

    if (_explainState is _ExplainSuccess) {
      final result = (_explainState as _ExplainSuccess).result;
      return TabOutputWidget(explanation: result);
    }

    return const SizedBox.shrink();
  }
}
