import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beads_out/app/app.dart';
import 'package:beads_out/app/dependency_injection.dart';
import 'package:beads_out/services/analytics_service.dart';
import 'package:beads_out/services/feedback_service.dart';
import 'package:beads_out/services/firebase_service.dart';

void main() {
  testWidgets('Beads Out app renders splash', (WidgetTester tester) async {
    final firebaseService = FirebaseService();
    final analyticsService = AnalyticsService(firebaseService);

    final feedbackService = FeedbackService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          firebaseServiceProvider.overrideWithValue(firebaseService),
          analyticsServiceProvider.overrideWithValue(analyticsService),
          feedbackServiceProvider.overrideWithValue(feedbackService),
        ],
        child: const BeadsOutApp(),
      ),
    );

    expect(find.text('BEADS OUT'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
  });
}
