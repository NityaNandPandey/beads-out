import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beads_out/app/app.dart';
import 'package:beads_out/app/dependency_injection.dart';
import 'package:beads_out/services/analytics_service.dart';
import 'package:beads_out/services/firebase_service.dart';

void main() {
  testWidgets('Beads Out app renders splash', (WidgetTester tester) async {
    final firebaseService = FirebaseService();
    final analyticsService = AnalyticsService(firebaseService);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          firebaseServiceProvider.overrideWithValue(firebaseService),
          analyticsServiceProvider.overrideWithValue(analyticsService),
        ],
        child: const BeadsOutApp(),
      ),
    );

    expect(find.text('Beads Out'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
  });
}
