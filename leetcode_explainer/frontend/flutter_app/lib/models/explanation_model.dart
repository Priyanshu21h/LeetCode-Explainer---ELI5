class DryRunStep {
  final int step;
  final String line;
  final String state;
  final String note;

  DryRunStep({
    required this.step,
    required this.line,
    required this.state,
    required this.note,
  });

  factory DryRunStep.fromJson(Map<String, dynamic> json) {
    return DryRunStep(
      step: json['step'] as int? ?? 0,
      line: json['line']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
    );
  }
}

class Complexity {
  final String time;
  final String space;

  Complexity({required this.time, required this.space});

  factory Complexity.fromJson(Map<String, dynamic> json) {
    return Complexity(
      time: json['time']?.toString() ?? 'N/A',
      space: json['space']?.toString() ?? 'N/A',
    );
  }
}

class ExplanationModel {
  final String explanation;
  final String eli5;
  final Complexity complexity;
  final List<DryRunStep> dryRun;
  final String keyInsight;

  ExplanationModel({
    required this.explanation,
    required this.eli5,
    required this.complexity,
    required this.dryRun,
    required this.keyInsight,
  });

  factory ExplanationModel.fromJson(Map<String, dynamic> json) {
    return ExplanationModel(
      explanation: json['explanation']?.toString() ?? '',
      eli5: json['eli5']?.toString() ?? '',
      complexity: Complexity.fromJson(
        json['complexity'] as Map<String, dynamic>? ?? {},
      ),
      dryRun: (json['dry_run'] as List<dynamic>?)
              ?.map((e) => DryRunStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      keyInsight: json['key_insight']?.toString() ?? '',
    );
  }
}
