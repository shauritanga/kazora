import 'package:flutter_test/flutter_test.dart';

import 'package:kazora/app/app.dart';

void main() {
  testWidgets('app builds and shows onboarding', (tester) async {
    await tester.pumpWidget(const KazoraApp());
    await tester.pump();

    // Default test locale is en_US, so the English string is expected.
    expect(find.text('Verified properties only'), findsOneWidget);
  });
}
