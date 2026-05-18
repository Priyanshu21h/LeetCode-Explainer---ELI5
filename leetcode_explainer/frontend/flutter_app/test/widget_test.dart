import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: LeetCodeExplainerApp()),
    );

    expect(find.text('LeetCode Explainer'), findsOneWidget);
    expect(find.text('Explain'), findsOneWidget);
  });
}
