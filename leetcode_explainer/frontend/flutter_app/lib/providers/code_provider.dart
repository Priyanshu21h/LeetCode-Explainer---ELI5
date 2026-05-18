import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/explanation_model.dart';
import '../services/ai_service.dart';

// --- State ---

abstract class CodeState {
  const CodeState();
}

class CodeIdle extends CodeState {
  const CodeIdle();
}

class CodeLoading extends CodeState {
  const CodeLoading();
}

class CodeSuccess extends CodeState {
  final ExplanationModel explanation;
  const CodeSuccess(this.explanation);
}

class CodeError extends CodeState {
  final String message;
  const CodeError(this.message);
}

// --- Notifier ---

class CodeNotifier extends StateNotifier<CodeState> {
  CodeNotifier() : super(const CodeIdle());

  Future<void> explainCode(String code, bool isEli5) async {
    state = const CodeLoading();
    try {
      final result = await AiService.explainCode(code: code, isEli5: isEli5);
      state = CodeSuccess(result);
    } catch (e) {
      state = CodeError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void reset() {
    state = const CodeIdle();
  }
}

// --- Provider ---

final codeProvider = StateNotifierProvider<CodeNotifier, CodeState>(
  (ref) => CodeNotifier(),
);

// --- ELI5 Toggle Provider ---

final eli5Provider = StateProvider<bool>((ref) => false);
